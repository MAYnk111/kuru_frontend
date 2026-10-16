import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlHelper {
  UrlHelper._();

  static Future<bool> launchWebUrl(BuildContext context, String urlString) async {
    if (urlString.isEmpty) {
      _showErrorSnackBar(context, 'No source URL provided.');
      return false;
    }

    try {
      final uri = Uri.parse(urlString);
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched && context.mounted) {
        _showErrorSnackBar(context, 'Could not open listing: $urlString');
      }
      return launched;
    } catch (e) {
      if (context.mounted) {
        _showErrorSnackBar(context, 'Invalid URL: $urlString');
      }
      return false;
    }
  }

  static void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade800,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
