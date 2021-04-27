import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:share_a_car/src/blocs/home/map_bloc.dart';
import 'package:share_a_car/src/common/utils/constants.dart';
import 'package:share_a_car/src/common/utils/custom_exception.dart';
import 'package:share_a_car/src/common/utils/shared_preferences_utils.dart';
import 'package:share_a_car/src/models/driver_license/driver_license.dart';
import 'package:share_a_car/src/repository/driver_license/driver_license_repository.dart';

part 'driver_license_event.dart';
part 'driver_license_state.dart';

class DriverLicenseBloc extends Bloc<DriverLicenseEvent, DriverLicenseState> {
  
  MapBloc mapBloc;
  DriverLicenseBloc({this.mapBloc}) : super(DriverLicenseState());

  @override
  Stream<DriverLicenseState> mapEventToState(DriverLicenseEvent event) async* {

     if ( event is OnRequestDriverLicenseStatus ) {
      yield state.copyWith(
       driverLicense : await _fetchDriverLicenseData()
      );

     } else if ( event is OnInitialState) {
      yield state.initialState();

    } else if ( event is OnUploadLicense) {    
      yield* _postDriverLicenseData(event.imageBytes);
      
    } else if ( event is OnUpdateLicense) {    
      yield* _updateDriverLicenseData(event.imageBytes);
    }
  }

  Future<DriverLicense> _fetchDriverLicenseData() async {
     DriverLicense _driverlicense;
      try {
        _driverlicense = await DriverLicenseRepository.getDriverLicenseStatus(SharedPreferencesUtils.getValue(Constants.USER_ID));
      } on CustomException catch (e) {
         _driverlicense = DriverLicense.setError(e.errorCode, e.errorMessage);
      }
      return _driverlicense;
  }

  Stream<DriverLicenseState> _postDriverLicenseData(String imageBytes) async* {
    
    yield state.copyWith(
      uploadingImage: true
    );
    DriverLicense driverLicense;
    try {
      driverLicense = await DriverLicenseRepository.postDriverLicense(SharedPreferencesUtils.getValue(Constants.USER_ID), imageBytes);
      // Se invoca al BLOC del mapa para notificar el cambio del estado de licencia
      mapBloc.add(OnUpdateDriverlicenseState(driverLicense.status));
      } on CustomException catch (e) {
         // Se podría loggear el error
      }
      yield state.copyWith(
        uploadingImage: false,
        driverLicense: driverLicense
      );
  }

  Stream<DriverLicenseState> _updateDriverLicenseData(String imageBytes) async* {
    yield state.copyWith(
      uploadingImage: true
    );
    DriverLicense driverLicense;
    try {
        driverLicense = await DriverLicenseRepository.updateDriverLicense(SharedPreferencesUtils.getValue(Constants.USER_ID), imageBytes);
        // Se invoca al BLOC del mapa para notificar el cambio del estado de licencia
        mapBloc.add(OnUpdateDriverlicenseState(driverLicense.status));
      } on CustomException catch (e) {
         // Se podría loggear el error
      }
      yield state.copyWith(
        uploadingImage: false,
        driverLicense: driverLicense
      );
  }
}