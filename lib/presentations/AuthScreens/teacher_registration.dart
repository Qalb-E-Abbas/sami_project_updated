import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:sami_project/application/app_state.dart';
import 'package:sami_project/application/errorStrings.dart';
import 'package:sami_project/application/signUpBusinissLogic.dart';
import 'package:sami_project/configurations/AppColors.dart';
import 'package:sami_project/presentations/common/appButton.dart';
import 'package:sami_project/presentations/common/dialog.dart';
import 'package:sami_project/presentations/common/dynamicFontSize.dart';
import 'package:sami_project/presentations/common/navigation_dialog.dart';
import 'package:sami_project/presentations/common/textfromfield.dart';
import 'package:sami_project/presentations/common/vertical_sized_box.dart';
import 'package:sami_project/infrastructure/models/subjectModel.dart';
import 'package:sami_project/infrastructure/models/teacherModel.dart';
import 'package:sami_project/infrastructure/services/authServices.dart';
import 'package:sami_project/infrastructure/services/uploadFileServices.dart';
import 'package:sami_project/presentations/AuthScreens/teacherLoginScreen.dart';
import 'package:sami_project/presentations/common/appButton.dart';

class TeacherRegistration extends StatefulWidget {
  const TeacherRegistration({Key key}) : super(key: key);

  @override
  _TeacherRegistrationState createState() => _TeacherRegistrationState();
}

class _TeacherRegistrationState extends State<TeacherRegistration> {
  Completer<GoogleMapController> _completer = Completer();
  UploadFileServices _uploadFileServices = UploadFileServices();
  bool isChecked = false;
  final _formKey = GlobalKey<FormState>();
  bool isVisible = false;
  File _file;
  TextEditingController _emailController = TextEditingController();

  TextEditingController _pwdController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _qualController = TextEditingController();
  TextEditingController _confirmPwdController = TextEditingController();
  TextEditingController _hourlyController = TextEditingController();
  TextEditingController _contactController = TextEditingController();
  TextEditingController _expController = TextEditingController();
  TextEditingController _bioController = TextEditingController();
  SubjectModel _selectedSubject;
  List<SubjectModel> _subjectList = [
    SubjectModel(subjectID: "1", subjectName: "Maths"),
    SubjectModel(subjectID: "2", subjectName: "Computer"),
    SubjectModel(subjectID: "3", subjectName: "Physics"),
  ];

  bool isLoading = false;

