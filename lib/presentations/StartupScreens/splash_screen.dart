import 'package:flutter/material.dart';
import 'package:sami_project/presentations/common/dynamicFontSize.dart';
import 'package:sami_project/configurations/AppColors.dart';
import 'package:sami_project/presentations/StartupScreens/welcome_screen.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  @override
  void initState() {

    Future.delayed(Duration(seconds: 2), (){
      Navigator.of(context).push(


          PageRouteBuilder(
              transitionDuration: const Duration(seconds: 2),
              pageBuilder: (_, animation, __){
                return FadeTransition(
                  opacity: animation,
                  child: WelcomeScreen()
                );
              })


      );
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors().colorFromHex(context, '#3B7AF8'),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Image.asset('assets/Tutor logo (1).png',
              height: MediaQuery.of(context).size.height * 0.2,
              width: 150,),


          ],
        ),
      ),
    );
  }
}
