import '../error_info/error_info.dart';

class DriverLicense extends ErrorInfo {
  
  int userId;
  String status;
  String image;

  DriverLicense({this.userId, this.status, this.image});

  DriverLicense.setError(String errorCode, String errorMessage) {
    super.errorCode = errorCode;
    super.errorMessage = errorMessage;
  }

  DriverLicense.fromJsonMap( Map<String, dynamic> json) {
    userId      = json['user_id'];    
    status        = json['status'];
    image         = json['image'];
  }
}