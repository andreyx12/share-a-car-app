import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:share_a_car/src/common/utils/constants.dart';
import 'package:share_a_car/src/common/utils/custom_exception.dart';
import 'package:share_a_car/src/models/login/login.dart';
import 'package:share_a_car/src/models/login/user_registration.dart';

class LoginProvider {

  final String _usernameBasicAuth = 'shareacar';
  final String _passwordBasicAuth = 'E6XZ_kbU%9d%Z2@V';

  static LoginProvider _instance;

  LoginProvider._internal() {
    _instance = this;
  }

  factory LoginProvider() => _instance ?? LoginProvider._internal();

  Future<Login> validateCredentials(String username, String password) async {

    final url = Uri.http(Constants.BASE_URL, 'admin/login/$username|$password');

      String basicAuth = Constants.BASIC_AUTH_VALUE + base64Encode(utf8.encode('$_usernameBasicAuth:$_passwordBasicAuth'));

      final resp = await http.get(url, headers: {Constants.AUTH_HEADER: basicAuth});

      if (resp.statusCode != 200) {
        throw CustomException(resp.statusCode.toString(), resp.reasonPhrase);
      }

      final decodedData = json.decode(resp.body);

      final loginData = new Login.fromJsonMap(decodedData);

      return loginData;
  }

  Future<UserRegistration> registerUser(UserRegistration userRegistrationRequest) async {
    
      final url = Uri.http(Constants.BASE_URL, 'admin/customer');

      String basicAuth = 'Basic ' + base64Encode(utf8.encode('$_usernameBasicAuth:$_passwordBasicAuth'));

      final resp = await http.post(
        url,
        headers: {
          'authorization': basicAuth,
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': userRegistrationRequest.username,
          'Password': userRegistrationRequest.password,
          'Name': userRegistrationRequest.name,
          'LastName1': userRegistrationRequest.lastName1,
          'LastName2': userRegistrationRequest.lastName2,
          'Identification': userRegistrationRequest.identification,
          'Phone': userRegistrationRequest.phoneNumber,
          'Email': userRegistrationRequest.email
        })
      );

      if (resp.statusCode != 200) {
        throw CustomException(resp.statusCode.toString(), resp.reasonPhrase);
      }

      final decodedData = json.decode(resp.body);

      final userRgistrarionData = new UserRegistration.fromJsonMap(decodedData);

      return userRgistrarionData;
  }
}