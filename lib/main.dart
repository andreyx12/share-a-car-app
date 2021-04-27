import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_a_car/src/blocs/cards/cards_bloc.dart';
import 'package:share_a_car/src/blocs/driver_license/driver_license_bloc.dart';
import 'package:share_a_car/src/blocs/home/map_bloc.dart';
import 'package:share_a_car/src/blocs/login/login_bloc.dart';
import 'package:share_a_car/src/blocs/user_config/user_config_bloc.dart';
import 'package:share_a_car/src/blocs/user_registration/user_registration_bloc.dart';
import 'package:share_a_car/src/common/utils/shared_preferences_utils.dart';
import 'package:share_a_car/src/pages/cards/components/add_card.dart';
import 'package:share_a_car/src/pages/cards/cards_page.dart';
import 'package:share_a_car/src/pages/emergency_report/emergency_report_page.dart';
import 'package:share_a_car/src/pages/user_config/user_config_page.dart';
import 'package:share_a_car/src/pages/driver_license/driver_license_page.dart';
import 'package:share_a_car/src/pages/home/components/gps_access_page.dart';
import 'package:share_a_car/src/pages/home/home_page.dart';
import 'package:share_a_car/src/pages/home/components/validate_config.dart';
import 'package:share_a_car/src/pages/login/login_page.dart';
import 'package:share_a_car/src/pages/login/user_registration_page.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    _init();
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: ( _ ) => LoginBloc() ),
          BlocProvider(create: ( _ ) => MapBloc() ),
          BlocProvider(create: ( _ ) => CardsBloc() ),
          BlocProvider(create: ( BuildContext context ) => DriverLicenseBloc(
            mapBloc: BlocProvider.of<MapBloc>(context)
          ) ),
          BlocProvider(create: ( _ ) => UserConfigBloc() ),
          BlocProvider(create: ( _ ) => UserRegistrationBloc() ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Share a Car',
          initialRoute: 'login',
          routes: {
            '/': ( BuildContext context ) => HomePage(),
            'login': ( BuildContext context ) => LoginPage(),
            'userRegistration': ( BuildContext context ) => UserRegistrationPage(),
            'loading'   : ( BuildContext context ) => ValidateConfigPage(),
            'gpsvalidation'   : ( BuildContext context ) => GpsAccessPage(),
            'cards': ( BuildContext context ) => CardsPage(),
            'addCard': ( BuildContext context ) => AddCard(),
            'driverLicense': ( BuildContext context ) => DriverLicensePage(),
            'emergencyReport': ( BuildContext context ) => EmergencyReportPage(),
            'config': ( BuildContext context ) => UserConfigPage(),
          },
          theme: ThemeData(
            primaryColor: Colors.white,
            accentColor: Colors.green[400],
            inputDecorationTheme: InputDecorationTheme(
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.green)
              ),
            )
          ),
        ),
    );
  }

  void _init() {
    /* Se inicializan SharedPreferences */
    SharedPreferencesUtils.init();
     /* Establecer color de status bar */
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.white,
    ));
    /* Solamente permitir portrait mode */
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }
}