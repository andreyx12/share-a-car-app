part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {}

class OnValidateForm implements LoginEvent {
    final String username;
    final String password;
    OnValidateForm(this.username, this.password);
}

class OnInitialState extends LoginEvent{}