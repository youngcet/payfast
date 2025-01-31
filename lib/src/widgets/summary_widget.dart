import 'package:flutter/material.dart';

import 'payment_summary.dart';

class SummaryWidget extends StatefulWidget {
  final PaymentSummary paymentSummaryWidget;
  final Function onPayButtonPressed;

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

  /// The widget displayed next to the "Pay Now" button.
  ///
  /// You can customize this to match your application’s context or language.
  final Widget? payButtonLeadingWidget;

  const SummaryWidget(
      {super.key,
      required this.paymentSummaryWidget,
      required this.onPayButtonPressed,
      this.payButtonStyle,
      this.payButtonText, 
      this.payButtonLeadingWidget});

  @override
  State<SummaryWidget> createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryWidget> {
  /// A boolean flag to enable or disable the payment button.
  bool _isButtonPressed = false;

  void _processPayment() {
    setState(() => _isButtonPressed = true);

    Future.delayed(
      const Duration(seconds: 2),
      () => widget.onPayButtonPressed(),
    );
  }

  /// A function that returns a widget that is displayed next to the "Pay Now" button.
  ///
  /// You can customize this to match your application’s context or language.
  Widget _icon(){
    return widget.payButtonLeadingWidget ?? Container();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.paymentSummaryWidget,
          const Spacer(), // This pushes the button to the bottom of the screen
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isButtonPressed ? null : _processPayment,
              style: widget.payButtonStyle ??
                  ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.blueAccent,
                  ),
              icon: _isButtonPressed
                  ? Container(
                      width: 24,
                      height: 24,
                      padding: const EdgeInsets.all(2.0),
                      child: const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3,
                      ),
                    )
                  : _icon(),
              label: Text(
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
      ));
  }
}
