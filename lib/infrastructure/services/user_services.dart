import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:sami_project/configurations/back_end_configs.dart';
import 'package:sami_project/infrastructure/models/teacherModel.dart';
import 'package:sami_project/infrastructure/models/userModel.dart';
import 'package:sami_project/infrastructure/services/updateLocalStorageServices.dart';

class UserServices {
  ///Instantiate LocalDB
  final LocalStorage storage = new LocalStorage(BackEndConfigs.loginLocalDB);



  ///Collection Reference of Students
  final CollectionReference _stdRef =
      FirebaseFirestore.instance.collection('students');

  ///Collection Reference of Teachers
  final CollectionReference _teRef =
      FirebaseFirestore.instance.collection('teachers');

  ///Add Teachers Data
  Future<void> addTeacherData(
      User user, TeacherModel teacherModel, BuildContext context) {
    return _teRef.doc(user.uid).set(teacherModel.toJson(user.uid));
  }

  ///Add Students Data
  Future<void> addStudentData(
      User user, StudentModel stdModel, BuildContext context) {
    return _stdRef.doc(user.uid).set(stdModel.toJson(user.uid));
  }

  ///get a Teachers
  Stream<TeacherModel> streamTeacherData(String docID) {
    print("I am $docID");
    return _teRef
        .doc(docID)
        .snapshots()
        .map((snap) => TeacherModel.fromJson(snap.data()));
  }

  Stream<List<TeacherModel>> streamTeachersViaSubject(String subject) {
    return _teRef.where('subjectName', isEqualTo: subject).snapshots().map(
        (event) =>
            event.docs.map((e) => TeacherModel.fromJson(e.data())).toList());
  }

  Stream<List<TeacherModel>> streamTeachersViaLocation(String location) {
    return _teRef.where('location', isEqualTo: location).snapshots().map(
        (event) =>
            event.docs.map((e) => TeacherModel.fromJson(e.data())).toList());
  }

  ///Stream a Students
  Stream<StudentModel> streamStudentsData(String docID) {
    print("I am $docID");
    return _stdRef
        .doc(docID)
        .snapshots()
        .map((snap) => StudentModel.fromJson(snap.data()));
  }

  ///Stream ALl Teachers
  Stream<List<TeacherModel>> getAllTeachers(
    BuildContext context,
  ) {
    return _teRef.snapshots().map((snap) =>
        snap.docs.map((e) => TeacherModel.fromJson(e.data())).toList());
  }

  ///Go Offline/Online Teachers
  Future<void> changeOnlineStatusTeacher({String docID, bool isOnline}) async {
    // await _teRef.doc(docID).update({
    //   'isOnline': isOnline,
    // });
  }

  ///Go Offline/Online Teachers
  Future<void> changeOnlineStatusStudents({String docID, bool isOnline}) async {
    // await _stdRef.doc(docID).update({
    //   'isOnline': isOnline,
    // });
  }
}
