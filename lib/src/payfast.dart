import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:payfast/src/constants.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:payfast/src/widgets/on_payment_cancelled.dart';
import 'package:payfast/src/widgets/on_payment_completed.dart';
import 'package:payfast/src/widgets/payment_summary.dart';
import 'package:payfast/src/widgets/waiting_overlay.dart';
import 'package:webview_flutter/webview_flutter.dart';

// #docregion platform_imports
// Import for Android features.
import 'package:webview_flutter_android/webview_flutter_android.dart';
// Import for iOS features.
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class PayFast extends StatefulWidget {
  /// payfast passphrase
  final String passPhrase;

  /// use payfast sandbox or live server
  final bool useSandBox;

  /// payment data
  final Map<String, dynamic> data;

  /// pay button style
  final ButtonStyle? payButtonStyle;

  /// pay button text
  final String? payButtonText;

  /// payfast onsite activation script url
  final String onsiteActivationScriptUrl;

  /// payment summary widget
  final Widget? paymentSumarryWidget;

  /// on payment completed callback function
  final Function onPaymentCompleted;

  /// on payment cancelled callback function
  final Function onPaymentCancelled;

  /// on payment cancelled text
  final String? onPaymentCancelledText;

  /// on payment completed text
  final String? onPaymentCompletedText;

  /// payment completed widget
  final Widget? paymentCompletedWidget;

  /// payment cancelled widget
  final Widget? paymentCancelledWidget;

  /// waiting overlay widget
  final Widget? waitingOverlayWidget;

  /// payment summary title
  final String? paymentSummaryTitle;

  /// default payment summary icon
  final Icon? defaultPaymentSummaryIcon;

  PayFast({
    required this.useSandBox,
    required this.passPhrase,
    required this.data,
    required this.onsiteActivationScriptUrl,
    required this.onPaymentCancelled,
    required this.onPaymentCompleted,
    this.onPaymentCancelledText,
    this.onPaymentCompletedText,
    this.paymentSumarryWidget,
    this.payButtonStyle,
    this.payButtonText,
    this.paymentCompletedWidget,
    this.paymentCancelledWidget,
    this.waitingOverlayWidget,
    this.paymentSummaryTitle,
    this.defaultPaymentSummaryIcon,
    super.key,
  })  : assert(data.containsKey('merchant_id'),
            'Missing required key: merchant_id'),
        assert(data.containsKey('merchant_key'),
            'Missing required key: merchant_key'),
        assert(
            data.containsKey('name_first'), 'Missing required key: name_first'),
        assert(
            data.containsKey('name_last'), 'Missing required key: name_last'),
        assert(data.containsKey('email_address'),
            'Missing required key: email_address'),
        assert(data.containsKey('m_payment_id'),
            'Missing required key: m_payment_id'),
        assert(data.containsKey('amount'), 'Missing required key: amount'),
        assert(
            data.containsKey('item_name'), 'Missing required key: item_name');

  @override
  _PayFastState createState() => _PayFastState();
}

class _PayFastState extends State<PayFast> {
  /// webview controller
  late final WebViewController _controller;

  /// payment identifier (uuid)
  var paymentIdentifier = '';

  /// dynamic widget
  Widget? _showWebViewWidget;

  /// widget key
  final UniqueKey _key = UniqueKey();

  /// show/hide spinner
  bool _showSpinner = false;

  /// pay disable button
  bool _isButtonDisabled = false;

