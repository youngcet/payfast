<p align="center">   
    <a href="https://github.com/youngcet/payfast"><img src="https://img.shields.io/github/stars/youngcet/payfast?style=social" alt="Repo stars"></a>
    <a href="https://github.com/youngcet/payfast/commits/main"><img src="https://img.shields.io/github/last-commit/youngcet/payfast/main?logo=git" alt="Last Commit"></a>
    <a href="https://github.com/youngcet/payfast/pulls"><img src="https://img.shields.io/github/issues-pr/youngcet/payfast" alt="Repo PRs"></a>
    <a href="https://github.com/youngcet/payfast/issues?q=is%3Aissue+is%3Aopen"><img src="https://img.shields.io/github/issues/youngcet/payfast" alt="Repo issues"></a>
    <a href="https://github.com/youngcet/payfast/graphs/contributors"><img src="https://badgen.net/github/contributors/youngcet/payfast" alt="Contributors"></a>
    <a href="https://github.com/youngcet/payfast/blob/main/LICENSE"><img src="https://badgen.net/github/license/youngcet/payfast" alt="License"></a>
    <a href="https://app.codecov.io/gh/youngcet/payfast"><img src="https://img.shields.io/codecov/c/github/youngcet/payfast?logo=codecov&logoColor=white" alt="Coverage Status"></a>
</p>

# PayFast Flutter Package

