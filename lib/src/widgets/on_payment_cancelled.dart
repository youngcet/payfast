import 'package:flutter/material.dart';

class PaymentCancelled extends StatelessWidget {
  /// cancelled text
  final String? onPaymentCancelledText;

  /// callback function
  final Function onPaymentCancelled;

  /// custom widget
  final Widget? child;
  
  const PaymentCancelled({
    super.key, 
    this.onPaymentCancelledText, 
    required this.onPaymentCancelled, 
    this.child
  });

  @override
  Widget build(BuildContext context) {
    return child ?? Card(
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
                onPaymentCancelledText ?? 'Your payment was cancelled.\nNo charges were made, and your transaction\nwas not processed.\n\nPlease try again or contact support if you need assistance.',
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
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
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