  @override
  void initState() {
    super.initState();

    setState(() {
      _showWebViewWidget = Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PaymentSummary(
              data: widget.data,
              title: widget.paymentSummaryTitle,
              icon: widget.defaultPaymentSummaryIcon,
              child: widget.paymentSumarryWidget,
            ),
            // Pay Now Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isButtonDisabled
                    ? null
                    : () {
                        setState(() {
                          _isButtonDisabled = true;
                        });
                        _showWebView();
                      },
                style: widget.payButtonStyle ??
                    ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.blueAccent,
                    ),
                child: Text(
                  widget.payButtonText ?? 'Pay Now',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  /// A set of gesture recognizers used to handle touch gestures.
  final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers = {
    Factory(() => EagerGestureRecognizer())
  };

  /// get api endpoint
  String get endpointUrl => (widget.useSandBox)
      ? Constants.onsitePaymentSandboxEndpoint
      : Constants.onsitePaymentLiveEndpoint;

  /// Sends a request to the payment endpoint to obtain a payment identifier.
  ///
  /// This asynchronous method prepares the necessary data, generates a signature,
  /// and sends an HTTP POST request to the payment endpoint. The response
  /// is then parsed and returned as a map of key-value pairs.
  Future<Map<String, dynamic>> _requestPaymentIdentifier() async {
    Map<String, dynamic> jsonResponse = {};

    Map<String, dynamic> data = Map.from(widget.data);
    data['passphrase'] = widget.passPhrase;

    var signature = _generateSignature(data);
    data['signature'] = signature;

    String paramString = _dataToString(data);

    var response = await http.post(Uri.parse('$endpointUrl?$paramString'));
    if (response.statusCode == 200) {
      jsonResponse = jsonDecode(response.body);
    } else {
      setState(() {
        _showWebViewWidget = Html(data: response.body);
      });
    }

    return jsonResponse;
  }

  /// Converts a map of key-value pairs into a URL-encoded query string.
  ///
  /// This utility method takes a `Map<String, dynamic>` and generates a string
  /// suitable for use in a URL query or as part of an HTTP request body. Each
  /// key-value pair is concatenated in the format `key=value` and joined by
  /// `&`. Values are URL-encoded to ensure compatibility with web standards.
  String _dataToString(Map<String, dynamic> data) {
    var paramString = '';

    for (var entry in data.entries) {
      paramString += '${entry.key}=${Uri.encodeComponent(entry.value)}&';
    }

    paramString = paramString.substring(0, paramString.length - 1);

    return paramString;
  }

  /// Generates an MD5 signature from a map of data by creating a URL-encoded and sorted query string.
  String _generateSignature(Map<String, dynamic> data) {
    var paramString = '';

    data = Map.fromEntries(
      data.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );

    for (var entry in data.entries) {
      if (entry.key != 'signature') {
        paramString += '${entry.key}=${Uri.encodeComponent(entry.value)}&';
      }
    }

    paramString = paramString.substring(0, paramString.length - 1);

    return md5.convert(utf8.encode(paramString)).toString();
  }

  /// Displays a WebView widget to handle payment interactions with a specified URL.
  void _showWebView() async {
    var response = await _requestPaymentIdentifier();
    paymentIdentifier = response['uuid'];

    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);
    // #enddocregion platform_features

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            debugPrint('WebView is loading (progress : $progress%)');
            if (progress < 100) {
              setState(() {
                _showSpinner = true;
              });
            } else {
              setState(() {
                _showSpinner = false;
              });
            }
          },
          onPageStarted: (String url) {
            debugPrint('Page started loading: $url');
          },
          onPageFinished: (String url) {
            debugPrint('Page finished loading: $url');
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('''
            Page resource error:
              code: ${error.errorCode}
              description: ${error.description}
              errorType: ${error.errorType}
              isForMainFrame: ${error.isForMainFrame}
                      ''');
          },
          onNavigationRequest: (NavigationRequest request) async {
            debugPrint('url loaded: ${request.url}');

            if (request.url.contains(Constants.completed)) {
              setState(() {
                _showWebViewWidget = PaymentCompleted(
                  onPaymentCompleted: widget.onPaymentCompleted,
                  onPaymentCompletedText: widget.onPaymentCompletedText,
                  child: widget.paymentCompletedWidget,
                );
              });
              return NavigationDecision.prevent;
            }

            if (request.url.contains(Constants.closed)) {
              setState(() {
                _showWebViewWidget = PaymentCancelled(
                  onPaymentCancelled: widget.onPaymentCancelled,
                  onPaymentCancelledText: widget.onPaymentCancelledText,
                  child: widget.paymentCancelledWidget,
                );
              });
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
          onUrlChange: (UrlChange change) {
            debugPrint('url change to ${change.url}');
            if (change.url != null) {}
          },
        ),
      )
      ..addJavaScriptChannel(
        'Toaster',
        onMessageReceived: (JavaScriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(message.message),
                behavior: SnackBarBehavior.floating),
          );
        },
      )
      ..loadRequest(Uri.parse(
          '${widget.onsiteActivationScriptUrl}?uuid=$paymentIdentifier'));

    // #docregion platform_features
    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }

    // #enddocregion platform_features
    setState(() {
      _controller = controller;
      //_loadHTMLString(paymentIdentifier);
      _showWebViewWidget = WebViewWidget(
          layoutDirection: Directionality.maybeOf(context) ?? TextDirection.ltr,
          key: _key,
          gestureRecognizers: gestureRecognizers,
          controller: _controller);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_showSpinner) WaitingOverlay(child: widget.waitingOverlayWidget),
        // WebViewWidget fills the remaining space above the button
        if (_showWebViewWidget != null) Expanded(child: _showWebViewWidget!),
      ],
    );
  }
}
