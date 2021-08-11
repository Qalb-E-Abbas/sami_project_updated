import 'package:flutter/material.dart';
import 'package:sami_project/presentations/common/appButton.dart';
import 'package:sami_project/presentations/common/dynamicFontSize.dart';
import 'package:sami_project/configurations/AppColors.dart';
import 'package:sami_project/presentations/common/vertical_sized_box.dart';
import 'package:sami_project/presentations/StartupScreens/register_screen.dart';

import 'register_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [

              Container(
                height: MediaQuery.of(context).size.height * 0.5,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/our-students.png'),
                    fit: BoxFit.fill
                  )
                ),
              ),


              VerticalSpace(MediaQuery.of(context).size.height * 0.1),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: DynamicFontSize(label: 'Welcome to tutorpedia where you will learn world class education.',
                    fontSize: 20,),
              ),

              VerticalSpace(MediaQuery.of(context).size.height * 0.15),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child:AppButton(
                  onTap: ()=> Navigator.of(context).push(
                      MaterialPageRoute(builder: (builder)=> RegisterScreen())),
                  label: 'Get started', colorText: '#3B7AF8',),
              ),

              VerticalSpace(20),

            ],
          ),
        ),
      )
    );
  }
}
