import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:payfast/src/animation/my_animated_switcher.dart';
import 'package:payfast/src/constants.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:payfast/src/widgets/on_payment_cancelled.dart';
import 'package:payfast/src/widgets/on_payment_completed.dart';
import 'package:payfast/src/widgets/payment_summary.dart';
import 'package:payfast/src/widgets/summary_widget.dart';
import 'package:payfast/src/widgets/waiting_overlay.dart';
import 'package:webview_flutter/webview_flutter.dart';

// #docregion platform_imports
// Import for Android features.
import 'package:webview_flutter_android/webview_flutter_android.dart';
// Import for iOS features.
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

/// The `PayFast` class is a stateful widget designed to integrate
/// PayFast's payment processing system into a Flutter application.
///
/// This widget provides a fully customizable payment interface,
/// allowing developers to easily integrate both sandbox and live
/// environments of the PayFast API.
///
/// ### Features
/// - Secure payment integration using passphrases.
/// - Support for sandbox and live environments.
/// - Configurable payment buttons and overlays.
/// - Callback functions for payment success or cancellation.
/// - Validation of required data fields and URLs.
/// - Dynamic WebView for handling payment sessions.
///
/// ### Parameters
///
/// - **[passPhrase]** *(String)*: The PayFast passphrase required for securing
///   the payment process. This is mandatory.
///
/// - **[useSandBox]** *(bool)*: Indicates whether to use the PayFast sandbox
///   environment for testing. Defaults to `false` for the live environment.
///
/// - **[data]** *(Map<String, dynamic>)*: A map containing payment-related data
///   such as `merchant_id`, `amount`, and `item_name`. The map must include
///   required fields for successful processing.
///
/// - **[payButtonStyle]** *(ButtonStyle?)*: Custom style for the "Pay Now" button.
///   If not provided, a default style is applied.
///
/// - **[payButtonText]** *(String?)*: Text displayed on the "Pay Now" button.
///   Defaults to "Pay Now" if not specified.
///
/// - **[onsiteActivationScriptUrl]** *(String)*: The URL for the PayFast onsite
///   activation script. Must be an absolute HTTPS URL.
///
/// - **[paymentSumarryWidget]** *(Widget?)*: A customizable widget for displaying
///   the payment summary, such as item details and amounts.
///
/// - **[onPaymentCompleted]** *(Function)*: A callback function triggered when
///   the payment is successfully completed.
///
/// - **[onPaymentCancelled]** *(Function)*: A callback function triggered when
///   the payment is cancelled by the user.
///
/// - **[onPaymentCancelledText]** *(String?)*: Optional text displayed when the
///   payment is cancelled. Defaults to a generic cancellation message if not set.
///
/// - **[onPaymentCompletedText]** *(String?)*: Optional text displayed when the
///   payment is completed successfully. Defaults to a generic success message if not set.
///
/// - **[paymentCompletedWidget]** *(Widget?)*: A widget displayed upon successful
///   payment completion, allowing further customization of the success message or view.
///
/// - **[paymentCancelledWidget]** *(Widget?)*: A widget displayed when the payment
///   is cancelled, offering customization for the cancellation view.
///
/// - **[waitingOverlayWidget]** *(Widget?)*: A widget displayed during loading
///   or processing states, such as a spinner or loading indicator.
///
/// - **[paymentSummaryTitle]** *(String?)*: The title text for the payment summary
///   section. Defaults to a generic "Payment Summary" title if not provided.
///
/// - **[defaultPaymentSummaryIcon]** *(Icon?)*: The default icon displayed in the
///   payment summary section. Can be customized to match the app's theme.
///
/// - **[backgroundColor]** *(Icon?)*: The default background color in the
///   payment summary section. Can be customized to match the app's theme.
///
/// ### Example Usage
///
/// ```dart
/// PayFast(
///   passPhrase: 'your-passphrase',
///   useSandBox: true,
///   data: {
///     'merchant_id': '10000100',
///     'merchant_key': '46f0cd694581a',
///     'amount': '100.00',
///     'item_name': 'Test Item',
///     // other required data...
///   },
///   onsiteActivationScriptUrl: 'https://youngcet.github.io/sandbox_payfast_onsite_payments/',
///   onPaymentCompleted: () {
///     print('Payment completed successfully.');
///   },
///   onPaymentCancelled: () {
///     print('Payment was cancelled.');
///   },
/// );
/// ```
///
/// ### Notes
/// - Ensure all required fields are present in the `data` map,
///   including `merchant_id`, `merchant_key`, `amount`, and `item_name`.
/// - The onsite activation script URL must be valid and use HTTPS.

class PayFast extends StatefulWidget {
  /// The passphrase associated with your PayFast account.
  ///
  /// This is used to secure transactions and ensure the integrity of the
  /// payment process. The passphrase must match the one configured in your
  /// PayFast account settings.
  final String passPhrase;

