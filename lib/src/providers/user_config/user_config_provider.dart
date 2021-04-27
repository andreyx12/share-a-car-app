import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:share_a_car/src/blocs/user_config/user_config_bloc.dart';
import 'package:share_a_car/src/common/utils/constants.dart';
import 'package:share_a_car/src/common/utils/custom_exception.dart';
import 'package:share_a_car/src/models/user_config/user_config.dart';

class UserConfigProvider {

  String usernameBasicAuth = 'shareacar';
  String passwordBasicAuth = 'E6XZ_kbU%9d%Z2@V';

  static UserConfigProvider _instance;

  Future<UserConfig> getUserConfig(String userId) async {
    
      final url = Uri.http(Constants.BASE_URL, 'admin/customer/$userId');

      String basicAuth = 'Basic ' + base64Encode(utf8.encode('$usernameBasicAuth:$passwordBasicAuth'));

      final resp = await http.get(url, headers: {'authorization': basicAuth});

      if (resp.statusCode != 200) {
        throw CustomException(resp.statusCode.toString(), resp.reasonPhrase);
      }

      final decodedData = json.decode(resp.body);

      final userConfigData = new UserConfig.fromJsonMap(decodedData);

      return userConfigData;
  }

  Future<UserConfig> updateUserConfig(UserConfig userConfig) async {
    
      final url = Uri.http(Constants.BASE_URL, 'admin/customer/${userConfig.userId}');

      String basicAuth = 'Basic ' + base64Encode(utf8.encode('$usernameBasicAuth:$passwordBasicAuth'));

      final resp = await http.put(
        url,
        headers: {
          'authorization': basicAuth,
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'Username': userConfig.username,
          'Password': userConfig.password,
          'Name': userConfig.name,
          'LastName1': userConfig.lastName1,
          'LastName2': userConfig.lastName2,
          'Identification': userConfig.identification,
          'Phone': userConfig.phoneNumber,
          'Email': userConfig.email,
        })
      );

      if (resp.statusCode != 200) {
        throw CustomException(resp.statusCode.toString(), resp.reasonPhrase);
      }

      final decodedData = json.decode(resp.body);

      final userConfigData = new UserConfig.fromJsonMap(decodedData);

      return userConfigData;
  }
  

  UserConfigProvider._internal() {
    _instance = this;
  }

  factory UserConfigProvider() => _instance ?? UserConfigProvider._internal();
}