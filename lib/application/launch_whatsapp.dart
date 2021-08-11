import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void launchWhatsApp(
    {@required String phone,
    @required String message,
    @required BuildContext context}) async {
  String url() {
    if (Platform.isIOS) {
      return "whatsapp://wa.me/$phone/?text=${Uri.parse(message)}";
    } else {
      return "whatsapp://send?phone=$phone&text=${Uri.parse(message)}";
    }
  }

  if (await canLaunch(url())) {
    await launch(url());
  } else {
    Scaffold.of(context)
        .showSnackBar(SnackBar(content: Text("App not found!")));
  }
}
