import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Future<bool> smsSender({
  @required String phone,
  @required String message,
}) async {
  String url() {
    return 'sms:$phone?body=$message';
  }

  if (await canLaunch(url())) {
    await launch(url());
    return true;
  } else {
    throw 'Could not launch ${url()}';
  }
}
