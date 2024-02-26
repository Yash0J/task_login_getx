// ignore_for_file: avoid_print, must_be_immutable
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../utils/constants/colors.dart';
import '../../utils/shared/custom_widgets.dart';
import '../../viewmodels/login_viewmodel.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final LoginViewModel _loginViewModel = Get.put(LoginViewModel());

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String? _usernameError;
  String? _emailError;
  String? _passwordError;

  @override
  Widget build(BuildContext context) {
    var mediaWidth = MediaQuery.of(context).size.width;
    var mediaHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 18),
                loginImage(mediaHeight),
                const SizedBox(height: 36),
                Custom.text(
                  text: "Login",
                  fontSize: 40,
                  fontWeight: FontWeight.w600,
                ),
                const SizedBox(height: 12),
                Custom.text(
                  text: "Please sign in to continue",
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
                const SizedBox(height: 38),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      userNameTextField(),
                      emailTextField(),
                      passwordTextField(),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                loginButton(mediaWidth),
                forgotPasswordButton(mediaWidth),
                newAccountSignup(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Center loginImage(double mediaHeight) {
    return Center(
      child: SizedBox(
        height: mediaHeight * 0.18,
        child: const Placeholder(), // Your SVG picture widget here
      ),
    );
  }

  SizedBox userNameTextField() {
    return SizedBox(
      height: 88,
      child: Column(
        children: [
          Custom.textField(
            validator: (value) {
              _usernameError = validateUsername(value);
              return null;
            },
            controller: _usernameController,
            cursorColor: AppColors.white,
            prefixIcon: const Icon(Icons.person),
            hintText: 'Enter user name',
            label: Custom.text(
              text: "User Name",
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          if (_usernameError != null)
            Text(
              _usernameError!,
              style: const TextStyle(color: Colors.red),
            ),
        ],
      ),
    );
  }

  SizedBox emailTextField() {
    return SizedBox(
      height: 88,
      child: Column(
        children: [
          Custom.textField(
            validator: (value) {
              _emailError = validateEmail(value);
              return null;
            },
            controller: _emailController,
            cursorColor: AppColors.white,
            prefixIcon: const Icon(Icons.email_outlined),
            hintText: 'Enter your email',
            label: Custom.text(
              text: "EMAIL",
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          if (_emailError != null)
            Text(
              _emailError!,
              style: const TextStyle(color: Colors.red),
            ),
        ],
      ),
    );
  }

  SizedBox passwordTextField() {
    return SizedBox(
      height: 88,
      child: Column(
        children: [
          Custom.textField(
            validator: (value) {
              _passwordError = validatePassword(value);
              return null;
            },
            controller: _passwordController,
            obscureText: true,
            hintText: 'Enter your password',
            label: Custom.text(
              text: "PASSWORD",
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            cursorColor: AppColors.white,
            prefixIcon: const Icon(Icons.lock_outlined),
          ),
          if (_passwordError != null)
            Text(
              _passwordError!,
              style: const TextStyle(color: Colors.red),
            ),
        ],
      ),
    );
  }

  TextButton loginButton(double mediaWidth) {
    return TextButton(
      onPressed: () {
        if (_formKey.currentState?.validate() == true) {
          print('Username: ${_usernameController.text}');
          print('Email: ${_emailController.text}');
          print('Password: ${_passwordController.text}');
          login(_loginViewModel);
          // Navigator.pushReplacement(context,
          //     MaterialPageRoute(builder: (context) => const HomePage()));
        }
      },
      style: TextButton.styleFrom(
        backgroundColor: AppColors.green,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(600)),
        minimumSize: Size(mediaWidth / 1.7, 70),
      ),
      child: Custom.text(
        text: "LOGIN",
        textAlign: TextAlign.center,
        fontSize: 20,
        colors: AppColors.darkBlue,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  TextButton forgotPasswordButton(double mediaWidth) {
    return TextButton(
      onPressed: () {},
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(600)),
        minimumSize: Size(mediaWidth / 9, 0),
        surfaceTintColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
      ),
      child: Custom.text(
        text: "Forgot Password?",
        textAlign: TextAlign.center,
        fontSize: 16,
        colors: AppColors.green,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget newAccountSignup() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Text.rich(
        textAlign: TextAlign.center,
        TextSpan(
          text: "Don't have an account? ",
          style: Custom.style(
            colors: AppColors.white.withOpacity(0.64),
          ),
          children: [
            WidgetSpan(
              child: Custom.text(
                text: "Sign up",
                colors: AppColors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? validateUsername(String? username) {
    if (username == null || username.isEmpty) {
      return 'Username is required';
    }
    return null;
  }

  /// email is 'eve.holt@reqres.in'
  String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Email is required';
    } else if (!RegExp(r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$')
        .hasMatch(email)) {
      return 'Invalid email format';
    }
    return null;
  }

// password is 'pistol'
  String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password is required';
    } else if (password != 'pistol' &&
        !RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{6,16}$')
            .hasMatch(password)) {
      return 'Invalid password format';
    }
    return null;
  }

  void login(loginViewModel) async {
    try {
      http.Response response = await http.post(
        Uri.parse('https://reqres.in/api/login'),
        body: jsonEncode({
          'email': _emailController.text,
          'password': _passwordController.text,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
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
