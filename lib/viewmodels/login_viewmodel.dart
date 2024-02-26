// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../models/login_model.dart';

class LoginViewModel extends GetxController {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  String? usernameError;
  String? emailError;
  String? passwordError;

  validateUsername(String? username) {
    if (username == null || username.isEmpty) {
      return 'Username is required';
    }
    return null;
  }

  /// email is 'eve.holt@reqres.in'
  validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Email is required';
    } else if (!RegExp(r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$')
        .hasMatch(email)) {
      return 'Invalid email format';
    }
    return null;
  }

// password is 'pistol'
  validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password is required';
    } else if (password != 'pistol' &&
        !RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{6,16}$')
            .hasMatch(password)) {
      return 'Invalid password format';
    }
    return null;
  }

  void loginButton() {
    if (formKey.currentState?.validate() == true) {
      print('Username: ${usernameController.text}');
      print('Email: ${emailController.text}');
      print('Password: ${passwordController.text}');

      LoginModel loginModel = LoginModel(
          email: emailController.text, password: passwordController.text);
      login(loginModel);
    }
  }

  void login(LoginModel loginModel) async {
    try {
      http.Response response = await http.post(
        Uri.parse('https://reqres.in/api/login'),
        body: loginModel.toJson(),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body); // Parse response body as JSON
        print("token for login is: ${data['token']}");
        print('login successfully');
      } else {
        print('Login failed, status_code => ${response.statusCode}');
      }
    } catch (error) {
      print(error.toString());
    }
  }
}
  // void login() async {
  //   try {
  //     http.Response response = await http.post(
  //       Uri.parse('https://reqres.in/api/login'),
  //       body: jsonEncode({
  //         'email': emailController.text,
  //         'password': passwordController.text,
  //       }),
  //       headers: {'Content-Type': 'application/json'},
  //     );

  //     if (response.statusCode == 200) {
  //       var data = jsonDecode(response.body);
  //       print("token for login is: ${data['token']}");
  //       print('login successfully');
  //     } else {
  //       print('Login failed, status_code => ${response.statusCode}');
  //     }
  //   } catch (error) {
  //     print(error.toString());
  //   }
  // }