  LatLng _center;
  Position currentLocation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserLocation();
  }

  Future<Position> locateUser() async {
    return Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  getUserLocation() async {
    locateUser().then((value) => print(value.longitude));
    currentLocation = await locateUser();
    setState(() {
      _center = LatLng(currentLocation.latitude, currentLocation.longitude);
    });
    print('center $_center');
  }

  @override
  Widget build(BuildContext context) {
    print(_center);
    AuthServices users = Provider.of<AuthServices>(context);
    SignUpBusinessLogic signUp = Provider.of<SignUpBusinessLogic>(context);
    var user = Provider.of<User>(context);
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      body: SafeArea(
        child: LoadingOverlay(
          isLoading: isLoading,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
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
                          hintText: 'Sami',
                          controller: _nameController,
                          validator: (val) =>
                              val.isEmpty ? "Field cannot be empty" : null,
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
                        DynamicFontSize(label: 'Hourly Rate:', fontSize: 20),
                        VerticalSpace(10),
                        AppTextFormField(
                          hintText: 'PKR',
                          validator: (val) =>
                              val.isEmpty ? "Field cannot be empty" : null,
                          controller: _hourlyController,
                        ),
                        VerticalSpace(10),
                        DynamicFontSize(label: 'Bio:', fontSize: 20),
                        VerticalSpace(10),
                        AppTextFormField(
                          hintText: 'BIO',
                          validator: (val) =>
                              val.isEmpty ? "Field cannot be empty" : null,
                          controller: _bioController,
                        ),


                        // DynamicFontSize(label: 'Location:', fontSize: 20),
                        // VerticalSpace(10),
                        // AppTextFormField(
                        //   hintText: 'Location',
                        //   validator: (val) =>
                        //   val.isEmpty ? "Field cannot be empty" : null,
                        //   controller: _qualController,
                        // ),

                        VerticalSpace(10),
                        DynamicFontSize(label: 'Contact Number:', fontSize: 20),
                        VerticalSpace(10),
                        AppTextFormField(
                          hintText: 'Contact Number',
                          validator: (val) =>
                              val.isEmpty ? "Field cannot be empty" : null,
                          controller: _contactController,
                        ),
                        VerticalSpace(10),
                        DynamicFontSize(label: 'Experience:', fontSize: 20),
                        VerticalSpace(10),
                        AppTextFormField(
                          hintText: 'Experience',
                          validator: (val) =>
                              val.isEmpty ? "Field cannot be empty" : null,
                          controller: _expController,
                        ),
                        VerticalSpace(10),

                        DynamicFontSize(
                            label: 'Password:',
                            fontSize: 20),

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
                          controller: _confirmPwdController,
                          validator: (val) {
                            if (val.isEmpty) {
                              return "Field cannot be emtpy";
                            } else if (_confirmPwdController.text !=
                                _pwdController.text) {
                              return "Confirm Password doest not match";
                            } else {
                              return null;
                            }
                          },
                        ),
                        VerticalSpace(10),

                        DynamicFontSize(label: 'Qualification:', fontSize: 20),

                        VerticalSpace(10),

                        AppTextFormField(
                          hintText: 'BS/MS in Computer Science',
                          validator: (val) =>
                              val.isEmpty ? "Field cannot be empty" : null,
                          controller: _qualController,
                        ),





                        VerticalSpace(20),
                        _getImagePicker(context),

                        VerticalSpace(10),
                        _getSubjectDropDown(context),
                        // VerticalSpace(10),
                        // Container(
                        //   padding: const EdgeInsets.symmetric(
                        //       horizontal: 10, vertical: 10),
                        //   height: 100,
                        //   width: double.infinity,
                        //   decoration:
                        //       BoxDecoration(color: Colors.grey.shade100),
                        //   child: Column(
                        //     children: [
                        //       Align(
                        //         alignment: Alignment.topRight,
                        //         child: Container(
                        //           height: 34,
                        //           width: 34,
                        //           decoration: BoxDecoration(
                        //               shape: BoxShape.circle,
                        //               color: AppColors()
                        //                   .colorFromHex(context, '#3B7AF8')),
                        //           child: Icon(
                        //             Icons.add,
                        //             color: Colors.white,
                        //           ),
                        //         ),
                        //       ),
                        //       Row(
                        //         children: [
                        //           Icon(Icons.picture_as_pdf,
                        //               color: AppColors()
                        //                   .colorFromHex(context, '#3B7AF8')),
                        //           HorizontalSpace(10),
                        //           DynamicFontSize(
                        //             label: 'BS in computer science',
                        //             fontSize: 18,
                        //             fontWeight: FontWeight.normal,
                        //           )
                        //         ],
                        //       )
                        //     ],
                        //   ),
                        // ),
                        VerticalSpace(20),
                        AppButton(
                          label: 'Register',
                          colorText: '#3B7AF8',
                          onTap: () {
                            if (!_formKey.currentState.validate()) {
                              return;
                            }
                            isLoading = true;
                            setState(() {});
                            _signUpUser(
                                signUp: signUp, user: user, context: context);
                          },
                        ),
                        VerticalSpace(10),

                        Align(
                            alignment: Alignment.center,
                            child: DynamicFontSize(label: 'Or', )),

                        VerticalSpace(10),


                        AppButton(
                          colorText: '#3B7AF8',
                          label: 'Login',
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        TeacherLoginScreen()));
                          }
                        ),

                        VerticalSpace(10),


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
    _uploadFileServices.getUrl(context, file: _file).then((value) {
      signUp
          .registerNewTeacher(
              email: _emailController.text,
              password: _pwdController.text,


              teacherModel: TeacherModel(
                  name: _nameController.text,
                  email: _emailController.text,
                  password: _pwdController.text,
                  lat: _center.latitude,
                  lng: _center.longitude,
                  role: "T",
                  image: value,
                  subjectID: _selectedSubject.subjectID,
                  subjectName: _selectedSubject.subjectName,
                  location: "",
                  hourlyRate: _hourlyController.text,
                  bio: _bioController.text,
                  contactNo: _contactController.text,
                  exp: _expController.text,
                  qualification: _qualController.text),


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
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => TeacherLoginScreen()));
          }, secondButtonText: "", showSecondButton: false);
        } else if (signUp.status == SignUpStatus.Failed) {
          showErrorDialog(context,
              message: Provider.of<ErrorString>(context, listen: false)
                  .getErrorString());
        }
      });
    });
  }

  Widget _getSubjectDropDown(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Theme.of(context).primaryColor)),
        child: FittedBox(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 18.0),
                child: Icon(
                  Icons.room_preferences_outlined,
                  color: Colors.grey[700],
                  size: 27,
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: DropdownButton<SubjectModel>(
                    value: _selectedSubject,
                    items: _subjectList.map((value) {
                      return DropdownMenuItem<SubjectModel>(
                        child: Text(value.subjectName),
                        value: value,
                      );
                    }).toList(),
                    onChanged: (item) {
                      _selectedSubject = item;
                      setState(() {});
                    },
                    underline: SizedBox(),
                    hint: Text("Select Subject"),
                    isExpanded: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getImagePicker(BuildContext context) {
    var status = Provider.of<AppState>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 60,
        decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).primaryColor),
            borderRadius: BorderRadius.circular(7)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Container(
                child: Text(
                  _file == null
                      ? "Choose an Image..."
                      : _file.path.split('/').last,
                  style: Theme.of(context)
                      .textTheme
                      .caption
                      .merge(TextStyle(color: Theme.of(context).primaryColor)),
                ),
              ),
            ),
            IconButton(
                icon: Icon(
                  Icons.attach_file,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () async {
                  getFile(true);
                })
          ],
        ),
      ),
    );
  }

  Future getFile(bool gallery) async {
    FilePickerResult result = await FilePicker.platform.pickFiles();

    if (result != null) {
      _file = File(result.files.single.path);
    } else {
      // User canceled the picker
    }

    setState(() {
      if (_file != null) {
        _file = File(_file.path);
      } else {
        print('No image selected.');
      }
    });
  }
}
