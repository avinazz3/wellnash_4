import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:wellnash_4/models/user.dart';
import 'package:wellnash_4/screens/home_screen.dart';
import 'package:wellnash_4/screens/signup_screen.dart';
import 'package:wellnash_4/utils/constants.dart';
import 'package:wellnash_4/utils/utils.dart';
import '../providers/user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  void signUpUser({
    required String name,
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      Map<String, dynamic> user = {
        'email': email,
        'name': name,
        'password': password,
      };

      http.Response res = await http.post(
        Uri.parse('${Constants.uri}/api/auth/signup'),
        body: jsonEncode(user), // Correctly encode the user map to JSON
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      
      print('Signup Response: ${res.statusCode} ${res.body}'); // Log the response

      httpErrorHandle(
        context: context,
        response: res,
        onSuccess: () {
          showSnackBar(context, 'Account created successfully. Proceed to enter your details.');

          // Decode the response body
          final responseData = jsonDecode(res.body);
          
          // Create a new User object from the JSON data
          final newUser = User.fromMap(responseData['user']);

          // Store user data locally
          Provider.of<UserProvider>(context, listen: false).setUserFromModel(newUser);

          // Navigate to the GettingUserDetails page
          Navigator.pushReplacementNamed(context, '/getting_user_details');
        },
      );
    } catch (e) {
      print('Signup Error: $e');
      showSnackBar(context, 'Error: $e');
    }
  }
  //SIGNIN
  void signInUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      var userProvider = Provider.of<UserProvider>(context, listen: false);
      final navigator = Navigator.of(context);
      http.Response res = await http.post(
        Uri.parse('${Constants.uri}/api/auth/signin'),
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      print('Signin Response: ${res.statusCode} ${res.body}');

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          var responseData = jsonDecode(res.body);
          var userData = responseData['user'];
          userData['token'] = responseData['token']; // Add token to user data
          userProvider.setUser(jsonEncode(userData));
          await prefs.setString('x-auth-token', responseData['token']);
          navigator.pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ),
            (route) => false,
          );
        },
      );
    } catch (e) {
      print('Signin Error: $e');
      showSnackBar(context, e.toString());
    }
  }

  // get user data
  void getUserData(
    BuildContext context,
  ) async {
    try {
      var userProvider = Provider.of<UserProvider>(context, listen: false);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');

      if (token == null) {
        prefs.setString('x-auth-token', '');
      }

      var tokenRes = await http.post(
        Uri.parse('${Constants.uri}/api/auth/tokenIsValid'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token!,
        },
      );

      print('Token Validation Response: ${tokenRes.statusCode} ${tokenRes.body}');

      var response = jsonDecode(tokenRes.body);

      if (response == true) {
        http.Response userRes = await http.get(
          Uri.parse('${Constants.uri}/'),
          headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8', 'x-auth-token': token},
        );

        print('Get User Data Response: ${userRes.statusCode} ${userRes.body}');

        userProvider.setUser(userRes.body);
      }
    } catch (e) {
      print('Get User Data Error: $e');
      showSnackBar(context, e.toString());
    }
  }
  //SIGNOUT
  void signOut(BuildContext context) async {
    final navigator = Navigator.of(context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('x-auth-token', '');
    navigator.pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const SignupScreen(),
      ),
      (route) => false,
    );
  }

  Future<void> updateUserDetails({
    required BuildContext context,
    required String userId,
    required double height,
    required double weight,
    required String injuries,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('${Constants.uri}/api/auth/user/details'),
        body: jsonEncode({
          'userId': userId,
          'height': height,
          'weight': weight,
          'injuries': injuries,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'User details updated successfully');
        },
      );
    } catch (e) {
      showSnackBar(context, 'Error: $e');
    }
  }

  Future<void> updateWorkoutPreferences({
    required BuildContext context,
    required String userId,
    required int workoutDays,
    required String workoutRegime,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('${Constants.uri}/api/auth/user/workout'),
        body: jsonEncode({
          'userId': userId,
          'workoutDays': workoutDays,
          'workoutRegime': workoutRegime,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'Workout preferences updated successfully');
        },
      );
    } catch (e) {
      showSnackBar(context, 'Error: $e');
    }
  }

  String? getToken() {
    SharedPreferences prefs = SharedPreferences.getInstance() as SharedPreferences;
    return prefs.getString('x-auth-token');
  }
}
