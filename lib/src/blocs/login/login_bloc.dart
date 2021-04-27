import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:share_a_car/src/common/utils/custom_exception.dart';
import 'package:share_a_car/src/models/login/login.dart';
import 'package:share_a_car/src/repository/login/login_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  
  LoginBloc() : super(LoginState());



  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is OnValidateForm) {
      yield* _validateCredentials(event.username, event.password);

    } else if (event is OnInitialState) {
        yield state.initialState();
    }
  }

  Stream<LoginState> _validateCredentials(String username, String password) async*  {

    yield state.copyWith(
      isThereAnError: false,
      validatingCredentials: true,
    );

    try {
      Login loginResponse = await LoginRepository.validateCredentials(username, password);
      if (loginResponse.userId != null) {
        yield* _dispatchSuccessMessage(loginResponse.userId.toString());
      }
    } on CustomException catch (e) {
        if (e.errorCode == "404"){
            yield* _dispatchErrorMessage("Credenciales inválidas, por favor reintente nuevamente.");
        } else {
           yield* _dispatchErrorMessage(e.errorCode + " " + e.errorMessage);
        }
    }
  }

  Stream<LoginState> _dispatchSuccessMessage(String userId) async*  {
    yield state.copyWith(
      isThereAnError: false,
      credentialsAreValid: true,
      userId: userId.toString()
    );
  }

  Stream<LoginState> _dispatchErrorMessage(String errorMessage) async*  {
    yield state.copyWith(
      isThereAnError: true,
      validatingCredentials: false,
      errorMessage: errorMessage
    );
  }
}