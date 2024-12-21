import 'package:flutter/material.dart';

/// A widget that represents a payment completion state.
///
/// This widget is used to display a message and an optional custom layout when a payment
/// has been completed successfully. It provides a default UI with a success icon, message,
/// and a button to continue the flow.
///
/// You can customize the displayed content by providing a child widget or modifying
/// the success message.
///
/// ## Parameters:
///
/// - [onPaymentCompletedText]: Optional text displayed when the payment is successfully completed.
///   Defaults to a thank-you message for the user.
/// - [onPaymentCompleted]: A required callback function that is executed when the
///   "Continue" button is pressed.
/// - [child]: An optional custom widget to replace the default UI. If provided, the
///   child widget will be rendered instead of the default card layout.
/// - [ShapeBorder]: An optional property that defines the shape of the widget's border.
class PaymentCompleted extends StatelessWidget {
  /// The message displayed when the payment is completed successfully.
  final String? onPaymentCompletedText;

  /// A callback function executed when the "Continue" button is pressed.
  final Function onPaymentCompleted;

  /// An optional custom widget to replace the default layout.
  final Widget? child;

  /// An optional property that defines the shape of the widget's border.
  final ShapeBorder? shape;

  const PaymentCompleted(
      {super.key,
      this.onPaymentCompletedText,
      required this.onPaymentCompleted,
      this.child,
      this.shape});

  @override
  Widget build(BuildContext context) {
    return child ??
        Card(
          shape: shape ??
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(
                  color: Colors.green,
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
                  const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 100,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Payment Successful!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    onPaymentCompletedText ??
                        'Thank you for your payment. Your transaction\nwas completed successfully.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      onPaymentCompleted();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                      backgroundColor: Colors.green,
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
