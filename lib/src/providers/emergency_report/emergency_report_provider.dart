import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:share_a_car/src/common/utils/constants.dart';
import 'package:share_a_car/src/models/emergency_report/emergency_report.dart';

class EmergencyReportProvider {

  String usernameBasicAuth = 'shareacar';
  String passwordBasicAuth = 'E6XZ_kbU%9d%Z2@V';

  static EmergencyReportProvider _instance;


  Future<EmergencyReport> postEmergencyReport(String username, String description) async {
    
      final url = Uri.http(Constants.BASE_URL, 'admin/driverlicense/$username');

      String basicAuth = 'Basic ' + base64Encode(utf8.encode('$usernameBasicAuth:$passwordBasicAuth'));

      final resp = await http.get(url, headers: {'authorization': basicAuth});

      if (resp.statusCode != 200) {
        throw Exception();
      }

      final decodedData = json.decode(resp.body);

      final emergencyReportResult = new EmergencyReport.fromJsonMap(decodedData);

      return emergencyReportResult;
  }
  

  EmergencyReportProvider._internal() {
    _instance = this;
  }

  factory EmergencyReportProvider() => _instance ?? EmergencyReportProvider._internal();
}