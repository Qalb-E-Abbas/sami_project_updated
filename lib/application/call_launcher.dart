import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

launchCall(String number) async {
  var url = 'tel:$number';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not make phone call at $url';
  }
}
