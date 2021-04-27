part of 'login_bloc.dart';

class LoginState {

  String userId;
  String errorMessage;
  bool validatingCredentials = false;
  bool credentialsAreValid = false;
  bool isThereAnError = false;

  LoginState({
    this.userId,
    this.errorMessage,
    this.validatingCredentials = false,
    this.credentialsAreValid = false,
    this.isThereAnError = false
  });

  LoginState copyWith({
    bool validatingCredentials,
    String userId,
    String errorMessage,
    bool credentialsAreValid,
    bool isThereAnError
  }) => LoginState(
    userId: userId ?? this.userId,
    errorMessage: errorMessage ?? this.errorMessage,
    validatingCredentials: validatingCredentials ?? this.validatingCredentials,
    credentialsAreValid: credentialsAreValid ?? this.credentialsAreValid,
    isThereAnError: isThereAnError ?? this.isThereAnError,
  );

  LoginState initialState() => new LoginState();
}
