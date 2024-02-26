// ignore_for_file: avoid_print

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../models/login_model.dart';

class LoginViewModel extends GetxController {
  void login(LoginModel loginModel) async {
    try {
      http.Response response = await http.post(
        Uri.parse('https://reqres.in/api/login'),
        body: loginModel.toJson(),
      );

      if (response.statusCode == 200) {
        var data = response.body;
        print("token for login is: $data");
        print('login successfully');
      } else {
        print('Login failed, status_code => ${response.statusCode}');
      }
    } catch (error) {
      print(error.toString());
    }
  }
}
