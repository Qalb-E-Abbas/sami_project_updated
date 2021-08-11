import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sami_project/infrastructure/models/teacherModel.dart';
import 'package:sami_project/infrastructure/services/user_services.dart';
import 'package:sami_project/presentations/MainScreens/teacher_profile_page.dart';

import '../../configurations/AppColors.dart';
import 'package:sami_project/presentations/common/horizontal_sized_box.dart';

class MapHomePage extends StatefulWidget {
  @override
  MapHomePageState createState() => MapHomePageState();
}

class MapHomePageState extends State<MapHomePage> {
  Completer<GoogleMapController> _controller = Completer();
  UserServices _userServices = UserServices();

  bool isLoading = true;
  List<DocumentSnapshot> shopsData = [];
  List<Marker> marker = [];

  var _lat;
  var _lng;

  @override
  void initState() {
    shopsData.clear();

    super.initState();
  }

  Widget _subjectPopup(BuildContext context) => Container(
        height: 20,
        child: PopupMenuButton<int>(
          onSelected: (val) {
            if (val == 4) {
              i = 4;
            } else if (val == 5) {
              i = 5;
            }
            setState(() {});
          },
          padding: EdgeInsets.all(0),
          icon: Icon(
            Icons.filter_list,
            size: 19,
          ),
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 4,
              child: Text("Maths"),
            ),
            PopupMenuItem(
              value: 5,
              child: Text("Computer"),
            ),






          ],
        ),
      );
  int i = 0;
  Widget _locationPopup(BuildContext context) => Container(
        height: 20,
        child: PopupMenuButton<int>(
          onSelected: (val) {
            if (val == 0) {
              i = 0;
            } else if (val == 1) {
              i = 1;
            } else if (val == 2) {
              i = 2;
            } else if (val == 3) {
              i = 3;
            } else if (val == 6) {
              i = 6;
            }
            setState(() {});
          },
          padding: EdgeInsets.all(0),
          icon: Icon(
            Icons.location_on,
            size: 19,
          ),
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 0,
              child: Text("All Teachers"),
            ),
            PopupMenuItem(
              value: 1,
              child: Text("From Kohat"),
            ),
            PopupMenuItem(
              value: 2,
              child: Text("From Peshawar"),
            ),
            PopupMenuItem(
              value: 3,
              child: Text("From Islamabad"),
            ),
            PopupMenuItem(
              value: 4,
              child: Text("From Lahore"),
            ),

          ],
        ),
      );

  Stream<List<TeacherModel>> _getStream(int i) {
    if (i == 0) {
      return _userServices.getAllTeachers(context);
    } else if (i == 1) {
      return _userServices.streamTeachersViaLocation("Peshawar");
    } else if (i == 2) {
      return _userServices.streamTeachersViaLocation("Islamabad");
    } else if (i == 3) {
      return _userServices.streamTeachersViaLocation("Lahore");
    } else if (i == 4) {
      return _userServices.streamTeachersViaSubject("Maths");
    } else if (i == 5) {
      return _userServices.streamTeachersViaSubject("Computer");
    } else if (i == 6) {
      return _userServices.streamTeachersViaLocation("Kohat");
    }
  }

  double zoomVal = 5.0;

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context);
    return Scaffold(
      appBar: AppBar(

        /// Colors.red

        backgroundColor: AppColors()
            .colorFromHex(context, '#3B7AF8'),
        centerTitle: true,
        title: Text("Tutorpedia Map"),
        actions: [_subjectPopup(context), _locationPopup(context)],
      ),
      body: StreamProvider.value(
        value: _getStream(i),
        builder: (context, child) {
          if (context.read<List<TeacherModel>>() != null) if (marker.length <
              context.read<List<TeacherModel>>().length)
            Future.delayed(Duration(milliseconds: 300), () {
              context
                  .read<List<TeacherModel>>()
                  .map((e) => marker.add(Marker(
                      markerId: MarkerId(e.id),
                      position: LatLng(double.parse(e.lat.toString()),
                          double.parse(e.lng.toString())),
                      infoWindow: InfoWindow(title: e.name),
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueViolet,
                      ))))
                  .toList();
              setState(() {});
            });
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildGoogleMap(context),
              context.watch<List<TeacherModel>>() == null
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Expanded(
                      child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: context.watch<List<TeacherModel>>().length,
                          itemBuilder: (c, i) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              child: Card(
                                elevation: 6,
                                shadowColor: Colors.black,
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [


                                  Text(context
                                      .watch<List<TeacherModel>>()[i]
                                      .name, style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18
                                  ),),

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Location: '),

                                        IconButton(icon: Icon(Icons.map),
                                            onPressed: ()

                                            {

                                              _gotoLocation(
                                                  double.parse(context
                                                      .read<List<TeacherModel>>()[i]
                                                      .lat
                                                      .toString()),
                                                  double.parse(context
                                                      .read<List<TeacherModel>>()[i]
                                                      .lng
                                                      .toString()));

                                            }

                                            ),
                                      ],
                                    ),




                                    Row(

                                      children: [


                                        Text('Profile:'),

                                        HorizontalSpace(10),

                                        IconButton(
                                          icon: Icon(Icons.person),
                                          onPressed: () {
                                            TeacherModel model =
                                            context.read<List<TeacherModel>>()[i];
                                            setState(() {});
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => ProfilePage(
                                                      teacherModel: model,
                                                      isOutsideRoute: true,
                                                      myID: user.uid,
                                                    )));
                                          },
                                        ),

                                      ],
                                    )



                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                    )
            ],
          );
        },
      ),
    );
  }

  Widget _buildGoogleMap(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(target: LatLng(10, 10), zoom: 10),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: Set.of(marker),
      ),
    );
  }

  Future<void> _gotoLocation(double lat, double long) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(lat, long),
      zoom: 15,
      tilt: 50.0,
      bearing: 45.0,
    )));
  }
}

List<MarkerDetails> markerDetails = [
  MarkerDetails(
      markerID: 'gramercy',
      lat: 40.738380,
      lng: -73.988426,
      title: 'Gramercy Tavern'),
  MarkerDetails(
      markerID: 'gramesdfrcy',
      lat: 40.742451,
      lng: -74.005959,
      title: 'Gramercy Tavern')
];

class MarkerDetails {
  final String markerID;
  final double lat;
  final double lng;
  final title;

  MarkerDetails({this.markerID, this.lat, this.lng, this.title});
}
