import 'package:flutter/material.dart';
import 'package:sami_project/presentations/AuthScreens/studentLogin.dart';
import 'package:sami_project/presentations/AuthScreens/teacher_registration.dart';

class BothApps extends StatelessWidget {
  const BothApps({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          RaisedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => StudentLogin()));
            },
            child: Text("Students"),
          ),
          RaisedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TeacherRegistration()));
            },
            child: Text("Teachers"),
          ),
        ],
      ),
    );
  }
}
