import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:payfast/payfast.dart';

void main() {
  group('MyApp widget test', () {
    testWidgets('MyApp widget builds correctly', (WidgetTester tester) async {
      await tester.runAsync(() => tester.pumpWidget(MyApp()));
      expect(find.byType(MyApp), findsOneWidget);
    });

    testWidgets('Payment Summary (Pay Now) is rendered correctly',
        (WidgetTester tester) async {
      await tester.runAsync(() => tester.pumpWidget(
          const MaterialApp(home: MyHomePage(title: 'Payfast Widget Demo'))));
      expect(find.text('Pay Now'), findsOneWidget);
    });

    testWidgets('Payment Summary (Payment Details) is rendered correctly',
        (WidgetTester tester) async {
      await tester.runAsync(() => tester.pumpWidget(
          const MaterialApp(home: MyHomePage(title: 'Payfast Widget Demo'))));
      expect(find.text('Payment Details:'), findsOneWidget);
    });

    testWidgets('Payment Summary (Yung Cet) is rendered correctly',
        (WidgetTester tester) async {
      await tester.runAsync(() => tester.pumpWidget(
          const MaterialApp(home: MyHomePage(title: 'Payfast Widget Demo'))));
      expect(find.text('Yung Cet'), findsOneWidget);
    });

    testWidgets('Payment Summary (pid) is rendered correctly',
        (WidgetTester tester) async {
      await tester.runAsync(() => tester.pumpWidget(
          const MaterialApp(home: MyHomePage(title: 'Payfast Widget Demo'))));
      expect(find.text('#0000002'), findsOneWidget);
    });
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Payfast Widget Demo',
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
  const MyHomePage({super.key, required this.title, this.processPayment});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  final Function? processPayment;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  
  @override
  void initState() {
    super.initState();

  }

  void _ping()async {
    var payfast = PayFastApi(
      merchantId: '', 
      merchantKey: '', 
      passPhrase: '', 
      useSandBox: true
    );
    
    String ping = await payfast.ping();
    print(ping);
  }

  String _randomId(){
    var rng = Random();
    var code = rng.nextInt(900000) + 100000;

    return '$code';
  }

  void closeModal(){
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
        body: Center(
          child: PayFast(
              data: {
                'merchant_id': '0000000', 
                'merchant_key': '000000',
                'name_first': 'Yung',
                'name_last': 'Cet',
                'email_address': 'young.cet@gmail.com',
                'm_payment_id': _randomId(),
                'amount': '50',
                'item_name': '#0000002',
              }, 
              passPhrase: 'uRDAPr2pjfNTqXad6w0r', 
              useSandBox: true,
              onsiteActivationScriptUrl: 'http://somedomain.com',
              onPaymentCancelled: () => closeModal(),
              onPaymentCompleted: () => closeModal(),
            ),
        ),
      ),
    );
  }
}