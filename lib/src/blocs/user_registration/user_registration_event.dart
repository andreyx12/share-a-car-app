part of 'user_registration_bloc.dart';

@immutable
abstract class UserRegistrationEvent {}

class OnRegisterUser implements UserRegistrationEvent {
    final UserRegistration userRegistration;
    OnRegisterUser(this.userRegistration);
}

class OnInitialState extends UserRegistrationEvent{}