import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

const _captionFont = TextStyle(fontSize: 40.0);

Widget buildPlaceholder(text) {
  return Center(
      child: Text(
    text,
    style: _captionFont,
    textAlign: TextAlign.center,
  ));
}

Future openUrl(String url) async {
  if (!await launchUrl(Uri.parse(url))) {
    throw 'Could not launch $url';
  }
}
