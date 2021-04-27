import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_a_car/src/pages/home/home_page.dart';
import 'package:share_a_car/src/common/widgets/navigate_fadein.dart';

import 'gps_access_page.dart';


class ValidateConfigPage extends StatefulWidget {

  @override
  _ValidateConfigPageState createState() => _ValidateConfigPageState();
}

class _ValidateConfigPageState extends State<ValidateConfigPage> with WidgetsBindingObserver {

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async{
    if (  state == AppLifecycleState.resumed ) {
      if ( !await Geolocator().isLocationServiceEnabled()  ) {
        Navigator.pushReplacement(context, navigateFadeIn(context, GpsAccessPage() ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: this.checkGpsYLocation(context),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          
          if ( snapshot.hasData ) {
            return Center(child: Text( snapshot.data ) );
          } else {
            return Center(child: CircularProgressIndicator(strokeWidth: 2 ) );
          }
        },
      ),
   );
  }

  Future checkGpsYLocation( BuildContext context ) async {

    // PermisoGPS
    final permisoGPS = await Permission.location.isGranted;
    // GPS está activo
    final gpsActivo  = await Geolocator().isLocationServiceEnabled();

    if ( permisoGPS && gpsActivo ) {
      Navigator.pushReplacement(context, navigateFadeIn(context, HomePage()));
      return '';
    } else if ( !permisoGPS ) {
      Navigator.pushReplacement(context, navigateFadeIn(context, GpsAccessPage()));
      return 'Es necesario el permiso de GPS';
    } else {
      return 'Active el GPS';
    }
  }
}