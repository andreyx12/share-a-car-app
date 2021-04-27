
import 'package:share_a_car/src/models/error_info/error_info.dart';

class Login extends ErrorInfo {
  
  int userId;

  Login.setError(String errorCode, String errorMessage) {
    super.errorCode = errorCode;
    super.errorMessage = errorMessage;
  }
  
  Login({this.userId});

  Login.fromJsonMap( Map<dynamic, dynamic> json) {
    userId = json['user_id'];    
  }

  get getUserId => this.userId;

  set setUserId( userId) => this.userId = userId;
}