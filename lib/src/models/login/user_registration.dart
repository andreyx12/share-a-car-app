
import 'package:share_a_car/src/models/error_info/error_info.dart';

class UserRegistration extends ErrorInfo {
  
  int userId;
  String identification;
  String name;
  String lastName1;
  String lastName2;
  String phoneNumber;
  String email;
  String username;
  String password;

  UserRegistration.setError(String errorCode, String errorMessage) {
    super.errorCode = errorCode;
    super.errorMessage = errorMessage;
  }
  
  UserRegistration({this.identification, this.name, this.lastName1, this.lastName2, this.phoneNumber, this.email, this.username, this.password});

  UserRegistration.fromJsonMap( Map<dynamic, dynamic> json) {
    userId                = json['id'];    
    username              = json['username'];
    password              = json['password'];
    name                  = json['name'];
    lastName1             = json['lastName1'];
    lastName2             = json['lastName2'];
    identification        = json['identification'];
    phoneNumber           = json['phone'];
    email                 = json['email'];
  }

  get getUserId => this.userId;

  set setUserId( userId) => this.userId = userId;

  String get getIdentification => this.identification;

  set setIdentification(String identification) => this.identification = identification;

  get getName => this.name;

  set setName( name) => this.name = name;

  get getLastName1 => this.lastName1;

  set setLastName1( lastName1) => this.lastName1 = lastName1;

  get getLastName2 => this.lastName2;

  set setLastName2( lastName2) => this.lastName2 = lastName2;

  get getPhoneNumber => this.phoneNumber;

  set setPhoneNumber( phoneNumber) => this.phoneNumber = phoneNumber;

  get getEmail => this.email;

  set setEmail( email) => this.email = email;

  get getUsername => this.username;

  set setUsername( username) => this.username = username;

  get getPassword => this.password;

  set setPassword( password) => this.password = password;
}