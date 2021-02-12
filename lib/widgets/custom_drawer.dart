
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_a_car/blocs/map/map_bloc.dart';

class CustomDrawer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final mapBloc = BlocProvider.of<MapBloc>(context);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text("Andrey Castro", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            accountEmail: Text("andreyprueba@hotmail.com", style: TextStyle(color: Colors.white)),
            arrowColor: Colors.white,
            decoration: BoxDecoration(
              color: Colors.grey[400],
            ),
            currentAccountPicture: new CircleAvatar(
              radius: 80.0,
              backgroundColor: Colors.white,
              backgroundImage: AssetImage("assets/images/avatar.png")
            ),
          ),
          ListTile(
            title: Text('Tarjetas'),
            leading:  Icon(Icons.credit_card),
            onTap: () {
              Navigator.of(context).popAndPushNamed("cards");
            },
          ),
          ListTile(
            title: Text('Licencia de conducir'),
            leading:  Icon(Icons.picture_in_picture),
            onTap: () {
              mapBloc.add(OnChangeInfo(ModalStatus.routeInProgress));
              //Navigator.of(context).popAndPushNamed("test");
            },
          ),
          ListTile(
            title: Text('Reporte de emergencias'),
            leading:  Icon(Icons.warning),
            onTap: () {
              Navigator.of(context).pushNamed("cards");
            },
          ),
          ListTile(
            title: Text('Configuración'),
            leading:  Icon(Icons.settings),
            onTap: () {
              Navigator.of(context).pushNamed("cards");
            },
          ),
        ],
      ),
    );
  }
}