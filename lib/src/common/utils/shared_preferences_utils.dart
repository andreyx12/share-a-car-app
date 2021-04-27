import 'package:share_a_car/src/common/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtils {

  static SharedPreferences _prefs;

  static init() async {
     _prefs = await SharedPreferences.getInstance();
  }

  static Future<bool> setValue(String key, String value) {
    return _prefs.setString(key, value);
  }
 
 static String getValue(String key) {
    return _prefs.getString(key) ?? Constants.EMPTY_STRING;
  }
}