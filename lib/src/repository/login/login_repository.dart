import 'package:share_a_car/src/models/login/login.dart';
import 'package:share_a_car/src/models/login/user_registration.dart';
import 'package:share_a_car/src/providers/login/login_provider.dart';

class LoginRepository {

  static Future<Login> validateCredentials(String username, String password){
    return LoginProvider().validateCredentials(username, password);
  }

  static Future<UserRegistration> registerUser(UserRegistration userRegistration){
    return LoginProvider().registerUser(userRegistration);
  }
}