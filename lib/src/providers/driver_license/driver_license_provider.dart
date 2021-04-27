import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:share_a_car/src/common/utils/constants.dart';
import 'package:share_a_car/src/common/utils/custom_exception.dart';
import 'package:share_a_car/src/models/driver_license/driver_license.dart';

class DriverLicenseProvider {

  final String _usernameBasicAuth = 'shareacar';
  final String _passwordBasicAuth = 'E6XZ_kbU%9d%Z2@V';

  Future<DriverLicense> getDriverLicenseStatus(String userId) async {
    
      final url = Uri.http(Constants.BASE_URL, 'admin/driverlicense/$userId');

      String basicAuth = Constants.BASIC_AUTH_VALUE + base64Encode(utf8.encode('$_usernameBasicAuth:$_passwordBasicAuth'));

      final resp = await http.get(url, headers: {Constants.AUTH_HEADER: basicAuth});

      if (resp.statusCode != 200) {
        throw CustomException(resp.statusCode.toString(), resp.reasonPhrase);
      }

      final decodedData = json.decode(resp.body);

      final driverLicense = new DriverLicense.fromJsonMap(decodedData);

      return driverLicense;
  }

  Future<DriverLicense> postDriverLicenseStatus(String userId, String imageBytes) async {
    
      final url = Uri.http(Constants.BASE_URL, 'admin/driverlicense');

      String basicAuth = Constants.BASIC_AUTH_VALUE + base64Encode(utf8.encode('$_usernameBasicAuth:$_passwordBasicAuth'));

      final resp = await http.post(
        url,
        headers: {
          'authorization': basicAuth,
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<dynamic, dynamic>{
          'user_id': int.parse(userId),
          'image': imageBytes
        })
      );

      if (resp.statusCode != 200) {
        throw CustomException(resp.statusCode.toString(), resp.reasonPhrase);
      }

      final decodedData = json.decode(resp.body);

      final driverLicense = new DriverLicense.fromJsonMap(decodedData);

      return driverLicense;
  }

  Future<DriverLicense> updateDriverLicenseStatus(String userId, String imageBytes) async {
    
      final url = Uri.http(Constants.BASE_URL, 'admin/driverlicense');

      String basicAuth = Constants.BASIC_AUTH_VALUE + base64Encode(utf8.encode('$_usernameBasicAuth:$_passwordBasicAuth'));

      final resp = await http.put(
        url,
        headers: {
          'authorization': basicAuth,
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'user_id': userId,
          'image': imageBytes
        })
      );

      if (resp.statusCode != 200) {
        throw CustomException(resp.statusCode.toString(), resp.reasonPhrase);
      }

      final decodedData = json.decode(resp.body);

      final driverLicense = new DriverLicense.fromJsonMap(decodedData);
      
      return driverLicense;
  }
}