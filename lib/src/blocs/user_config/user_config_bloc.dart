import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:share_a_car/src/common/utils/constants.dart';
import 'package:share_a_car/src/common/utils/custom_exception.dart';
import 'package:share_a_car/src/common/utils/shared_preferences_utils.dart';
import 'package:share_a_car/src/models/user_config/user_config.dart';
import 'package:share_a_car/src/repository/user_config/user_config_repository.dart';

part 'user_config_event.dart';
part 'user_config_state.dart';

class UserConfigBloc extends Bloc<UserConfigEvent, UserConfigState> {

  UserConfigBloc() : super(UserConfigState());

  @override
  Stream<UserConfigState> mapEventToState(UserConfigEvent event) async* {
    if (event is OnGetUserInformation) {
        yield* _getUserInfo(SharedPreferencesUtils.getValue(Constants.USER_ID));

    } else if (event is OnInitialState) {
        yield state.initialState();

    } else if (event is OnShowEditForm) {
      yield state.copyWith(
        showEditForm: true
      );
    } else if (event is OnUpdateUserInfo) {
      yield state.copyWith(
        validatingEditForm: true
      );
      yield* this._updateUserInfo(event);
    }
  }

  Stream<UserConfigState> _getUserInfo(String userId) async*  {

    try {
      UserConfig userConfig = await UserConfigRepository.getUserConfig(userId);

      if (userConfig != null) {
        yield* _dispatchSuccessMessage(userConfig);
      }
    } on CustomException catch (e) {
        yield* _dispatchErrorMessage(UserConfig.setError(e.errorCode, e.errorMessage));
    }
  }

  Stream<UserConfigState> _dispatchSuccessMessage(UserConfig userConfig) async*  {
    yield state.copyWith(
      infoWasLoaded: true,
      userConfig: userConfig,
    );
  }

  Stream<UserConfigState> _dispatchErrorMessage(UserConfig userConfigError) async*  {
    yield state.copyWith(
      infoWasLoaded: true,
      userConfig: userConfigError
    );
  }

  Stream<UserConfigState> _updateUserInfo(OnUpdateUserInfo event) async*  {
    try {
      UserConfig userConfig = await UserConfigRepository.updateUserConfig(event.userConfig);

      if (userConfig != null) {
        yield* _dispatchUpdateSuccessMessage(userConfig);
      }
    } on CustomException catch (e) {
        yield* _dispatchUpdateErrorMessage(UserConfig.setError(e.errorCode, e.errorMessage));
    }
  }

  Stream<UserConfigState> _dispatchUpdateSuccessMessage(UserConfig userConfig) async*  {
    yield state.copyWith(
      showEditForm: false,
      validatingEditForm: false,
      userConfig: userConfig,
    );
  }

  Stream<UserConfigState> _dispatchUpdateErrorMessage(UserConfig userConfigError) async*  {
    yield state.copyWith(
      showEditForm: false,
      validatingEditForm: false
    );
  }
}
