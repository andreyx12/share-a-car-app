
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_a_car/src/blocs/home/map_bloc.dart';
import 'package:share_a_car/src/common/utils/constants.dart';
import 'package:share_a_car/src/common/utils/shared_preferences_utils.dart';

class CustomDrawer extends StatelessWidget {

  final MapBloc mapBloc;

  CustomDrawer(this.mapBloc);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(SharedPreferencesUtils.getValue(Constants.USERNAME), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            accountEmail: Text("test@test.com", style: TextStyle(color: Colors.white)),
            arrowColor: Colors.white,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(4,100,52, 1.0),
                  Color.fromRGBO(5, 128, 66, 1.0),
                ]
              ),
            ),
            currentAccountPicture: Hero(
                tag: "UserSettings",
                child: CircleAvatar(
                radius: 80.0,
                backgroundColor: Colors.grey,
                backgroundImage: AssetImage(Constants.PLACEHOLDER_PROFILE_IMAGE_PATH)
              ),
            ),
          ),
          ListTile(
            title: new Tooltip(message: "Consulte sus tarjetas registradas", child: Text('Tarjetas')),
            leading:  Icon(Icons.credit_card),
            onTap: () {
              Navigator.of(context).pushNamed("cards");
            },
          ),
          ListTile(
            title: new Tooltip(message: "Consulte la licencia de conducir registrada", child: Text('Licencia de conducir')),
            leading:  Icon(Icons.picture_in_picture),
            onTap: () {
              Navigator.of(context).pushNamed("driverLicense");
            },
          ),
          ListTile(
            title: new Tooltip(message: "Reporte su emergencia", child: Text('Reporte de emergencias')),
            leading:  Icon(Icons.warning),
            onTap: () {
              Navigator.of(context).pushNamed("emergencyReport");
            },
          ),
          ListTile(
            title: new Tooltip(message: "Configure sus preferencias", child: Text('Configuración')),
            leading:  Icon(Icons.settings),
            onTap: () {
              Navigator.of(context).pushNamed("config");
            },
          ),
          ListTile(
            title: new Tooltip(message: "Cierre su sesión", child: Text('Salir')),
            leading:  Icon(Icons.exit_to_app),
            onTap: () {
              BlocProvider.of<MapBloc>(context).positionSubscription.cancel().then((value) {
                 Navigator.of(context).pushNamedAndRemoveUntil('login', (Route<dynamic> route) => false);
                _completeTrip();
              });
            },
          ),
        ],
      ),
    );
  }

  void _completeTrip(){
    if (mapBloc.state.modalStatus == ModalStatus.routeInProgresss) {
      mapBloc.putUserAction(Constants.SHARE_A_CAR_COMPLETED, notes: "Usuario cerró la sesión");
    }
  }
}