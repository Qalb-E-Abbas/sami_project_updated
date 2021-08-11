import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:sami_project/application/errorStrings.dart';
import 'package:sami_project/application/signUpBusinissLogic.dart';
import 'package:sami_project/configurations/AppColors.dart';
import 'package:sami_project/presentations/common/appButton.dart';
import 'package:sami_project/presentations/common/dialog.dart';
import 'package:sami_project/presentations/common/dynamicFontSize.dart';
import 'package:sami_project/presentations/common/navigation_dialog.dart';
import 'package:sami_project/presentations/common/textfromfield.dart';
import 'package:sami_project/presentations/common/vertical_sized_box.dart';
import 'package:sami_project/infrastructure/models/userModel.dart';
import 'package:sami_project/infrastructure/services/authServices.dart';
import 'package:sami_project/presentations/AuthScreens/studentLogin.dart';

class StudentRegistration extends StatefulWidget {
  const StudentRegistration({Key key}) : super(key: key);

  @override
  _StudentRegistrationState createState() => _StudentRegistrationState();
}

class _StudentRegistrationState extends State<StudentRegistration> {
  TextEditingController _emailController = TextEditingController();

  TextEditingController _pwdController = TextEditingController();
  TextEditingController _cPwdController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _addController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    AuthServices users = Provider.of<AuthServices>(context);
    SignUpBusinessLogic signUp = Provider.of<SignUpBusinessLogic>(context);
    var user = Provider.of<User>(context);
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      body: SafeArea(
        child: LoadingOverlay(
          isLoading: isLoading,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.4,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/our-students.png'),
                            fit: BoxFit.fill)),
                  ),
                  VerticalSpace(20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DynamicFontSize(label: 'Name:', fontSize: 20),
                        VerticalSpace(10),
                        AppTextFormField(
                          hintText: 'sami',
                          validator: (val) =>
                              val.isEmpty ? "Field cannot be empty" : null,
                          controller: _nameController,
                        ),
                        VerticalSpace(10),
                        DynamicFontSize(label: 'Email:', fontSize: 20),
                        VerticalSpace(10),
                        AppTextFormField(
                          hintText: 'sami@gmail.com',
                          validator: (val) =>
                              val.isEmpty ? "Field cannot be empty" : null,
                          controller: _emailController,
                        ),
                        VerticalSpace(10),
                        DynamicFontSize(label: 'Password:', fontSize: 20),
                        VerticalSpace(10),
                        AppTextFormField(
                          hintText: 'Enter Password',
                          validator: (val) =>
                              val.isEmpty ? "Field cannot be empty" : null,
                          controller: _pwdController,
                        ),
                        VerticalSpace(10),
                        DynamicFontSize(
                            label: 'Confirm Password:', fontSize: 20),
                        VerticalSpace(10),
                        AppTextFormField(
                            hintText: 'Re-enter Password',
                            controller: _cPwdController,
                            validator: (val) {
                              if (val.isEmpty) {
                                return "Field cannot be emtpy";
                              } else if (_cPwdController.text !=
                                  _pwdController.text) {
                                return "Confirm Password doest not match";
                              } else {
                                return null;
                              }
                            }),
                        VerticalSpace(10),
                        DynamicFontSize(label: 'Address:', fontSize: 20),
                        VerticalSpace(10),
                        AppTextFormField(
                          hintText: 'KUST, KPK',
                          validator: (val) =>
                              val.isEmpty ? "Field cannot be empty" : null,
                          controller: _addController,
                        ),
                        VerticalSpace(20),
                        InkWell(
                            child: AppButton(
                          label: 'Register',
                          colorText: '#3B7AF8',
                          onTap: () {
                            if (!_formKey.currentState.validate()) {
                              return;
                            }

                            _signUpUser(
                                signUp: signUp, user: user, context: context);
                          },
                        )),
                        VerticalSpace(20),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _signUpUser(
      {BuildContext context,
      @required SignUpBusinessLogic signUp,
      @required User user}) {
    isLoading = true;
    setState(() {});
    signUp
        .registerNewStudent(
            email: _emailController.text,
            password: _pwdController.text,
            studentModel: StudentModel(
              name: _nameController.text,
              email: _emailController.text,
              password: _pwdController.text,
              address: _addController.text,
              role: "S",
            ),
            context: context,
            user: user)
        .then((value) {
      if (signUp.status == SignUpStatus.Registered) {
        isLoading = false;
        setState(() {});
        showNavigationDialog(context,
            message:
                "Thanks for registration. Go to Login to access your dashboard.",
            buttonText: "Go To Login", navigation: () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => StudentLogin()));
        }, secondButtonText: "", showSecondButton: false);
      } else if (signUp.status == SignUpStatus.Failed) {
        showErrorDialog(context,
            message: Provider.of<ErrorString>(context, listen: false)
                .getErrorString());
      }
    });
  }
}
