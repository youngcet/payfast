import 'dart:convert';

import 'package:payfast/src/constants.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';

class PayFastApi {
  /// payfast merchant id
  final String merchantId;

  /// payfast merchant key
  final String merchantKey;

  /// payfast passphrase
  final String passPhrase;

  /// use sandbox/live
  final bool useSandBox;

  PayFastApi(
      {required this.merchantId,
      required this.merchantKey,
      required this.useSandBox,
      required this.passPhrase});

  /// get endpoint url
  String get endpointUrl =>
      (useSandBox) ? Constants.apiBaseUrl : Constants.apiBaseUrl;

  /// get ping endpoint url
  String get pingEndpointUrl => (useSandBox)
      ? '${Constants.pingApiUrl}?testing=true'
      : Constants.pingApiUrl;

  /// Sends a ping request to the PayFast API to verify the connection and retrieve a response.
  Future<String> ping() async {
    var jsonResponse = '';

    final headers = {
      'merchant-id': merchantId,
      'version': 'v1',
      'timestamp': DateTime.now().toIso8601String(),
      'passphrase': passPhrase,
    };

    var signature = _generateSignature(headers);
    headers['signature'] = signature;

    var response = await http.get(Uri.parse(pingEndpointUrl), headers: headers);
    if (response.statusCode == 200) {
      jsonResponse = jsonDecode(response.body);
    } else {
      jsonResponse = jsonDecode(response.body);
    }

    return jsonResponse;
  }

  /// Generates an MD5 signature from a map of data by creating a URL-encoded and sorted query string.
  String _generateSignature(Map<String, String> data) {
    var paramString = '';

    data = Map.fromEntries(
      data.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );

    for (var entry in data.entries) {
      if (entry.key != 'signature') {
        paramString += '${entry.key}=${Uri.encodeComponent(entry.value)}&';
      }
    }

    paramString = paramString.substring(0, paramString.length - 1);

    return md5.convert(utf8.encode(paramString)).toString();
  }
}
