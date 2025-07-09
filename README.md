<p align="center">   
    <a href="https://github.com/youngcet/payfast"><img src="https://img.shields.io/github/stars/youngcet/payfast?style=social" alt="Repo stars"></a>
    <a href="https://github.com/youngcet/payfast/commits/main"><img src="https://img.shields.io/github/last-commit/youngcet/payfast/main?logo=git" alt="Last Commit"></a>
    <a href="https://github.com/youngcet/payfast/pulls"><img src="https://img.shields.io/github/issues-pr/youngcet/payfast" alt="Repo PRs"></a>
    <a href="https://github.com/youngcet/payfast/issues?q=is%3Aissue+is%3Aopen"><img src="https://img.shields.io/github/issues/youngcet/payfast" alt="Repo issues"></a>
    <a href="https://github.com/youngcet/payfast/graphs/contributors"><img src="https://badgen.net/github/contributors/youngcet/payfast" alt="Contributors"></a>
    <a href="https://github.com/youngcet/payfast/blob/main/LICENSE"><img src="https://badgen.net/github/license/youngcet/payfast" alt="License"></a>
    <br>       
    <a href="https://app.codecov.io/gh/youngcet/payfast"><img src="https://img.shields.io/codecov/c/github/youngcet/payfast?logo=codecov&logoColor=white" alt="Coverage Status"></a>
</p>

# Payfast Flutter Package

