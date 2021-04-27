
import 'package:intl/intl.dart';

import '../error_info/error_info.dart';

class Trip extends ErrorInfo {
  
  int tripId;
  int invoiceId;
  int vehicleId;
  int userId;
  DateTime startTime;
  DateTime endTime;
  String tripStatus;
  String tripNotes;
  String costPerMinute;
  String totalAmount;

  Trip({this.tripId, this.invoiceId, this.vehicleId, this.userId, this.startTime, this.endTime, this.tripStatus, this.tripNotes, this.costPerMinute, this.totalAmount});

  Trip.setError(String errorCode, String errorMessage) {
    super.errorCode = errorCode;
    super.errorMessage = errorMessage;
  }

  Trip.fromJsonMap( Map<String, dynamic> json) {
    tripId        = json['trip_id'];    
    vehicleId     = json['vehicle_id'];
    invoiceId     = json['invoiceId'];
    userId        = json['user_id'];
    startTime     = json['start_time'] != null ? DateFormat("MM/dd/yyyy hh:mm:ss a").parse(json['start_time'], true).toLocal() : null;
    endTime       = json['end_time'] != null ? DateFormat("MM/dd/yyyy hh:mm:ss a").parse(json['end_time'], true).toLocal() : null;
    tripStatus    = json['trip_status'];
    tripNotes    = json['trip_notes'];
    costPerMinute    = json['cost_per_minute'];
    totalAmount    = json['total_amount'];
  }
}