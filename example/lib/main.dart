import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:payfast/payfast.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

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
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Payfast Widget Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  String _randomId() {
    var rng = Random();
    var randomNumber = rng.nextInt(900000) + 100000;

    return '$randomNumber';
  }

  void paymentCompleted(Map<String, dynamic> data) {
    print(data);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Payment Successful!'),
          behavior: SnackBarBehavior.floating),
    );

    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => const MyApp()),
    );
  }

  void paymentCancelled() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Payment Cancelled!'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red,
      ),
    );

    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => const MyApp()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    return Material(
      child: Scaffold(
        body: CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            transitionBetweenRoutes: false,
            middle: const Text('Payfast Widget Demo'),
            trailing: GestureDetector(
              child: const Icon(Icons.arrow_forward),
              onTap: () => Navigator.of(context).pushNamed('/thank-you'),
            ),
          ),
          child: SizedBox.expand(
            child: SingleChildScrollView(
              primary: true,
              child: SafeArea(
                bottom: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      title: const Text('Checkout using PayFast >>'),
                      onTap: () => showCupertinoModalBottomSheet(
                        expand: true,
                        bounce: true,
                        enableDrag: true,
                        context: context,
                        backgroundColor: Colors.white,
                        builder: (context) => PayFast(
                          data: {
                            'merchant_id': '00000000',
                            'merchant_key': 'xxxxxxxxx',
                            'name_first': 'Yung',
                            'name_last': 'Cet',
                            'email_address': 'yungcet@permanentlink.co.za',
                            'm_payment_id': DateTime.now().millisecondsSinceEpoch.toString(),
                            'amount': '20',
                            'item_name': 'Test Item',
                          },
                          passPhrase: 'xxxxxxx',
                          useSandBox: true,
                          onsiteActivationScriptUrl:
                              'https://youngcet.github.io/sandbox_payfast_onsite_payments/',
                          onPaymentCancelled: paymentCancelled,
                          onPaymentCompleted: paymentCompleted,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
