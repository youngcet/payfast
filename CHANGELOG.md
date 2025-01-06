## 0.0.6
- Deprecated
    - **`additional_text`** An optional property that for additional text in `data` object.
        - `merchant_id`
        - `merchant_key`
        - `name_first`
        - `name_last`
        - `amount`
        - `item_name`
        - `m_payment_id`
        - `additional_text` (deprecated)

## 0.0.5

- Added new properties
    - **`additional_text`** An optional property that for additional text in `data` object.
        - `merchant_id`
        - `merchant_key`
        - `name_first`
        - `name_last`
        - `amount`
        - `item_name`
        - `m_payment_id`
        - `additional_text` (optional - used for payment details page)
    - **`defaultPaymentSummaryIcon`** An icon to display next to the payment summary item details.
    - **`itemSummarySectionLeadingWidget`** A custom widget to display next to the payment summary item details.
    - **`paymentSummaryAmountColor`** Set the total amount text color on the payment summary page
- Updated the payment summary details UI.

## 0.0.4

- Added new properties
    - **`onPaymentCompletedShapeBorder`** An optional property that defines the shape of the `onPaymentCompleted` widget's border.

    - **`onPaymentCancelledShapeBorder`** An optional property that defines the shape of the `onPaymentCancelled` widget's border.
    - **`animatedSwitcherWidget`** An optional property that allows you to pass customizable animation duration and transition builder parameters to override the current animation. This uses the `AnimatedSwitcher` animation.
    - **backgroundColor** The background color for the payment summary widget widget.
- Added FlutterFlow integration Widget & demonstration 
- Added animation and transition effects for enhanced UI interactions.


## 0.0.3

- Updated README
- Added **onsiteActivationScriptUrl** Github links to use for development/testing

## 0.0.2

- Specified platforms in pubspec file, pub dev failing to identify the platforms

## 0.0.1

## Features

- **Supports Sandbox and Live Environment:** Configure whether to use PayFast's sandbox or live server.
- **Customizable Payment Button:** Provides a customizable payment button for users to initiate the payment.
- **Payment Summary:** Displays the payment summary widget before the user proceeds to payment.
- **Callbacks for Payment Status:** Customizable callback functions for when the payment is completed or cancelled.
- **Customization:** Fully customizable widgets for the payment flow, including custom widgets for payment cancellation and completion.