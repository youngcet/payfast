import 'package:flutter/material.dart';

/// A widget that displays a summary of the payment details.
///
/// The `PaymentSummary` widget shows the details of a payment, including the
/// product/item information and the total amount. It provides an option to
/// customize the layout with a custom widget (`child`), and allows the use of
/// an optional icon and title.
///
/// ## Parameters:
///
/// - [child]: An optional custom widget to replace the default payment summary layout.
/// - [data]: A map of payment data, typically containing the user's information,
///   item name, and the payment amount.
/// - [icon]: An optional icon to display next to the payment summary, replacing
///   the default shopping bag icon.
/// - [title]: An optional title for the payment details section. Defaults to "Payment Details:".
class PaymentSummary extends StatelessWidget {
  /// An optional custom widget to replace the default layout.
  final Widget? child;

  /// A map containing payment data, such as the user's name, item name, and amount.
  final Map<String, dynamic> data;

  /// An optional icon to display next to the payment summary details.
  /// Defaults to a shopping bag icon.
  final Icon? icon;

  /// An optional title for the payment summary section. Defaults to 'Payment Details:'.
  final String? title;

  /// An optional leading widget to display next to the payment summary details.
  /// Defaults to a shopping bag icon.
  final Widget? itemSectionLeadingWidget;

  /// An optional color set to the amount displayed.
  /// Defaults blue.
  final Color? paymentSummaryAmountColor;

  const PaymentSummary(
      {super.key, this.child, required this.data, this.icon, this.title, this.itemSectionLeadingWidget, this.paymentSummaryAmountColor});

  /// Builds the leading widget for the item section.
  ///
  /// This widget displays a custom leading widget if `itemSectionLeadingWidget` is provided.
  /// Otherwise, it defaults to a container with a background color, rounded corners, 
  /// and either a custom icon or a shopping bag icon.
  Widget _leadingWidget(){
    return itemSectionLeadingWidget ?? Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      child: icon ??
          const Icon(
            Icons.shopping_bag,
            size: 50,
            color: Colors.grey,
          ),
    );
  }

  /// A widget that displays additional text with a small vertical spacer.
  ///
  /// This widget returns a `Column` containing a spacer (`SizedBox`) and a `Text` widget.
  /// The text is styled using the `bodySmall` style from the current theme.
  Widget _additionalText(BuildContext context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 5),
        Text(
          data['additional_text'],
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.normal,
              ),
        ),
      ],
    );

  }

  @override
  Widget build(BuildContext context) {
    return child ??
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Details Section
            Text(
              title ?? 'Payment Details:',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)
            ),
            Divider(
              thickness: 1,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 10),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    _leadingWidget(),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${data['name_first']} ${data['name_last']}',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)
                          ),
                          const SizedBox(height: 5),
                          Text(
                            data['item_name'],
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.normal)
                          ),
                          if (data['additional_text'] != null) _additionalText(context),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Total Amount Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total:',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  'R${data['amount']}',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: paymentSummaryAmountColor ?? Colors.blueAccent),
                ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        );
  }
}