  /// Determines whether to use the PayFast sandbox or live server.
  ///
  /// Set this to `true` for testing in the sandbox environment and `false`
  /// for live transactions. The sandbox environment is used to simulate
  /// transactions without processing real payments.
  final bool useSandBox;

  /// A map containing the necessary payment details.
  ///
  /// This map should include mandatory fields such as:
  /// - `merchant_id`: Your PayFast merchant ID.
  /// - `merchant_key`: Your PayFast merchant key.
  /// - `name_first`: The first name of the payer.
  /// - `name_last`: The last name of the payer.
  /// - `email_address`: The email address of the payer.
  /// - `m_payment_id`: A unique identifier for the payment.
  /// - `amount`: The payment amount.
  /// - `item_name`: A description of the payment item.
  /// Additional fields may be included as per your specific requirements.
  final Map<String, dynamic> data;

  /// The style of the "Pay Now" button.
  ///
  /// Use this to customize the appearance of the button, including its
  /// color, size, padding, and other visual properties. If null, a default
  /// button style is applied.
  final ButtonStyle? payButtonStyle;

  /// The text displayed on the "Pay Now" button.
  ///
  /// If not specified, the default text "Pay Now" will be used. You can
  /// customize this to match your application’s context or language.
  final String? payButtonText;

  /// The URL for the PayFast onsite activation script.
  ///
  /// This script is used to initiate the payment process. The URL must
  /// start with `https` for secure communication. Invalid or insecure
  /// URLs will result in an exception.
  final String onsiteActivationScriptUrl;

  /// A widget to display the payment summary.
  ///
  /// This widget is typically used to show a breakdown of the payment
  /// details, such as item names, quantities, and total amount. You can
  /// provide a custom widget to enhance the user experience.
  final Widget? paymentSumarryWidget;

  /// A callback function invoked when the payment process is completed successfully.
  ///
  /// This function is executed after the user completes the payment on
  /// PayFast and the system confirms the transaction.
  final Function onPaymentCompleted;

  /// A callback function invoked when the payment process is cancelled.
  ///
  /// This function is executed if the user decides to cancel the payment
  /// process. You can use it to handle cancellation logic, such as reverting
  /// changes or showing a message to the user.
  final Function onPaymentCancelled;

  /// Optional text displayed when the payment is cancelled.
  ///
  /// This text provides a message to the user after they cancel the payment
  /// process. If null, no text will be displayed.
  final String? onPaymentCancelledText;

  /// Optional text displayed when the payment is completed successfully.
  ///
  /// This text provides a message to the user after they successfully
  /// complete the payment. If null, no text will be displayed.
  final String? onPaymentCompletedText;

  /// A widget displayed when the payment process is successfully completed.
  ///
  /// This widget can be customized to show a confirmation message, success
  /// icon, or any other content relevant to your application.
  final Widget? paymentCompletedWidget;

  /// A widget displayed when the payment process is cancelled by the user.
  ///
  /// This widget can be customized to show a cancellation message, icon,
  /// or any other content relevant to your application.
  final Widget? paymentCancelledWidget;

  /// A widget displayed as a loading overlay during the payment process.
  ///
  /// This widget provides feedback to the user while the payment is being
  /// processed, such as a spinner or loading animation. If null, no overlay
  /// is displayed.
  final Widget? waitingOverlayWidget;

  /// The title displayed in the payment summary section.
  ///
  /// This title can be used to provide context to the payment summary,
  /// such as "Order Summary" or "Payment Details". If null, no title is
  /// displayed.
  final String? paymentSummaryTitle;

  /// The default icon displayed in the payment summary section.
  ///
  /// This icon is used to visually represent the payment summary. You can
  /// customize it to match your application’s theme or branding.
  final Icon? defaultPaymentSummaryIcon;

  /// The background color for the payment summary widget widget.
  ///
  /// This color is applied to the container wrapping the child widget.
  /// If `null`, no background color will be applied.
  final Color? backgroundColor;

  /// The animatedSwitcherWidget object allows you to pass customizable animation duration
  /// and transition builder parameters to override the current animation.
  /// This uses the AnimatedSwitcher animation.
  final AnimatedSwitcherWidget? animatedSwitcherWidget;

  /// An optional property that defines the shape of the `onPaymentCompleted` widget's border.
  final ShapeBorder? onPaymentCompletedShapeBorder;

  /// An optional property that defines the shape of the `onPaymentCancelled` widget's border.
  final ShapeBorder? onPaymentCancelledShapeBorder;

  /// An optional leading widget to display next to the payment summary details.
  /// Defaults to a shopping bag icon.
  final Widget? itemSummarySectionLeadingWidget;

  /// The icon displayed on the "Pay Now" button.
  ///
  /// You can customize this to match your application’s context or language.
  final Widget? payButtonLeadingWidget;

  /// An optional color set to the amount displayed.
  /// Defaults blue.
  final Color? paymentSummaryAmountColor;

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
    this.backgroundColor,
    this.animatedSwitcherWidget,
    this.onPaymentCompletedShapeBorder,
    this.onPaymentCancelledShapeBorder, 
    this.itemSummarySectionLeadingWidget, 
    this.payButtonLeadingWidget, this.paymentSummaryAmountColor,
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
  State<PayFast> createState() => _PayFastState();
}

