import 'package:flutter/material.dart';

class WaitingOverlay extends StatelessWidget {
  /// custom widget
  final Widget? child;

  const WaitingOverlay({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return child ??
        Column(
          children: const [
            SizedBox(height: 60),
            Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.redAccent,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Please wait...',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.none,
                  color: Colors.black),
            ),
          ],
        );
  }
}
