import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

class SslPinningHelper {
  static Future<http.Client> get _getIOClient async {
    final sslCert = await rootBundle.load('certificates/tmdb.crt');

    SecurityContext securityContext = SecurityContext(withTrustedRoots: false);
    securityContext.setTrustedCertificatesBytes(sslCert.buffer.asUint8List());

    HttpClient httpClient = HttpClient(context: securityContext);
    httpClient.badCertificateCallback =
        (X509Certificate cert, String host, int port) => false;

    return IOClient(httpClient);
  }

  static Future<http.Client> createClient() async {
    return await _getIOClient;
  }
}
