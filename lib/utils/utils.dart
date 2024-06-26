import "dart:convert";
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message),
  ));
}

void httpErrorHandle({
  required http.Response response,
  required BuildContext context,
  required VoidCallback onSuccess,
  }) {
    switch (response.statusCode) {
      case 200:
        onSuccess();
        break;
      case 201:
        onSuccess();
        break;
      case 400:
        showSnackBar(context, jsonDecode(response.body)['message']);
        break;
      case 401:
        showSnackBar(context, 'Unauthorized');
        break;
      case 403:
        showSnackBar(context, 'Forbidden');
        break;
      case 404:
        showSnackBar(context, 'Not Found');
        break;
      case 500:
        showSnackBar(context, jsonDecode(response.body)['error']);
        break;
      default:
        showSnackBar(context, response.body);
    }
  }
  