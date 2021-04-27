part of 'user_config_bloc.dart';

class UserConfigState {
 
  String errorMessage;
  bool infoWasLoaded = false;
  UserConfig userConfig;

  bool validatingEditForm = false;

  bool editFormWasValidated = false;

  bool showEditForm = false;

  UserConfigState({
    this.userConfig,
    this.errorMessage,
    this.infoWasLoaded = false,
    this.validatingEditForm = false,
    this.editFormWasValidated = false,
    this.showEditForm = false
  });

  UserConfigState copyWith({
    String errorMessage,
    bool infoWasLoaded,
    UserConfig userConfig,
    bool validatingEditForm,
    bool editFormWasValidated,
    bool showEditForm
  }) => UserConfigState(
    errorMessage: errorMessage ?? this.errorMessage,
    infoWasLoaded: infoWasLoaded ?? this.infoWasLoaded,
    userConfig: userConfig ?? this.userConfig,
    validatingEditForm: validatingEditForm ?? this.validatingEditForm,
    editFormWasValidated: editFormWasValidated ?? this.editFormWasValidated,
    showEditForm: showEditForm ?? this.showEditForm,
  );

  UserConfigState initialState() => new UserConfigState(); 
}