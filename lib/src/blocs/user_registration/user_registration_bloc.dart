import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:share_a_car/src/common/utils/custom_exception.dart';
import 'package:share_a_car/src/models/login/user_registration.dart';
import 'package:share_a_car/src/repository/login/login_repository.dart';

part 'user_registration_event.dart';
part 'user_registration_state.dart';

class UserRegistrationBloc extends Bloc<UserRegistrationEvent, UserRegistrationState> {

  UserRegistrationBloc() : super(UserRegistrationState());

  @override
  Stream<UserRegistrationState> mapEventToState(UserRegistrationEvent event) async* {
    
    if ( event is OnRegisterUser ) {
      yield state.copyWith(
        validatingForm: true,
      );
       yield* _registerUser(event.userRegistration);

     } else if ( event is OnInitialState) {
      yield state.initialState();
    }
  }

  Stream<UserRegistrationState> _registerUser(UserRegistration userRegistration) async*  {
    UserRegistration _userRegistration;
    try {
      _userRegistration = await LoginRepository.registerUser(userRegistration);
    } on CustomException catch (e) {
        _userRegistration = UserRegistration.setError(e.errorCode, e.errorMessage);
    }
    yield state.copyWith(
      validatingForm: false,
      formWasValidated: _userRegistration?.errorCode == null,
      userRegistration: _userRegistration
    );
  }
}
