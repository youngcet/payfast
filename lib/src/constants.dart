import 'package:flutter/material.dart';

/// A class that contains all the constant values related to the PayFast API and endpoints.
///
/// This class holds static constant strings that are used across the application
/// for connecting to PayFast services, both live and sandbox environments. The constants
/// define the base URLs and endpoints for API calls and onsite payment processing.
class Constants {
  // PayFast API URLs
  /// The base URL for PayFast API used for making general API requests.
  static const String apiBaseUrl = 'https://api.payfast.co.za';

  /// The URL used to ping the PayFast API for health checks or testing connectivity.
  static const String pingApiUrl = 'https://api.payfast.co.za/ping';

  /// The base URL for PayFast's sandbox environment, used for testing transactions.
  static const String sandBoxUrl = 'https://sandbox.payfast.co.za';

  // Onsite PayFast APIs
  /// The endpoint for live onsite payment processing with PayFast.
  static const String onsitePaymentLiveEndpoint =
      'https://www.payfast.co.za/onsite/process';

  /// The endpoint for sandbox onsite payment processing with PayFast, used for testing.
  static const String onsitePaymentSandboxEndpoint =
      'https://sandbox.payfast.co.za/onsite/process';
  
  /// The endpoint for sandbox payment processing with PayFast, used for testing.
  static const String paymentSandboxEndpoint = 'https://sandbox.payfast.co.za/eng/process';

  /// The endpoint for payment processing with PayFast, used for live.
  static const String paymentEndpoint = 'https://www.payfast.co.za/eng/process';

  static const String completed = 'completed';
  static const String closed = 'closed';

  static const List<String> transactionCompletedStatus = [
    '{transaction.completed}',
    'completed',
  ];
  static const List<String> transactionCancelledStatus = [
    '{transaction.cancelled}',
    '{transaction.closed}',
    'closed',
  ];

  static const String additionalText = 'additional_text';

  static const Color darkBlue = Color(0xFF041B2B);
  static const Color redPrimary = Color(0xFFC30017);
  static const Color lightBackground = Color(0xFFF7F9FE);
  static const Color semiTransparentColor = Color.fromRGBO(136, 151, 162, 0.2);
}
