import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:sami_project/application/call_launcher.dart';
import 'package:sami_project/application/launch_whatsapp.dart';
import 'package:sami_project/application/sms_sender.dart';
import 'package:sami_project/configurations/AppColors.dart';
import 'package:sami_project/configurations/back_end_configs.dart';
import 'package:sami_project/infrastructure/models/teacherModel.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../configurations/AppColors.dart';
import 'package:sami_project/presentations/common/vertical_sized_box.dart';

class ProfilePage extends StatefulWidget {
  final String myID;
  final bool isOutsideRoute;
  final TeacherModel teacherModel;

  ProfilePage({this.myID, this.isOutsideRoute = false, this.teacherModel});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isOpen = false;
  PanelController _panelController = PanelController();
  final LocalStorage storage = new LocalStorage(BackEndConfigs.loginLocalDB);
  TeacherModel teacherModel = TeacherModel();
  bool initialized = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: storage.ready,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!initialized) {
              if (!widget.isOutsideRoute) {
                var items =
                    storage.getItem(BackEndConfigs.teacherDetailsLocalStorage);
                teacherModel = TeacherModel(
                  email: items['email'],
                  name: items['name'],
                  subjectName: items['subjectName'],
                  hourlyRate: items['hourlyRate'],
                  location: items['location'],
                  bio: items['bio'],
                  contactNo: items['contactNo'],
                  exp: items['exp'],
                  image: items['image'],
                  id: items['id'],
                );
              }

              initialized = true;
            }
            return snapshot.data == null
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : _getUI(context);
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton:
      FloatingActionButton.extended(
        backgroundColor: AppColors().colorFromHex(context, '#3B7AF8'),
        icon: Icon(Icons.whatshot),
        onPressed: () {
          launchWhatsApp(
              phone: widget.isOutsideRoute
                  ? widget.teacherModel.contactNo
                  : teacherModel.contactNo,
              message: "Write your own message....",
              context: context);
        },
        label: Text("WhatsApp"),
      ),
    );
  }

  Widget _getUI(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        FractionallySizedBox(
          alignment: Alignment.topCenter,
          heightFactor: 0.6,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(widget.isOutsideRoute
                    ? widget.teacherModel.image ?? ""
                    : teacherModel.image ?? ""),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),

        // FractionallySizedBox(
        //   alignment: Alignment.bottomCenter,
        //   heightFactor: 0.3,
        //   child: Container(
        //     color: Colors.white,
        //   ),
        // ),

        /// Sliding Panel
        SlidingUpPanel(
          controller: _panelController,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(32),
            topLeft: Radius.circular(32),
          ),
          minHeight: MediaQuery.of(context).size.height * 0.395,
          maxHeight: MediaQuery.of(context).size.height * 0.85,
          body: GestureDetector(
            onTap: () => _panelController.close(),
            child: Container(
              color: Colors.transparent,
            ),
          ),
          panelBuilder: (ScrollController controller) => _panelBody(controller),
          onPanelSlide: (value) {
            if (value >= 0.2) {
              if (!_isOpen) {
                setState(() {
                  _isOpen = true;
                });
              }
            }
          },
          onPanelClosed: () {
            setState(() {
              _isOpen = false;
            });
          },
        ),
      ],
    );
  }

  /// **********************************************
  /// WIDGETS
  /// **********************************************
  /// Panel Body
  SingleChildScrollView _panelBody(ScrollController controller) {
    double hPadding = 40;

    return SingleChildScrollView(
      controller: controller,
      physics: ClampingScrollPhysics(),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: hPadding),
            height: MediaQuery.of(context).size.height * 0.35,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _titleSection(),
                _infoSection(),
                _actionSection(hPadding: hPadding),
              ],
            ),
          ),
          Container(
            height: 300,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  VerticalSpace(30),
                  Text(
                    'Bio:',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  customContainer(widget.isOutsideRoute
                      ? widget.teacherModel.bio
                      : teacherModel.bio),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Contact No:',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  customContainer(widget.isOutsideRoute
                      ? widget.teacherModel.contactNo
                      : teacherModel.contactNo),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Experience:',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  customContainer(widget.isOutsideRoute
                      ? '${widget.teacherModel.exp} years'
                      : '${teacherModel.exp} years'),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  /// Action Section
  Row _actionSection({double hPadding}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Visibility(
          visible: !_isOpen,
          child: Expanded(
            child: OutlineButton(
                onPressed: () => _panelController.open(),
                borderSide: BorderSide(
                    color: AppColors().colorFromHex(context, '#3B7AF8')),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                child: Text(
                  'VIEW PROFILE',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                )),
          ),
        ),
        Visibility(
          visible: !_isOpen,
          child: SizedBox(
            width: 16,
          ),
        ),
        if (widget.isOutsideRoute)
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: SizedBox(
                width: _isOpen
                    ? (MediaQuery.of(context).size.width - (2 * hPadding)) / 1.6
                    : double.infinity,
                child: FlatButton(
                  onPressed: () {
                    print(widget.teacherModel.id);
                    print(widget.myID);
                    smsSender(
                        phone: widget.isOutsideRoute
                            ? widget.teacherModel.contactNo
                            : teacherModel.contactNo,
                        message: "Write your custom message...");
                  },
                  color: AppColors().colorFromHex(context, '#3B7AF8'),
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  child: Text(
                    'MESSAGE',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  /// Info Section
  Row _infoSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(children: [
          Icon(Icons.star, color: Colors.yellow,),
          Icon(Icons.star, color: Colors.yellow,),
          Icon(Icons.star, color: Colors.yellow,),
          Icon(Icons.star_half, color: Colors.yellow,),
        ],),
        Container(
          width: 1,
          height: 40,
          color: Colors.grey,
        ),
        _infoCell(
            title: 'Hourly Rate',
            value: widget.isOutsideRoute
                ? "PKR ${widget.teacherModel.hourlyRate}"
                : "PKR ${teacherModel.hourlyRate}"),
      ],
    );
  }

  /// Info Cell
  Column _infoCell({String title, String value}) {
    return Column(
      children: <Widget>[
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 14,
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  /// Title Section
  Column _titleSection() {
    return Column(
      children: <Widget>[
        Text(
          widget.isOutsideRoute
              ? widget.teacherModel.name
              : teacherModel.name ?? "",
          style: TextStyle(
            fontFamily: 'NimbusSanL',
            fontWeight: FontWeight.w700,
            fontSize: 30,
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          widget.isOutsideRoute
              ? widget.teacherModel.subjectName
              : teacherModel.subjectName ?? "",
          style: TextStyle(
            fontStyle: FontStyle.italic,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  customContainer(String text) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height,
        minHeight: 50,
        minWidth: double.infinity,
      ),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border:
              Border.all(color: AppColors().colorFromHex(context, '#3B7AF8'))),
      child: Text(
        text,
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}
