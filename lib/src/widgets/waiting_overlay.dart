import 'package:flutter/material.dart';

/// A widget that displays a loading overlay with a progress indicator.
///
/// The `WaitingOverlay` widget is typically used to show a loading state,
/// usually while waiting for a process or network request to complete. If no
/// custom widget is provided, it displays a `CircularProgressIndicator` and
/// a "Please wait..." message.
///
/// ## Parameters:
/// - [child]: An optional custom widget to display instead of the default
///   loading overlay. If no [child] is provided, the default overlay will be shown.
class WaitingOverlay extends StatelessWidget {
  /// An optional custom widget that will be displayed instead of the default
  /// loading overlay.
  final Widget? child;

  const WaitingOverlay({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return child ??
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 100),
            const Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.redAccent,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Please wait...',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.normal),
            ),
          ],
        );
  }
}
