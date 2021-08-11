import 'package:flutter/material.dart';
import 'package:sami_project/presentations/common/appButton.dart';
import 'package:sami_project/presentations/common/dynamicFontSize.dart';
import 'package:sami_project/configurations/AppColors.dart';
import 'package:sami_project/presentations/common/vertical_sized_box.dart';
import 'package:sami_project/presentations/common/appButton.dart';
import 'package:sami_project/presentations/AuthScreens/student_registration.dart';
import 'package:sami_project/presentations/AuthScreens/teacher_registration.dart';

import '../AuthScreens/teacherLoginScreen.dart';
import '../AuthScreens/studentLogin.dart';
import '../AuthScreens/studentLogin.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.scaffoldBackgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Container(
                  height: MediaQuery.of(context).size.height * 0.6,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/our-students.png'),
                          fit: BoxFit.fill
                      )
                  ),
                ),

                VerticalSpace(30),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [


                      DynamicFontSize(label:
                      'Register Yourself',
                        fontSize: 26,),

                      VerticalSpace(40),


                      AppButton(
                        onTap: ()=> Navigator.push(context,
                            MaterialPageRoute(builder: (context) => StudentLogin())),
                        label: 'Student', colorText: '#3B7AF8',),

                      VerticalSpace(20),

                      AppButton(
                        onTap: ()=> Navigator.push(context,
                            MaterialPageRoute(builder: (context) => TeacherLoginScreen())),
                        label: 'Teacher', colorText: '#3B7AF8',)

                    ],
                  )
                ),

                VerticalSpace(40),






              ],
            ),
          ),
        )
    );
  }
}