Integrate **PayFast payments** into your Flutter app with ease. This package is designed for **mobile platforms (Android & iOS)** — if you’re building for the web, check out the [PayFast Web Package](https://github.com/youngcet/payfast_web).

[![Pub Version](https://img.shields.io/pub/v/payfast)](https://pub.dev/packages/payfast)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/youngcet/payfast/blob/main/LICENSE)
<a href="https://pub.dev/packages/payfast"><img src="https://badgen.net/pub/points/payfast" alt="Pub points"></a>
<a href="https://pub.dev/packages/payfast"><img src="https://badgen.net/pub/likes/payfast" alt="Pub Likes"></a>
<a href="https://pub.dev/packages/payfast"><img src="https://badgen.net/pub/popularity/payfast" alt="Pub popularity"></a>

<p align="center">
  <img src="https://github.com/youngcet/payfast/blob/main/doc/payfast_demo.gif?raw=true" height="500px" style="margin-right: 10px; border-radius: 12px; box-shadow: 0px 0px 10px rgba(0,0,0,0.2);">
  <img src="https://github.com/youngcet/payfast/blob/main/doc/payfast_demo_live.gif?raw=true" height="500px" style="border-radius: 12px; box-shadow: 0px 0px 10px rgba(0,0,0,0.2);">
</p>

---

## 📘 Table of Contents

- [Getting Started](#getting-started)
  * [Usage](#usage)
  * [PayFast Onsite Activation Script](#payfast-onsite-activation-script)
    * [Hosting on GitHub](#hosting-on-github)
    * [Hosting on a Different Server](#hosting-on-a-different-server)
  * [Android & iOS Setup](#android-and-ios-setup)
- [Features](#features)
  * [Onsite Payments](#onsite-payments)
  * [Sandbox or Live Environment](#sandbox-or-live-environment-integration)
  * [Customizable Callbacks](#customizable-payment-completion-and-cancellation-callbacks)
  * [Custom Payment Summary Widget](#customizable-payment-summary-widget)
  * [Custom Payment Button](#customizable-payment-button)
  * [Custom Waiting Overlay](#customizable-waiting-overlay-widget)
  * [FlutterFlow Integration](#flutterflow-integration)
  * [Slide to Pay](#slide-to-pay)
  * [Custom Payment Summary UI](#custom-payment-summary-ui)
- [Recurring Billing](#recurring-billing)
- [Handling Errors](#handling-and-understanding-errors)
- [Properties](#properties)

---

## Getting Started

The **PayFast Flutter Package** makes it easy to integrate PayFast’s secure **Onsite Payments** directly into your app. Because this feature requires HTTPS, you’ll need to host a PayFast activation script — details below.

### PayFast Onsite Activation Script

#### Hosting on GitHub

> 💡 You can host the file on **GitHub Pages** for quick setup.

Use these pre-hosted GitHub links for development or testing:

- Sandbox: https://youngcet.github.io/sandbox_payfast_onsite_payments/
- Live: https://youngcet.github.io/payfast_onsite_payments/

> ⚠️ Note: Accessing these links directly in your browser will show a PayFast 404 error. This is expected behavior — not a bug.

#### Hosting on a Different Server

If you prefer hosting it yourself, here’s the **HTML** you’ll need:

```html
<html>
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <script src="https://sandbox.payfast.co.za/onsite/engine.js"></script>
</head>
<body>
  <script>
    // DO NOT MODIFY
    const uuid = new URLSearchParams(window.location.search).get('uuid');
    window.payfast_do_onsite_payment({ uuid }, result => {
      location.href = result ? 'completed' : 'closed';
    });
  </script>
</body>
</html>
```

<p align="center">
  <img src="https://github.com/youngcet/payfast/blob/main/doc/onsite_script_example.png?raw=true" width="600" style="border-radius: 8px; box-shadow: 0px 0px 10px rgba(0,0,0,0.1);">
</p>

**Payment Confirmation:** PayFast will send payment notifications to your `notify_url`. See [official docs](https://developers.payfast.co.za/docs#step_4_confirm_payment) for full details.

To move from **sandbox** to **live**, replace:
```html
<script src="https://sandbox.payfast.co.za/onsite/engine.js"></script>
```
with:
```html
<script src="https://www.payfast.co.za/onsite/engine.js"></script>
```

<p align="center">
<img src="https://github.com/youngcet/payfast/blob/main/doc/sandbox.png?raw=true" height="600" width="280" style="border:1px solid grey; margin-right:10px; border-radius: 8px;"/>
<img src="https://github.com/youngcet/payfast/blob/main/doc/live.png?raw=true" height="600" width="280" style="border:1px solid grey; border-radius: 8px;"/>
</p>

---

## Usage

Install via:

```bash
flutter pub add payfast
```

or add manually to your `pubspec.yaml`:

```yaml
dependencies:
  payfast: ^latest_version
```

### Android & iOS Setup

| Platform | Minimum Version |
|-----------|----------------|
| Android   | SDK 21+        |
| iOS       | 12.0+          |
| macOS     | 10.14+         |

#### Android Setup

In `android/app/build.gradle`:
```groovy
android {
  defaultConfig {
    minSdkVersion 21
  }
}
```

In `AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.INTERNET" />
```

#### iOS Setup

Add to `ios/Runner/Info.plist`:
```xml
<key>io.flutter.embedded_views_preview</key>
<string>YES</string>
```

Then import and use the widget:

```dart
import 'package:payfast/payfast.dart';

PayFast(
  data: {
    'merchant_id': '0000000',
    'merchant_key': '000000',
    'name_first': 'Yung',
    'name_last': 'Cet',
    'email_address': 'username@domain.com',
    'm_payment_id': '7663668635664',
    'amount': '50',
    'item_name': 'Subscription',
  },
  passPhrase: 'xxxxxxxxxxxxxxx',
  useSandBox: true,
  onsiteActivationScriptUrl: 'https://youngcet.github.io/sandbox_payfast_onsite_payments/',
  onPaymentCompleted: (data) => print('Payment completed: $data'),
  onPaymentCancelled: () => print('Payment cancelled'),
)
```

<p align="center">
  <img src="https://github.com/youngcet/payfast/blob/main/doc/basic_app_screenshot.png?raw=true" height="600" width="280" style="border-radius: 8px; box-shadow: 0px 0px 10px rgba(0,0,0,0.15);"/>
</p>

---

## Features

### Onsite Payments
Integrate PayFast’s secure payment engine directly into your checkout page.

<p align="center">
  <img src="https://github.com/youngcet/payfast/blob/main/doc/payment_completed.png?raw=true" width="280" height="600" style="margin-right:10px; border-radius: 8px;"/>
  <img src="https://github.com/youngcet/payfast/blob/main/doc/payment_cancelled.png?raw=true" width="280" height="600" style="border-radius: 8px;"/>
</p>

### Custom Payment Summary Widget

<p align="center">
  <img src="https://github.com/youngcet/payfast/blob/main/doc/payment_summary.png?raw=true" width="280" style="border-radius: 8px;">
</p>

### Custom Payment Button

<p align="center">
  <img src="https://github.com/youngcet/payfast/blob/main/doc/customised_pay_button.png?raw=true" width="280" style="border-radius: 8px;">
</p>

### Custom Waiting Overlay

<p align="center">
  <img src="https://github.com/youngcet/payfast/blob/main/doc/waiting_overlay_widget.png?raw=true" width="280" style="border-radius: 8px;">
</p>

### FlutterFlow Integration

<p align="center">
  <img src="https://github.com/youngcet/payfast/blob/main/doc/flutterflow_02.png?raw=true" width="100%" style="border-radius: 8px;">
</p>

### `useSwipeToPay`

This property enables a **swipe-to-confirm** payment action instead of a simple "Pay Now" button tap.

When `useSwipeToPay` is set to `true`, users must **swipe to complete the payment**, reducing accidental confirmations and adding a more interactive checkout experience.  
When `false`, the package uses the standard tap button.

```dart
PayFast(
  ...
  useSwipeToPay: true, // enable swipe-to-pay instead of tap, default is true
)
```

### `paymentSummaryBuilder`
Use `paymentSummaryBuilder` to dynamically build your payment summary widget instead of modifying parts of the default one.
It accepts a builder function that gives you access to the current payment data, allowing you to display order details, totals, and discounts however you prefer.

```dart
PayFast(
  ...
  paymentSummaryBuilder: (context, data, processPayment) {
    return Column(
      children: [
        Text('Order Summary', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text('Item: ${data['item_name']}'), // data contains payment details supplied in 'data' property
        Text('Amount: R${data['amount']}'),
        ElevatedButton(
          onPressed: processPayment, // pass the processPayment callback to trigger payment
          child: Text('Proceed to Pay'),
        ),
      ],
    );
  },
)
```

---

## Recurring Billing
Supports both **Subscriptions** and **Tokenization** for recurring payments. Includes full PayFast documentation compatibility.

---

## Handling Errors
Use `onError` to gracefully handle errors:

```dart
onError: (error) => print('PayFast Error: $error'),
```

---

## Properties

### `passPhrase`:  
  The passphrase provided by Payfast for security.

### `useSandBox`:  
  A boolean flag to choose between sandbox or live environment.

### `data`:  
  A `Map<String, dynamic>` containing the required payment data. This includes keys like:
  - `merchant_id`
  - `merchant_key`
  - `name_first`
  - `name_last`
  - `amount`
  - `item_name`
  - `m_payment_id`

  optional:
  - `item_description` string, 255 char
    - The description of the item being charged for, or in the case of multiple items the order description.
  - `fica_idnumber` integer, 13 char
    - The Fica ID Number provided of the buyer must be a valid South African ID Number.
  - `cell_number` string, 100 char
    - The customer’s valid cell number. If the email_address field is empty, and cell_number provided, the system will use the cell_number as the username and auto login the user, if they do not have a registered account
  - `email_confirmation` boolean, 1 char
    - Whether to send an email confirmation to the merchant of the transaction. The email confirmation is automatically sent to the payer. 1 = on, 0 = off
  - `confirmation_address` string, 100 char
    - The email address to send the confirmation email to. This value can be set globally on your account. Using this field will override the value set in your account for this transaction.
  - `payment_method` string, 3 char | Not available in Sandbox
    - When this field is set, only the SINGLE payment method specified can be used when the customer reaches Payfast. If this field is blank, or not included, then all available payment methods will be shown.

      The values are as follows:
        - ‘ef’ – EFT
        - ‘cc’ – Credit card
        - ‘dc’ – Debit card
        - ’mp’ – Masterpass Scan to Pay
        - ‘mc’ – Mobicred
        - ‘sc’ – SCode
        - ‘ss’ – SnapScan
        - ‘zp’ – Zapper
        - ‘mt’ – MoreTyme
        - ‘rc’ – Store card
        - ‘mu’ – Mukuru
        - ‘ap’ – Apple Pay
        - ‘sp’ – Samsung Pay
        - ‘cp’ – Capitec Pay


### `onsiteActivationScriptUrl`:  
  The html file URL used for onsite payment activation.

  Below are GitHub links that you can use if you prefer not to host the file yourself or need them for development purposes:

- https://youngcet.github.io/sandbox_payfast_onsite_payments/ > use to point to the sandbox
- https://youngcet.github.io/payfast_onsite_payments/ > use to point to the live server

### `onPaymentCompleted`:  
  A callback function to handle payment completion.

### `onPaymentCancelled`:  
  A callback function to handle payment cancellation.

### `paymentSumarryWidget`:  
  A custom widget to display the payment summary before the user proceeds with the payment.

### `defaultPaymentSummaryIcon`:
  An icon to display next to the payment summary item details.

### `paymentSummaryAmountColor`:
  The amount text color on the payment summary page

### `itemSummarySectionLeadingWidget`:
  A custom widget to display next to the payment summary item details.

### `payButtonStyle`:  
  The style of the "Pay Now" button.

### `payButtonText`:  
  The text displayed on the "Pay Now" button.

### `payButtonLeadingWidget`:
  The widget displayed next to the "Pay Now" button.

### `paymentCompletedWidget`:  
  A custom widget to show after the payment is successfully completed.

### `paymentCancelledWidget`:  
  A custom widget to show if the payment is cancelled.

### `waitingOverlayWidget`:  
  A custom widget to show a loading spinner during payment processing.

### `backgroundColor`:  
  A background color of the payment summary page

### `animatedSwitcherWidget`:
The `animatedSwitcherWidget` object allows you to pass customizable animation duration and transition builder parameters to override the current animation. This uses the `AnimatedSwitcher` animation.

**Parameters**

**Duration**
- **Type:** `Duration?`
- **Description:** Specifies how long the animation should last. Use `null` to allow fallback to default durations elsewhere.

**Transition Builder**
- **Type:** `Widget Function(Widget, Animation<double>)?`
- **Description:** Defines how widgets transition during the animation. Use `null` to apply default transitions like `FadeTransition`.

### `onPaymentCompletedShapeBorder`
An optional property that defines the shape of the `onPaymentCompleted` widget's border.

### `onPaymentCancelledShapeBorder`
An optional property that defines the shape of the `onPaymentCancelled` widget's border.

### `paymentCancelledButtonText`
An optional text displayed on the button on the payment cancelled screen (default text is continue).

### `paymentCancelledTitle`
An optional text displayed at the top of the payment cancelled screen.

### `paymentCompletedButtonText`
An optional text displayed on the button on the payment completed screen (default text is continue).

### `paymentCompletedTitle`
An optional text displayed at the top of the payment completed screen.

### `summaryHeaderDecoration`
Optional decoration for the payment summary header section.

### `summaryFooterDecoration`
Optional decoration for the payment summary footer section.

### `summaryHeaderStyle`
Optional style for the payment summary header section.

### `summaryFooterTotalTextStyle`
Optional style for the payment summary footer total section.

### `summaryFooterAmountTextStyle`
Optional style for the payment summary footer amount section.

### `useSwipeToPay`

This property enables a **swipe-to-confirm** payment action instead of a simple "Pay Now" button tap.

### `paymentSummaryBuilder`
Use `paymentSummaryBuilder` to dynamically build your payment summary widget instead of modifying parts of the default one.

---