import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';


class GpsAccessPage extends StatefulWidget {

  @override
  _GpsAccessPageState createState() => _GpsAccessPageState();
}

class _GpsAccessPageState extends State<GpsAccessPage> with WidgetsBindingObserver {

  bool popup = false;

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
    if (  state == AppLifecycleState.resumed && !popup ) {
      if ( await Permission.location.isGranted  ) {
        Navigator.pushReplacementNamed(context, '/');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Es necesario el GPS para usar esta app'),
            MaterialButton(
              child: Text('Solicitar Acceso', style: TextStyle( color: Colors.white )),
              color: Colors.black,
              shape: StadiumBorder(),
              elevation: 0,
              splashColor: Colors.transparent,
              onPressed: () async {
                popup = true;
                final status = await Permission.location.request();
                await this.accesoGPS( status );
                popup = false;
              }
            )
          ],
        )
     ),
   );
  }

  Future accesoGPS( PermissionStatus status ) async {
    switch ( status ) {
      case PermissionStatus.granted:
        await Navigator.pushReplacementNamed(context, '/');
        break;
      case PermissionStatus.undetermined:
      case PermissionStatus.denied:
      case PermissionStatus.restricted:
      case PermissionStatus.permanentlyDenied:
      case PermissionStatus.limited:
        openAppSettings();
        break;
    }
  }
}