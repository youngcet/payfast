# Payfast Flutter Package

[![Pub Version](https://img.shields.io/pub/v/payfast)](https://pub.dev/packages/payfast)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/youngcet/payfast/blob/main/LICENSE)
[![Last Commit](https://img.shields.io/github/last-commit/youngcet/payfast/main)](https://github.com/youngcet/payfast/commits/main)
[![Issues](https://img.shields.io/github/issues/youngcet/payfast)](https://github.com/youngcet/payfast/issues)
[![Coverage](https://img.shields.io/codecov/c/github/youngcet/payfast)](https://app.codecov.io/gh/youngcet/payfast)

---
<p align="center">
  <img src="https://github.com/youngcet/payfast/blob/main/doc/payfast_demo.gif?raw=true" height="600px" style="border: 2px solid #ccc; border-radius: 10px; box-shadow: 0 0 8px rgba(0,0,0,0.15);">
  <img src="https://github.com/youngcet/payfast/blob/main/doc/payfast_demo_live.gif?raw=true" height="600px" style="border: 2px solid #ccc; border-radius: 10px; box-shadow: 0 0 8px rgba(0,0,0,0.15);">
</p>

---

## Overview

**Payfast Flutter Package** enables seamless Payfast payment integration for mobile Flutter apps (Android/iOS).  
> ⚠️ Web support is **not included** — use [Payfast Web](https://github.com/youngcet/payfast_web) for web apps.

---

## Installation

```bash
flutter pub add payfast
```

Or manually add:

```yaml
dependencies:
  payfast: ^latest_version
```

---

## Quick Start

Minimal example:

```dart
import 'package:flutter/material.dart';
import 'package:payfast/payfast.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: PayFast(
          data: {
            'merchant_id': '000000',
            'merchant_key': '000000',
            'name_first': 'Yung',
            'name_last': 'Cet',
            'email_address': 'user@domain.com',
            'm_payment_id': '123456',
            'amount': '20',
            'item_name': 'Subscription',
          },
          passPhrase: 'your-passphrase',
          useSandBox: true, // Set to false for production
          onsiteActivationScriptUrl: 'https://youngcet.github.io/sandbox_payfast_onsite_payments/', // ensure that this matches sandbox/live mode
          onPaymentCompleted: (data) => print('Payment completed: $data'), // data contains payment details
          onPaymentCancelled: () => print('Payment cancelled'),
        ),
      ),
    );
  }
}
```

---

## Android & iOS Setup

**Android:**

Set `minSdkVersion` in `android/app/build.gradle` to greater than 19:

Add `<uses-permission android:name="android.permission.INTERNET" />` permission in `android/app/src/main/AndroidManifest.xml`.

**iOS:**

Add the key below in `ios/Runner/Info.plist`

```xml
<key>io.flutter.embedded_views_preview</key>
<string>YES</string>
```

---

## Hosting the Onsite Script

You must host the Payfast Onsite activation script (served over HTTPS).

If you don’t host your own file, you can use:
- Sandbox: `https://youngcet.github.io/sandbox_payfast_onsite_payments/`
- Live: `https://youngcet.github.io/payfast_onsite_payments/`

Alternatively, host your own HTML file using the templates below.

### Sandbox Version
```html
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <script src="https://sandbox.payfast.co.za/onsite/engine.js"></script>
</head>
<body>
    <script>
        // DO NOT MODIFY THIS CODE

        const queryString = window.location.search;
        const urlParams = new URLSearchParams(queryString);
        const uuid = urlParams.get('uuid');

        window.payfast_do_onsite_payment({"uuid": uuid}, function (result) {
            if (result === true) {
                location.href = 'completed'; // triggers completed widget
            } else {
                location.href = 'closed'; // triggers cancelled widget
            }
        });
    </script>
</body>
</html>
```

### Live Version
To switch to live mode, replace the Payfast script URL:

```html
<script src="https://www.payfast.co.za/onsite/engine.js"></script>
```

For full documentation, see [Payfast Onsite Payments Docs](https://developers.payfast.co.za/docs#onsite_payments).

---

## FlutterFlow Integration

You can easily integrate Payfast into **FlutterFlow** using a **Custom Widget**.

### Steps

1. In **FlutterFlow**, go to **Custom Code → Custom Widgets**.
2. Create a new widget named **PayFastWidget**.
3. Add required parameters:
   - `useSandBox` (bool)
   - `passPhrase` (String)
   - `data` (JSON/dynamic)
   - `onsiteActivationScriptUrl` (String)
   - `onPaymentCancelled` (Function)
   - `onPaymentCompleted` (Function)
4. Add dependency:
   ```yaml
   payfast: ^latest_version
   ```
5. Paste this widget code:

```dart
import 'package:flutter/material.dart';
import 'package:payfast/payfast.dart';

class PayFastWidget extends StatefulWidget {
  final String passPhrase;
  final bool useSandBox;
  final dynamic data;
  final Future Function() onPaymentCancelled;
  final Future Function() onPaymentCompleted;
  final String onsiteActivationScriptUrl;

  final double? width;
  final double? height;

  const PayFastWidget({
    required this.passPhrase,
    required this.useSandBox,
    required this.data,
    required this.onsiteActivationScriptUrl,
    required this.onPaymentCancelled,
    required this.onPaymentCompleted,
    this.width,
    this.height,
    Key? key,
  }) : super(key: key);

  @override
  State<PayFastWidget> createState() => _PayFastWidgetState();
}

class _PayFastWidgetState extends State<PayFastWidget> {
  @override
  Widget build(BuildContext context) {
    return PayFast(
      data: widget.data,
      passPhrase: widget.passPhrase,
      useSandBox: widget.useSandBox,
      onsiteActivationScriptUrl: widget.onsiteActivationScriptUrl,
      onPaymentCancelled: () => widget.onPaymentCancelled(),
      onPaymentCompleted: (data) => widget.onPaymentCompleted(),
    );
  }
}
```

6. Save, build, and use the widget in your FlutterFlow project.

> ✅ Use the sandbox URL for testing: `https://youngcet.github.io/sandbox_payfast_onsite_payments/`

---

## Key Features

- Onsite payments (secure checkout inside app)
- Sandbox & Live environments
- Custom payment callbacks
- Custom UI widgets (summary, buttons, overlays)
- FlutterFlow support
- Recurring billing (subscriptions & tokenization)
- Error handling callbacks

---

## Common Properties

| Property | Type | Description |
|-----------|------|-------------|
| `passPhrase` | `String` | Payfast passphrase |
| `useSandBox` | `bool` | Use sandbox (test) mode |
| `data` | `Map<String, dynamic>` | Payment details (amount, merchant info, etc.) |
| `onsiteActivationScriptUrl` | `String` | Hosted Payfast script URL |
| `onPaymentCompleted` | `Function(Map data)` | Callback after success |
| `onPaymentCancelled` | `Function()` | Callback after cancel |
| `waitingOverlayWidget` | `Widget` | Custom loading UI |
| `paymentSummaryBuilder` | `Widget` | Custom payment summary UI |

---

## Recurring Billing

**Subscriptions Example:**
```dart
PayFast(
  data: {
    'merchant_id': '0000000', 
    'merchant_key': 'xxxxxxxxx', 
    'name_first': 'Yung',
    'name_last': 'Cet',
    'email_address': 'some@domain.com',
    'm_payment_id': '2547855',
    'amount': '20',
    'item_name': 'Subscription',
    // subscription fields
    'subscription_type': '1',
    'billing_date': '2020-01-01', // optional
    'recurring_amount': '123.45', // optional
    'frequency': '3', // see table below
    'cycles': '12',
    'subscription_notify_email': 'true', // optional
    'subscription_notify_webhook': 'true', // optional
    'subscription_notify_buyer': 'true' // optional
  },
  ...
), 
```

#### Frequency

| Value | Frequency  |
|-------|------------|
| 1     | Daily      |
| 2     | Weekly     |
| 3     | Monthly    |
| 4     | Quarterly  |
| 5     | Biannually |
| 6     | Annually   |

**Tokenization Example:**
```dart
PayFast(
  data: {
    'merchant_id': '0000000',
    'merchant_key': 'xxxxxxxxx', 
    'name_first': 'Yung',
    'name_last': 'Cet',
    'email_address': 'some@domain.com',
    'm_payment_id': '2547855',
    'amount': '20',
    'item_name': 'Subscription',
    // subscription fields
    'subscription_type': '2',
  },
  ...
), 
```

See [Payfast Docs](https://developers.payfast.co.za/docs#recurring_billing).

---

## Error Handling

```dart
PayFast(
  ...
  onError: (msg) => print('Error: $msg'),
);
```

## Documentation

[Click here to view the detailed documentation](https://github.com/youngcet/payfast/blob/main/DETAILED.md).

---

## Contributing

Pull requests and issues are welcome on [GitHub](https://github.com/youngcet/payfast).

Join the community on Discord → [#payfast-flutter-package](https://discord.gg/n35vTTHY)

---

## License

[MIT License](https://github.com/youngcet/payfast/blob/main/LICENSE)

Support the project ☕ [Buy Me a Coffee](https://www.buymeacoffee.com/yungcet)
