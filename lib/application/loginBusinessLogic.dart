import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'package:sami_project/configurations/back_end_configs.dart';
import 'package:sami_project/configurations/enums.dart';
import 'package:sami_project/infrastructure/services/authServices.dart';
import 'package:sami_project/infrastructure/services/user_services.dart';

import 'errorStrings.dart';

class LoginBusinessLogic {
  UserServices _userServices = UserServices();
  final LocalStorage storage = new LocalStorage(BackEndConfigs.loginLocalDB);

  Future loginUserLogic(
    BuildContext context, {
    @required String email,
    @required String password,
  }) async {
    var _authServices = Provider.of<AuthServices>(context, listen: false);
    var _error = Provider.of<ErrorString>(context, listen: false);

    var login = Provider.of<AuthServices>(context, listen: false);

    await login
        .signIn(context, email: email, password: password)
        .then((User user) {
      if (user != null) {
        _userServices.streamStudentsData(user.uid).map((user) async {
          if (user == null) {
            _authServices.setState(Status.Unauthenticated);
          } else {

            await storage.setItem(
                BackEndConfigs.userDetailsLocalStorage, user.toJson(user.id));
          }
        }).toList();
      } else {}
    });
  }

  Future teacherLoginUserLogic(
    BuildContext context, {
    @required String email,
    @required String password,
  }) async {
    var _authServices = Provider.of<AuthServices>(context, listen: false);
    var _error = Provider.of<ErrorString>(context, listen: false);
    var login = Provider.of<AuthServices>(context, listen: false);

    await login
        .signIn(context, email: email, password: password)
        .then((User user) {
      if (user != null) {
        _userServices.streamTeacherData(user.uid).map((user) async {
          if (user == null) {
            _authServices.setState(Status.Unauthenticated);
          } else {
            await storage.setItem(BackEndConfigs.teacherDetailsLocalStorage,
                user.toJson(user.id));
          }
        }).toList();
      } else {}
    });
  }
}
