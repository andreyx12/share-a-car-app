import 'package:share_a_car/src/models/user_config/user_config.dart';
import 'package:share_a_car/src/providers/user_config/user_config_provider.dart';

class UserConfigRepository {

  static Future<UserConfig> getUserConfig(String userId){
    return UserConfigProvider().getUserConfig(userId);
  }

  static Future<UserConfig> updateUserConfig(UserConfig userConfig){
    return UserConfigProvider().updateUserConfig(userConfig);
  }
}