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
/// - [child]: An optional custom widget to replace the default UI. If provided, the 
///   child widget will be rendered instead of the default card layout.
/// 
class PaymentCancelled extends StatelessWidget {
  /// The message displayed when the payment is cancelled.
  final String? onPaymentCancelledText;

  /// A callback function executed when the "Continue" button is pressed.
  final Function onPaymentCancelled;

  /// An optional custom widget to replace the default layout.
  final Widget? child;

  const PaymentCancelled(
      {super.key,
      this.onPaymentCancelledText,
      required this.onPaymentCancelled,
      this.child});

  @override
  Widget build(BuildContext context) {
    return child ??
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Cancelled Icon
                  const Icon(
                    Icons.close,
                    color: Colors.redAccent,
                    size: 100,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Payment Cancelled!',
                    style: TextStyle(
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
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      onPaymentCancelled();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                      backgroundColor: Colors.redAccent,
                    ),
                    child: const Text(
                      'Continue',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
  }
}
