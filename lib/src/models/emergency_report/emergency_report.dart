import '../error_info/error_info.dart';

class EmergencyReport extends ErrorInfo {
  
  String status;

  EmergencyReport(String errorCode, String errorMessage) {
    super.errorCode = errorCode;
    super.errorMessage = errorMessage;
  }

  EmergencyReport.fromJsonMap( Map<String, dynamic> json) {
    status      = json['status'];
  }
}