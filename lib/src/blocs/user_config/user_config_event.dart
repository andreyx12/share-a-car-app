part of 'user_config_bloc.dart';

@immutable
abstract class UserConfigEvent {}

class OnInitialState extends UserConfigEvent{}

class OnGetUserInformation extends UserConfigEvent{}

class OnShowEditForm extends UserConfigEvent{}

class OnUpdateUserInfo extends UserConfigEvent{
  final UserConfig userConfig;
  OnUpdateUserInfo(this.userConfig);
}