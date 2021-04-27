import 'package:share_a_car/src/models/driver_license/driver_license.dart';
import 'package:share_a_car/src/providers/driver_license/driver_license_provider.dart';

class DriverLicenseRepository {

  static Future<DriverLicense> getDriverLicenseStatus(String userId) {
    return DriverLicenseProvider().getDriverLicenseStatus(userId);
  }

  static Future<DriverLicense> postDriverLicense(String userId, String imageBytes) {
    return DriverLicenseProvider().postDriverLicenseStatus(userId, imageBytes);
  }

  static Future<DriverLicense> updateDriverLicense(String userId, String imageBytes) {
    return DriverLicenseProvider().updateDriverLicenseStatus(userId, imageBytes);
  }
}