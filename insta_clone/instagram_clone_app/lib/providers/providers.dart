import 'package:flutter/material.dart';
import 'package:instagram_clone_app/models/auth_model.dart';
import 'package:instagram_clone_app/resources/auth_methods.dart';

class UserProvider with ChangeNotifier {
  UserModel? model;
  final AuthMethods __authMethods = AuthMethods();
  UserModel get getUser => model!;
  Future<void> refreshUser() async {
    UserModel? user = await __authMethods.getUserDetails();
    if (user != null) {
      model = user;
      notifyListeners();
    }
  }
}
