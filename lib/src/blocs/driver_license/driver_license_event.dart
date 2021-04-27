part of 'driver_license_bloc.dart';

@immutable
abstract class DriverLicenseEvent {}

class OnRequestDriverLicenseStatus extends DriverLicenseEvent{
}

class OnInitialState extends DriverLicenseEvent{
}

class OnUploadLicense extends DriverLicenseEvent{
  final String imageBytes;
  OnUploadLicense(this.imageBytes);
}

class OnUpdateLicense extends DriverLicenseEvent{
  final String imageBytes;
  OnUpdateLicense(this.imageBytes);
}