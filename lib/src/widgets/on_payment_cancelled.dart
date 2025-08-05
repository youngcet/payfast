import 'package:flutter/material.dart';

/// A widget that represents a payment cancellation state.
///
/// This widget is used to display a message and an optional custom layout when a payment
/// has been cancelled. It provides a default UI with a cancellation icon, message, and
/// a button to continue the flow.
///
/// You can customize the displayed content by providing a child widget or
/// modifying the cancellation message.
///
/// ## Parameters:
///
/// - [onPaymentCancelledText]: Optional text displayed when the payment is cancelled.
///   Defaults to a detailed message about the cancellation.
/// - [onPaymentCancelled]: A required callback function that is executed when the
///   "Continue" button is pressed.
/// - [paymentCancelledButtonText]: Optional text for the button (default text is continue)
/// - [paymentCancelledTitle]: Optional text displayed at the top of the screen.
/// - [child]: An optional custom widget to replace the default UI. If provided, the
///   child widget will be rendered instead of the default card layout.
/// - [ShapeBorder]: An optional property that defines the shape of the widget's border.
class PaymentCancelled extends StatelessWidget {
  /// The message displayed when the payment is cancelled.
  final String? onPaymentCancelledText;

  /// A callback function executed when the "Continue" button is pressed.
  final Function onPaymentCancelled;

  /// An optional custom widget to replace the default layout.
  final Widget? child;

  /// An optional property that defines the shape of the widget's border.
  final ShapeBorder? shape;

  /// The text displayed on the button (default text is continue).
  final String? paymentCancelledButtonText;

  /// The text displayed at the top of the screen.
  final String? paymentCancelledTitle;

  const PaymentCancelled({
    super.key,
    this.onPaymentCancelledText,
    required this.onPaymentCancelled,
    this.paymentCancelledButtonText,
    this.paymentCancelledTitle,
    this.child,
    this.shape,
  });

  @override
  Widget build(BuildContext context) {
    return child ??
        Card(
          shape:
              shape ??
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(
                  color: Colors.redAccent,
                  width: 1, // Border width
                ),
              ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Cancelled Icon
                  const Icon(Icons.close, color: Colors.redAccent, size: 100),
                  const SizedBox(height: 20),
                  Text(
                    paymentCancelledTitle ?? 'Payment Cancelled!',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    onPaymentCancelledText ??
                        'Your payment was cancelled.\nNo charges were made, and your transaction\nwas not processed.\n\nPlease try again or contact support if you need assistance.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      onPaymentCancelled();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
                      backgroundColor: Colors.redAccent,
                    ),
                    child: Text(
                      paymentCancelledButtonText ?? 'Continue',
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
  }
}