class _PayFastState extends State<PayFast> {
  /// WebView controller used to control and interact with the WebView instance.
  late final WebViewController _controller;

  /// Payment identifier (UUID) that uniquely identifies each payment transaction.
  var paymentIdentifier = '';

  /// A dynamic widget that holds the WebView or any other widget to be displayed.
  Widget? _showWebViewWidget;

  /// Unique key used for identifying and managing the widget's state in the widget tree.
  final UniqueKey _key = UniqueKey();

  /// A boolean flag to show or hide the loading spinner during payment processing.
  bool _showSpinner = false;

  @override
  void initState() {
    super.initState();

    _validate();
  }

  /// Validates specific fields to ensure they meet required criteria.
  ///
  /// This method checks the following:
  /// 1. The `onsiteActivationScriptUrl` field must be a valid URL with an absolute path.
  /// 2. The `onsiteActivationScriptUrl` must start with `https` to ensure secure communication.
  ///
  /// If the `onsiteActivationScriptUrl` fails validation, an exception is thrown, indicating
  /// the URL is invalid. This ensures that the PayFast integration functions correctly and
  /// securely.
  void _validate() {
    bool _validURL =
        Uri.tryParse(widget.onsiteActivationScriptUrl)?.hasAbsolutePath ??
            false;
    if (!_validURL || !widget.onsiteActivationScriptUrl.startsWith('https')) {
      throw Exception('onsiteActivationScriptUrl URL not valid');
    }
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

  /// Generates an MD5 signature for the given data map.
  ///
  /// The signature is created by:
  /// 1. Sorting the map entries alphabetically by key.
  /// 2. Concatenating the key-value pairs into a query string format.
  /// 3. Encoding the string with MD5.
  ///
  /// [data] is the input map containing the data to be signed.
  /// Returns the MD5 hash of the generated parameter string.
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

  /// Displays a WebView for processing payment.
  ///
  /// The WebView loads a payment page using the unique identifier (`uuid`)
  /// retrieved from the payment system. It also handles navigation events,
  /// including tracking loading progress, completed or cancelled payments,
  /// and resource errors.
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
            
          },
          onPageFinished: (String url) {
            
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
            if (request.url.contains(Constants.completed)) {
              setState(() {
                _showWebViewWidget = PaymentCompleted(
                  onPaymentCompleted: widget.onPaymentCompleted,
                  onPaymentCompletedText: widget.onPaymentCompletedText,
                  shape: widget.onPaymentCompletedShapeBorder,
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
                  shape: widget.onPaymentCancelledShapeBorder,
                  child: widget.paymentCancelledWidget,
                );
              });
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
          onUrlChange: (UrlChange change) {
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
    return Container(
        color: widget.backgroundColor ?? Colors.transparent,
        child: Column(
          children: [
            // Show spinner with AnimatedSwitcher
            AnimatedSwitcher(
              duration: widget.animatedSwitcherWidget?.getDuration() ??
                  const Duration(milliseconds: 500),
              transitionBuilder:
                  widget.animatedSwitcherWidget?.getTransitionBuilder() ??
                      (child, animation) {
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 1), // Start off-screen
                            end: Offset.zero, // End on-screen
                          ).animate(animation),
                          child: child,
                        );
                      },
              child: _showSpinner
                  ? WaitingOverlay(
                      key: const ValueKey('WaitingOverlay'),
                      child: widget.waitingOverlayWidget,
                    )
                  : const SizedBox.shrink(),
            ),

            // Content Switcher for WebView or SummaryWidget
            Expanded(
              child: AnimatedSwitcher(
                duration: widget.animatedSwitcherWidget?.getDuration() ??
                    const Duration(milliseconds: 500),
                transitionBuilder:
                    widget.animatedSwitcherWidget?.getTransitionBuilder() ??
                        (child, animation) {
                          return SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0, 1), // Start off-screen
                              end: Offset.zero, // End on-screen
                            ).animate(animation),
                            child: child,
                          );
                        },
                child: _showWebViewWidget != null
                    ? _showWebViewWidget!
                    : SummaryWidget(
                        key: const ValueKey('SummaryWidget'),
                        paymentSummaryWidget: PaymentSummary(
                          data: widget.data,
                          title: widget.paymentSummaryTitle,
                          icon: widget.defaultPaymentSummaryIcon,
                          itemSectionLeadingWidget: widget.itemSummarySectionLeadingWidget,
                          paymentSummaryAmountColor: widget.paymentSummaryAmountColor,
                          child: widget.paymentSumarryWidget,
                        ),
                        onPayButtonPressed: _showWebView,
                        payButtonStyle: widget.payButtonStyle,
                        payButtonText: widget.payButtonText,
                        payButtonLeadingWidget: widget.payButtonLeadingWidget,
                      ),
              ),
            ),
          ],
        ));
  }
}
