import 'package:wellnash_4/models/user.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  User _user = User(
    id: '',
    name: '',
    email: '',
    token: '',
    password: '',
    createdAt: null,
    updatedAt: null,
  ); // private field

  User get user => _user;

  void setUser(String userJson) {
    _user = User.fromJson(userJson);
    notifyListeners();
  }

  void setUserFromModel(User user) {
    _user = user;
    notifyListeners();
  }
}
