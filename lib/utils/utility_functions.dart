import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UtilityFunctions {
  static openUrl(String url) async {
    try {
      Uri uri = Uri.parse(url);
      if (!await launchUrl(uri)) {
        throw Exception('Could not launch $uri');
      }
    } catch (e) {
      debugPrint('error while launching url: $e');
    }
  }
}
