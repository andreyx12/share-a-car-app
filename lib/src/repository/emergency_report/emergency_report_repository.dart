
import 'package:share_a_car/src/models/emergency_report/emergency_report.dart';
import 'package:share_a_car/src/providers/emergency_report/emergency_report_provider.dart';

class EmergencyReportRepository {

  static Future<EmergencyReport> postEmergencyReport(String username, String description){
    return EmergencyReportProvider().postEmergencyReport(username, description);
  }
}