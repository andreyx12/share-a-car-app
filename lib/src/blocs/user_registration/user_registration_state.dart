part of 'user_registration_bloc.dart';

class UserRegistrationState {

  bool validatingForm = false;

  bool formWasValidated = false;

  UserRegistration userRegistration;
  
  UserRegistrationState({
    this.validatingForm = false,
    this.formWasValidated = false,
    this.userRegistration,
  });

  UserRegistrationState copyWith({
    bool validatingForm,
    bool formWasValidated,
    UserRegistration userRegistration,
  }) => UserRegistrationState(
    validatingForm: validatingForm ?? this.validatingForm,
    formWasValidated: formWasValidated ?? this.formWasValidated,
    userRegistration: userRegistration ?? this.userRegistration,
  );

  UserRegistrationState initialState() => new UserRegistrationState();
}