A Flutter package to integrate Payfast payments into your app. **THIS PACKAGE DOES NOT SUPPORT WEB, FOR WEB USE [THIS PACKAGE](https://github.com/youngcet/payfast_web)**. 

[![Pub Version](https://img.shields.io/pub/v/payfast)](https://pub.dev/packages/payfast)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/youngcet/payfast/blob/main/LICENSE)
<a href="https://pub.dev/packages/payfast"><img src="https://badgen.net/pub/points/payfast" alt="Pub points"></a>
<a href="https://pub.dev/packages/payfast"><img src="https://badgen.net/pub/likes/payfast" alt="Pub Likes"></a>
<a href="https://pub.dev/packages/payfast"><img src="https://badgen.net/pub/popularity/payfast" alt="Pub popularity"></a>

<p align="center">
  <img src="https://github.com/youngcet/payfast/blob/main/doc/payfast_demo.gif?raw=true" height="600px">
  <img src="https://github.com/youngcet/payfast/blob/main/doc/payfast_demo_live.gif?raw=true" height="600px">
</p>
<br/>
<hr/>
<br/>

- [Getting Started](#getting-started)
  * [Usage](#usage)
  * [Payfast Onsite Activation Script](#payfast-onsite-activation-script)
    * [Hosting on Gihub](#hosting-on-github)
    * [Hosting on a different server](#hosting-on-a-different-server)
  * [Android & IOS Setup](#android-and-ios-setup)
- [Features](#features)
  * [Onsite Payments](#onsite-payments)
  * [Sandbox or Live Environment integration](#sandbox-or-live-environment-integration)
  * [Customizable Payment Completion & Cancellation Callbacks](#customizable-payment-completion-and-cancellation-callbacks)
  * [Customizable Payment Summary Widget](#customizable-payment-summary-widget)
  * [Customizable Payment Button](#customizable-payment-button)
  * [Customizable Waiting Overlay Widget](#customizable-waiting-overlay-widget)
  * [FlutterFlow Integration](#flutterflow-integration)
  * [Customizable Animation](#customizable-animation)
- [Properties](#properties)
  * [passPhrase](#passphrase)
  * [useSandBox](#usesandbox)
  * [data](#data)
  * [onsiteActivationScriptUrl](#onsiteactivationscripturl)
  * [onPaymentCompleted](#onpaymentcompleted)
  * [onPaymentCancelled](#onpaymentcancelled)
  * [paymentSumarryWidget](#paymentsumarrywidget)
  * [defaultPaymentSummaryIcon](#defaultPaymentSummaryIcon)
  * [paymentSummaryAmountColor](#paymentSummaryAmountColor)
  * [itemSummarySectionLeadingWidget](#itemSummarySectionLeadingWidget)
  * [payButtonStyle](#paybuttonstyle)
  * [payButtonText](#paybuttontext)
  * [paymentCompletedWidget](#paymentcompletedwidget)
  * [paymentCancelledWidget](#paymentcancelledwidget)
  * [waitingOverlayWidget](#waitingoverlaywidget)
  * [backgroundColor](#backgroundcolor)
  * [animatedSwitcherWidget](#animatedswitcherwidget)
  * [onPaymentCompletedShapeBorder](#onpaymentcompletedshapeborder)
  * [onPaymentCancelledShapeBorder](#onpaymentcancelledshapeborder)
  * [paymentCancelledTitle](#paymentcancelledtitle)
  * [paymentCancelledButtonText](#paymentcancelledbuttontext)
  * [paymentCompletedButtonText](#paymentcompletedbuttontext)
  * [paymentCompletedTitle](#paymentcompletedtitle)


## Getting Started

This package uses Payfast's Onsite Payments integration, therefore, you need to host their onsite activiation script. 

## Payfast Onsite Activation Script

### Hosting on Github

> **Note:** You can also host the file on Github Pages

Below are GitHub links that you can use if you prefer not to host the file yourself or need them for development purposes:

- https://youngcet.github.io/sandbox_payfast_onsite_payments/ > use to point to the sandbox
- https://youngcet.github.io/payfast_onsite_payments/ > use to point to the live server

> **Note:** While these links are hosted on GitHub, accessing them through a browser will result in a 404 error from Payfast. This behavior is expected and not an issue.


### Hosting on a different server

Copy the `html` file below and host it on a secure server:


```html
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <script src="https://sandbox.payfast.co.za/onsite/engine.js"></script>
</head>
<body>
    <script>
            // DO NOT MODIFY THE CODE BELOW

            // retrieve the uuid that is passed to this file and send it to PayFast onsite engine
            const queryString = window.location.search;
            const urlParams = new URLSearchParams(queryString);
            const uuid = urlParams.get('uuid');
            
            window.payfast_do_onsite_payment({"uuid":uuid}, function (result) {
                if (result === true) {
                    // Payment Completed
                    location.href = 'completed'; // triggers payment completed widget on app
                }
                else {
                    // Payment Window Closed
                    location.href = 'closed'; // triggers payment cancelled widget on app
                }
            }); 
        </script>
</body>

</html>
```

Alternatively, you can create your own `html` file but make sure to include the tags below (**do not modify the code**):


```html
<script src="https://sandbox.payfast.co.za/onsite/engine.js"></script> 
<script>
    // retrieve the uuid that is passed to this file and send it to PayFast onsite engine
    const queryString = window.location.search;
    const urlParams = new URLSearchParams(queryString);
    const uuid = urlParams.get('uuid');
    
    window.payfast_do_onsite_payment({"uuid":uuid}, function (result) {
        if (result === true) {
            // Payment Completed
            location.href = 'completed'; // triggers payment completed widget on app
        }
        else {
            // Payment Window Closed
            location.href = 'closed'; // triggers payment cancelled widget on app
        }
    }); 
</script>
```

You can also add your URLs like this instead of a callback:
```html
...
<script>
    // DO NOT MODIFY THE CODE BELOW
    
    const queryString = window.location.search;
    const urlParams = new URLSearchParams(queryString);
    const uuid = urlParams.get('uuid');

    window.payfast_do_onsite_payment({
      'uuid':uuid,
      'return_url': 'completed', // DO NOT CHANGE
      'cancel_url': 'closed', // DO NOT CHANGE
       'notify_url': 'insert-your-webhook-url'  // optional: A payment confirmation notification will be sent to the "notify_url" you specified.
    });
</script> 
```

### Payment Confirmation
Payfast will send a payment confirmation notification to the "notify_url" you specified. The full implementation details can be found [here](https://developers.payfast.co.za/docs#step_4_confirm_payment).

To point to a live server, simply change `<script src="https://sandbox.payfast.co.za/onsite/engine.js"></script>` tag to `<script src="https://www.payfast.co.za/onsite/engine.js"></script>`. Take note of the url where the `html` file is hosted, you're going pass it along in the Payfast package. 

We have to host the file because for security reasons 'Onsite Payments' requires that your application be served over HTTPS. For more detailed documentation, please refer to the official [Payfast Onsite Payments documentation](https://developers.payfast.co.za/docs#onsite_payments). 

<p align="left">
<img src="https://github.com/youngcet/payfast/blob/main/doc/sandbox.png?raw=true" alt="Sandbox Screenshot" height="600" width="280" style="border:1px solid grey"/>
<img src="https://github.com/youngcet/payfast/blob/main/doc/live.png?raw=true" alt="Live Screenshot" height="600" width="280" style="border:1px solid grey"/>
</p>

## Usage

Install the library to your project by running: 

```bash
flutter pub add payfast
```

or add the following dependency in your `pubspec.yaml` (replace `^latest_version` with the latest version):


```yaml
dependencies:
  payfast: ^latest_version
```

### Android And IOS Setup


|             | Android | iOS   | macOS  |
|-------------|---------|-------|--------|
| **Support** | SDK 21+ | 12.0+ | 10.14+ |



**Android Setup**

Set `minSdkVersion` in `android/app/build.gradle` to greater than 19:

```groovy
android {
    defaultConfig {
        minSdkVersion 21
    }
}
```

Add `<uses-permission android:name="android.permission.INTERNET" />` permission in `android/app/src/main/AndroidManifest.xml`.

**IOS Setup**

Add the key below in `ios/Runner/Info.plist`

```groovy
<key>io.flutter.embedded_views_preview</key>
<string>YES</string>
```

**Import the package and create a PayFast Widget**

```dart
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:payfast/payfast.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void paymentCompleted(Map<String, dynamic> data){
    // data holds the transaction details
    //print(data); // -> {merchant_id: xxxxxx, merchant_key: xxxxxxxxxxx, name_first: Yung, name_last: Cet, email_address: young.cet@gmail.com, m_payment_id: 915669, amount: 20, item_name: Subscription, payment_uuid: xxx-xxxx-xxxx-xxx, timestamp: 2025-07-09T14:03:58.722463}

    print('payment completed');
  }

  void paymentCancelled(){
    print('payment cancelled');
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        body: Center(
          child: PayFast(
            // all the 'data' fields are required
            data: {
                'merchant_id': '0000000', // Your payfast merchant id (use sandbox details if sandbox is set to true)
                'merchant_key': '000000', // Your payfast merchant key (use sandbox details if sandbox is set to true)
                'name_first': 'Yung', // customer first name
                'name_last': 'Cet',   // customer last name
                'email_address': 'username@domain.com', // email address
                'm_payment_id': '7663668635664', // payment id
                'amount': '50', // amount
                'item_name': '#0000002', // item name (should be one word, no spaces)
            }, 
            passPhrase: 'xxxxxxxxxxxxxxx',  // Your payfast passphrase
            useSandBox: true, // true to use Payfast sandbox, false to use their live server
            // if useSandbox is set to true, use a sandbox link
            // you can use the github link below or provide your own link
            onsiteActivationScriptUrl: 'https://youngcet.github.io/sandbox_payfast_onsite_payments/', // url to the html file
            onPaymentCancelled: paymentCompleted, // callback function for successful payment
            onPaymentCompleted: paymentCancelled, // callback function for cancelled payment
        ),)
      ),
    );
  }
}
```

The code above will show you the screen below:

<img src="https://github.com/youngcet/payfast/blob/main/doc/basic_app_screenshot.png?raw=true" alt="Basic App Screenshot" height="600" width="280"/>



## Features

### Onsite Payments

Integrate PayFast's secure payment engine directly into the checkout page. Important: Please note that this is currently in Beta according to PayFast's documentation, however, it works fine.

### Sandbox or Live Environment integration

Configure whether to use PayFast's sandbox or live server. When you choose to use the sandbox or live server, ensure that the hosted `html` file also points to the server's onsite activation script (`<script src="https://sandbox.payfast.co.za/onsite/engine.js"></script>`) and the PayFast merchant id and key corresponds to the appropiate server.

```dart
PayFast(
    ...
    useSandBox: true, // true to use Payfast sandbox, false to use their live server
) 
```

### Customizable Payment Completion And Cancellation Callbacks

Use the `onPaymentCompleted` and `onPaymentCancelled` properties to handle custom actions after a successful or cancelled payment.

```dart
PayFast(
    ...
    onPaymentCancelled: () {
        // payment cancelled
    },
    onPaymentCompleted: (data) {
        // payment completed
        // data holds the transaction details including the payment uuid
    },
) 
```

<p align="left">
<img src="https://github.com/youngcet/payfast/blob/main/doc/payment_completed.png?raw=true" alt="Payment Completed" width="280" height="600" style="border:1px solid grey"/>
<img src="https://github.com/youngcet/payfast/blob/main/doc/payment_cancelled.png?raw=true" alt="Payment Cancelled" width="280" height="600" style="border:1px solid grey"/>
</p>


You can change the default text of the default widgets using `onPaymentCompletedText` and `onPaymentCancelledText` properties, respectively:

```dart
PayFast(
    ...
    onPaymentCancelledText: 'This payment was cancelled!',
    onPaymentCompletedText: 'Payment received - woohoo!',

    // use below properties to change the shape borders for each widget
    onPaymentCompletedShapeBorder: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: const BorderSide(
        color: Colors.green,
        width: 1, // Border width
      ),
    ),
    onPaymentCancelledShapeBorder: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: const BorderSide(
        color: Colors.redAccent,
        width: 1, // Border width
      ),
    )

) 
```

<p>
<img src="https://github.com/youngcet/payfast/blob/main/doc/payment_completed_text.png?raw=true" alt="Payment Completed Text" width="280" height="600" style="border:1px solid grey"/>
<img src="https://github.com/youngcet/payfast/blob/main/doc/payment_cancelled_text.png?raw=true" alt="Payment Cancelled Text" width="280" height="600" style="border:1px solid grey"/>
</p>


Alternatively, you can override the widgets with your own widget:

**Payment Completed Widget:** Customize the post-payment experience with the `paymentCompletedWidget` property. You can display a custom widget when the payment is successfully completed.

**Payment Cancelled Widget:** Similarly, the `paymentCancelledWidget` allows you to display a custom widget when the payment is cancelled, providing users with clear feedback.

```dart
PayFast(
    ...
    ...
    paymentCompletedWidget: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Payment Completed Successfully!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: (){
            // callback function
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
            backgroundColor: Colors.teal,
          ),
          child: const Text(
            'Continue',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    ),
    paymentCancelledWidget: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Payment Cancelled!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: (){
            // callback function
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
            backgroundColor: Colors.red,
          ),
          child: const Text(
            'Continue',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    ),
) 
```

<p>
<img src="https://github.com/youngcet/payfast/blob/main/doc/payment_completed_widget.png?raw=true" alt="Payment Completed Widget" width="280" height="600" style="border:1px solid grey"/>
<img src="https://github.com/youngcet/payfast/blob/main/doc/payment_cancelled_widget.png?raw=true" alt="Payment Cancelled Widget" width="280" height="600" style="border:1px solid grey"/>
</p>


### Customizable Payment Summary Widget

Provide a custom widget for displaying the payment summary with the `paymentSumarryWidget` property. This allows for full customization of the payment details display. Only the highlighted section can be replaced with a custom widget.

<img src="https://github.com/youngcet/payfast/blob/main/doc/payment_summary.png?raw=true" alt="Payment Summary" width="280"/>



Custom Payment Summary Widget

```dart
PayFast(
    ...
    ...
    paymentSumarryWidget: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Order Summary',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, decoration: TextDecoration.none, color: Colors.black),
        ),
        const SizedBox(height: 10),
        Card(
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: const [
                ListTile(
                  title: Text('Product 1'),
                  trailing: Text('R20.00'),
                ),
                ListTile(
                  title: Text('Product 2'),
                  trailing: Text('R15.00'),
                ),
                Divider(),
                ListTile(
                  title: Text(
                    'Total',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  trailing: Text(
                    'R35.00',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
) 
```


<img src="https://github.com/youngcet/payfast/blob/main/doc/payment_summary_widget.png?raw=true" alt="Payment Summary Custom Widget" width="280"/>


Or modify the default widget using the properties below:

**Payment Summary Title & Icon:** Use the `paymentSummaryTitle` and `defaultPaymentSummaryIcon` properties to customize the title and icon of the payment summary section, ensuring it matches your app's theme.

```dart
PayFast(
    ...
    paymentSummaryTitle: 'Order Summary',
    defaultPaymentSummaryIcon: const Icon(
      Icons.shopping_cart,
      size: 50,
      color: Colors.grey,
    ),
) 
```


<img src="https://github.com/youngcet/payfast/blob/main/doc/payment_summary_text_icon.png?raw=true" alt="Payment Summary Custom Text & Icon" width="280"/>


### Customizable Payment Button

The `payButtonStyle` and `payButtonText` properties allow you to style the "Pay Now" button and change its text and styling, ensuring that it fits seamlessly with your app's design.

```dart
PayFast(
    ...
    payButtonText: 'Checkout >>',
    payButtonStyle: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 16),
      backgroundColor: Colors.black,
      shadowColor: Colors.transparent,
      textStyle: TextStyle(backgroundColor: Colors.black)
    ),
    payButtonLeadingWidget: const Icon(Icons.payments), // set an icon next to the 'button text'
) 
```


<img src="https://github.com/youngcet/payfast/blob/main/doc/customised_pay_button.png?raw=true" alt="Custom Pay Button" width="280"/>



### Customizable Waiting Overlay Widget

Show a custom loading spinner during the payment process with the `waitingOverlayWidget` property, helping users understand that a process is ongoing.


<img src="https://github.com/youngcet/payfast/blob/main/doc/waitingoverlay.png?raw=true" alt="Waiting Overlay Widget" width="280"/>



Custom waitingOverlayWidget:



```dart
PayFast(
    ...
    waitingOverlayWidget: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 20), // Optional spacing from the top
        const Icon(
          Icons.wallet,
          size: 50,
          color: Colors.grey,
        ),
        const SizedBox(height: 20),
        const Text(
          'Please wait...',
          style: TextStyle(
            fontSize: 16,
            decoration: TextDecoration.none,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
) 
```



<img src="https://github.com/youngcet/payfast/blob/main/doc/waiting_overlay_widget.png?raw=true" alt="Waiting Overlay Widget" width="280"/>



### FlutterFlow Integration

**PayFast Flutter Package Integration with FlutterFlow**

FlutterFlow Demo:
https://app.flutterflow.io/share/pay-fast-demo-wgqscg

To integrate with FluterFlow, 

1. Create a new Custom Widget under **Custom Code** in FlutterFlow.
2. Rename the widget to **PayFastWidget**.
3. Under Widget Settings, add the following parameters:

<img src="https://github.com/youngcet/payfast/blob/main/doc/flutterflow_widget_settings.png?raw=true" alt="FlutterFlow Settings" width="280"/>


4. Add **payfast: ^latest_version** to the dependencies and refresh the UI (replace latest_version with the latest version).

<img src="https://github.com/youngcet/payfast/blob/main/doc/flutterflow_dependency.png?raw=true" alt="FlutterFlow Dependency" width="280"/>


5. Copy and paste the code below (**do not use the boilerplate code provided**):

```dart 
// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart'; // Imports other custom widgets
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:payfast/payfast.dart';

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!

class PayFastWidget extends StatefulWidget {
  final String passPhrase;
  final bool useSandBox;
  final dynamic data;
  final Future Function() onPaymentCancelled;
  final Future Function() onPaymentCompleted;
  final String onsiteActivationScriptUrl;

  // fields below are required for a FlutterFlow widget
  final double? width;
  final double? height;

  const PayFastWidget({
    required this.useSandBox,
    required this.passPhrase,
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
    return Material(
      child: Scaffold(
          body: Center(
              child: PayFast(
        data: widget.data,
        passPhrase: widget.passPhrase,
        useSandBox: widget.useSandBox,
        onsiteActivationScriptUrl: widget.onsiteActivationScriptUrl,
        onPaymentCancelled: () => widget.onPaymentCancelled(), 
        onPaymentCompleted: (data) {
          // data holds the transaction details
          widget.onPaymentCompleted();
        }
        paymentSumarryWidget: _paymentSummary(), // pass widget
        // add other parameters as needed
      ))),
    );
  }

  // modify or remove this widget
  // this is only for demostration purposes
  Widget _paymentSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Order Summary',
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.none,
              color: Colors.black),
        ),
        const SizedBox(height: 10),
        Card(
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: const [
                ListTile(
                  title: Text('Product 1'),
                  trailing: Text('R20.00'),
                ),
                ListTile(
                  title: Text('Product 2'),
                  trailing: Text('R15.00'),
                ),
                Divider(),
                ListTile(
                  title: Text(
                    'Total',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  trailing: Text(
                    'R35.00',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
```

The widget is designed to accept only the required parameters, making it simple to configure within the 'Widget Palette'. For additional optional parameters, which are more cosmetic, it is recommended to add them directly in the code. This approach is similar to how the `paymentSummaryWidget` was integrated in the example above.

6. Save and Compile the code. There should be no errors.
7. In the **Widget Palette**, drag and drop the PayFast Widget onto your page. Select the widget and configure the required parameters. For the `onPaymentCancelled` and `onPaymentCompleted` callbacks, add appropriate actions, such as navigating to a specific page or displaying a confirmation message.


**Testing the Payment Flow**

To test the payment flow, make sure that the useSandBox flag is set to true in the PayFast widget.

Use the provided sandbox URL (https://youngcet.github.io/sandbox_payfast_onsite_payments/) or replace it with your own sandbox testing URL. **Deploy the app to an iOS or Android device (emulator) for testing.**


<p>
<img src="https://github.com/youngcet/payfast/blob/main/doc/flutterflow_02.png?raw=true" alt="FlutterFlow PayFast Widget" style="width:100%"/>
</p>



### Customizable Animation

The `animatedSwitcherWidget` object allows you to pass customizable animation duration and transition builder parameters to override the current animation. This uses the `AnimatedSwitcher` animation.

**Parameters**

**Duration**
- **Type:** `Duration?`
- **Description:** Specifies how long the animation should last. Use `null` to allow fallback to default durations elsewhere.

**Transition Builder**
- **Type:** `Widget Function(Widget, Animation<double>)?`
- **Description:** Defines how widgets transition during the animation. Use `null` to apply default transitions like `FadeTransition`.


```dart 
PayFast(
  ...
  animatedSwitcherWidget: AnimatedSwitcherWidget(
    Duration(milliseconds: 300), 
    (child, animation) {
      return FadeTransition(opacity: animation, child: child);
    }
  )
)
```



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


## Conclusion

This package allows you to easily integrate Payfast into your Flutter project and FlutterFlow. The integration can be fully customized to match your app's payment requirements. For production, ensure that you replace the sandbox configuration with live credentials and URLs.


## Contributing

### Github Repository
If you have ideas or improvements for this package, we welcome contributions. Please open an issue or create a pull request on our [GitHub repository](https://github.com/youngcet/payfast).

### Join Our Community on Discord! 🎮

Looking for support, updates, or a place to discuss the **PayFast Flutter Package**? Join our dedicated Discord channel!

👉 [Join the `#payfast-flutter-package` channel](https://discord.gg/n35vTTHY)

### What You'll Find:
- **Help & Support**: Get assistance with integrating and using the package.
- **Feature Discussions**: Share ideas for new features or improvements.
- **Bug Reports**: Report issues and collaborate on fixes.
- **Community Interaction**: Engage with fellow developers working on Flutter projects.

We look forward to seeing you there! 🚀

## License

This package is available under the [MIT License](https://github.com/youngcet/payfast/blob/main/LICENSE).

Support the plugin <a href="https://www.buymeacoffee.com/yungcet" target="_blank"><img src="https://i.imgur.com/aV6DDA7.png" alt="Buy Me A Coffee" style="height: 41px !important;width: 174px !important; box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;-webkit-box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;" > </a>