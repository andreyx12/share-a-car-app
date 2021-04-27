part of 'driver_license_bloc.dart';

class DriverLicenseState {
  
  bool uploadingImage;
  DriverLicense driverLicense;

  DriverLicenseState({
    this.driverLicense,
    this.uploadingImage = false
  });


  DriverLicenseState copyWith({
    DriverLicense driverLicense,
    bool uploadingImage,
  }) => DriverLicenseState(
    driverLicense: driverLicense ?? this.driverLicense,
    uploadingImage: uploadingImage ?? this.uploadingImage,
  );

  DriverLicenseState initialState() => new DriverLicenseState();
}