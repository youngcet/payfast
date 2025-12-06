import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:payfast/src/constants.dart';
import 'payment_summary.dart';

/// A widget that displays a payment summary and provides
/// one or both payment actions: **"Pay Now" button** or
/// **"Slide to Pay" gesture**.
///
/// This widget handles payment initiation, disabling input
/// while processing, and showing a loading indicator.
///
/// You can customize the button's appearance, text,
/// and behavior via the provided parameters.
class SummaryWidget extends StatefulWidget {
  /// The widget displaying the payment summary details.
  final PaymentSummary paymentSummaryWidget;

  /// Callback triggered when the payment action is executed.
  ///
  /// This is called after the button is pressed or the
  /// slide-to-pay gesture completes successfully.
  final Function onPayButtonPressed;

  /// Custom style for the "Pay Now" button.
  ///
  /// If `null`, a default style (red background, white text)
  /// is used.
  final ButtonStyle? payButtonStyle;

  /// The label text displayed on the "Pay Now" button.
  ///
  /// Defaults to `'Pay Now'` if not specified.
  final String? payButtonText;

  /// An optional widget displayed next to the "Pay Now" button text.
  ///
  /// You can use this to display an icon, logo, or progress indicator.
  final Widget? payButtonLeadingWidget;

  /// Whether to use the **slide-to-pay** gesture instead of a button.
  ///
  /// Defaults to `true`. If set to `true`, users must
  /// slide the handle from left to right to initiate payment.
  final bool useSwipeToPay;

  const SummaryWidget({
    super.key,
    required this.paymentSummaryWidget,
    required this.onPayButtonPressed,
    this.payButtonStyle,
    this.payButtonText,
    this.payButtonLeadingWidget,
    this.useSwipeToPay = true,
  });

  @override
  State<SummaryWidget> createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryWidget> {
  /// Indicates whether a payment process is currently running.
  ///
  /// While `true`, the button or slider is disabled to
  /// prevent multiple submissions.
  bool _isProcessing = false;

  /// Represents the current horizontal drag offset (for swipe-to-pay mode).
  double _dragPosition = 0.0;

  /// Executes the payment callback safely and disables user interaction
  /// during the process.
  ///
  /// Provides haptic feedback and visual indication of progress.
  Future<void> _processPayment() async {
    if (_isProcessing) return; // Prevent double-trigger

    setState(() => _isProcessing = true);
    HapticFeedback.mediumImpact();

    await widget.onPayButtonPressed();
  }

  /// Returns the leading widget for the pay button, or an empty container if none is provided.
  Widget _icon() => widget.payButtonLeadingWidget ?? Container();

  @override
  Widget build(BuildContext context) {
    final double buttonWidth = MediaQuery.of(context).size.width - 40;
    const double handleSize = 60.0;

    return Container(
      color: Constants.lightBackground,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.paymentSummaryWidget,
          const Spacer(),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: _isProcessing
                ? Container(
                    width: double.infinity,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(35),
                    ),
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                  )
                : widget.useSwipeToPay
                ? Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Constants.redPrimary,
                          borderRadius: BorderRadius.circular(35),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          widget.payButtonText ?? 'Slide to Pay',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),

                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 100),
                        left: _dragPosition,
                        top: 0,
                        bottom: 0,
                        child: GestureDetector(
                          onHorizontalDragUpdate: (details) {
                            if (_isProcessing) return;
                            setState(() {
                              _dragPosition += details.delta.dx;
                              _dragPosition = _dragPosition.clamp(
                                0,
                                buttonWidth - handleSize,
                              );
                            });
                          },
                          onHorizontalDragEnd: (details) {
                            if (_isProcessing) return;
                            if (_dragPosition > buttonWidth * 0.75) {
                              setState(
                                () => _dragPosition = buttonWidth - handleSize,
                              );
                              _processPayment();
                            } else {
                              setState(() => _dragPosition = 0.0);
                            }
                          },
                          child: Container(
                            width: handleSize,
                            height: 70,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(35),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 4,
                                  offset: const Offset(2, 2),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.arrow_forward,
                              color: Colors.redAccent,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isProcessing ? null : () => _processPayment(),
                      style:
                          widget.payButtonStyle ??
                          ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: Constants.redPrimary,
                            shadowColor: Colors.transparent,
                            disabledBackgroundColor: Constants.redPrimary
                                .withValues(alpha: 0.5),
                          ),
                      icon: _icon(),
                      label: Text(
                        widget.payButtonText ?? 'Pay Now',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
          ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
