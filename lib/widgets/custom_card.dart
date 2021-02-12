
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_countdown_timer/index.dart';
import 'package:share_a_car/blocs/map/map_bloc.dart';
import 'package:share_a_car/utils/constants.dart';

class CustomCard extends StatelessWidget {

  final Function onEndTimerCallback;
  final ModalStatus modalStatus;

  CustomCard({ @required this.modalStatus, this.onEndTimerCallback});
  
  @override
  Widget build(BuildContext context) {

    final mapBloc = BlocProvider.of<MapBloc>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
          Card(
            child: Column(
              children: [
                _getMapTile(modalStatus, mapBloc),
                SizedBox(
                  height: 50
                )
              ],
            ),
          ),

      ] 
    );
  }

   Widget _getMapTile(ModalStatus modalStatus, MapBloc mapBloc) {
     switch (modalStatus) {
       case ModalStatus.init:
          return _buildInitialTile();
        break;
      case ModalStatus.routeInProgress:
          return _buildRouteTimerTile(mapBloc);
        break;
      case ModalStatus.routeFinished:
          return Container();
        break;
      default:
          return _buildInitialTile();
        break;
     }
    }

    Widget _buildInitialTile() {
      return _getListTitle('Seleccione un vehículo en el mapa para empezar a viajar.', Icons.location_on);
    }

    Widget _buildRouteTimerTile(MapBloc mapBloc) {

      int endTime = new DateTime.now().millisecondsSinceEpoch + Constants.MAX_ARRIVAL_TIME_IN_MILLISECONDS * 10;
      
      return CountdownTimer(
          onEnd: () {
            onEndTimerCallback();
          },
          endTime: endTime,
          widgetBuilder: (BuildContext context, CurrentRemainingTime time) {

            String minutes = time.min != null ? time.min.toString() + ' minuto(s)' : Constants.EMPTY_STRING;
            return _getListTitle('Tiempo para llegar: ${minutes} ${time.sec} segundos.', Icons.alarm);
          }
      );
    }
    
   Widget _getListTitle(String textTile, IconData icon) {

      return ListTile(
          title: Text(textTile, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.0)),
          //subtitle: Text('My City, CA 99984'),
          leading: Icon(
            icon,
            color: Colors.green[400],
          ),
      );
   }
}