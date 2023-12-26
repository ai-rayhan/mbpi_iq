  import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> launchurl(Uri url) async {
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }


  Future<void> makePhoneCall(String phoneNumber,context) async {
    try {
      final Uri launchUri = Uri(
        scheme: 'tel',
        path: phoneNumber,
      );
      await launchUrl(launchUri);
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("You device don't support launching another app")));
    }
  }

  Future<void> mail(String tergetEmail,context) async {
    try {
      String email = Uri.encodeComponent(tergetEmail);
      String subject = Uri.encodeComponent("About Quran App");
      String body = Uri.encodeComponent(" ");

      Uri uri = Uri.parse("mailto:$email?subject=$subject&body=$body");
      await launchUrl(uri);
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("You device don't support launching another app")));
    }
  }