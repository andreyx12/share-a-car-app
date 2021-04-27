
import 'package:flutter/material.dart';
import 'package:share_a_car/src/blocs/home/map_bloc.dart';
import 'package:share_a_car/src/common/utils/constants.dart';
import 'package:share_a_car/src/models/home/trip.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class SelectedMarkerPanelWidget extends StatelessWidget {

  final MapBloc mapBloc;
  final PanelController panelController;
  final Widget dragIconWidget;

  SelectedMarkerPanelWidget({@required this.mapBloc, this.panelController, this.dragIconWidget});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        dragIconWidget,
        _getPanelCarInfo(context),
        _getPanelButtons(context),
      ],
    );
  }

  Widget _getPanelCarInfo(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 10.0),
          height: 100.0,
          width: 200.0,
          decoration: new BoxDecoration(
            image: DecorationImage(
              repeat: ImageRepeat.noRepeat,
              image: AssetImage("assets/images/electric-car-1.png"),
              fit: BoxFit.cover
            ),
          ),
        ),
        ListTile(
          title: Text("Placa: " + mapBloc.state.targetMarker.licensePlate),
          leading: Icon(
            Icons.car_rental,
            color: Theme.of(context).accentColor,
          ),
        ),
        ListTile(
          title: Text("Modelo: " + mapBloc.state.targetMarker.carName + " " + mapBloc.state.targetMarker.model.toString()),
          leading: Icon(
            Icons.car_rental,
            color: Theme.of(context).accentColor,
          ),
        ),
        ListTile(
          title: Text("Color: " + mapBloc.state.targetMarker.color.toString()),
          leading: Icon(
            Icons.color_lens,
            color: Theme.of(context).accentColor,
          ),
        ),
        ListTile(
          title: Text("Distancia apróximada: " + getDistance(mapBloc.state.targetMarker.distance),
              style: TextStyle(fontWeight: FontWeight.w500)),
          leading: Icon(
            Icons.location_on,
            color: Theme.of(context).accentColor,
          ),
        ),
      ],
    );
  }

  Widget _getPanelButtons(BuildContext context) {
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
            Expanded(
              child: TextButton(
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(Size.fromHeight(50.0)),
                  backgroundColor:  MaterialStateProperty.all(Colors.green),
                ),
                child: Text('Reservar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17.0),),
                onPressed: () async {
                  Trip trip = await mapBloc.postUserAction(Constants.SHARE_A_CAR_RESERVED);
                  mapBloc.add(OnRegisterTrip(trip));
                  panelController.close().then((value) {
                    mapBloc.add(OnMapCreateRoute(mapBloc.state.targetMarker));
                    mapBloc.add(OnChangeModalInfo(ModalStatus.reservationProcess));
                  });
                },
              ),
            ),
            SizedBox(width: 3.0),
            Expanded(
              child: TextButton(
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(Size.fromHeight(50.0)),
                  backgroundColor:  MaterialStateProperty.all(Colors.green[900]),
                ),
                child: Text('Cancelar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17.0),),
                onPressed: () {
                  _closePanel();
                },
              ),
            ),
        ]
      )
    );
  }

  void _closePanel() {
    panelController.animatePanelToPosition(0.0, duration: Duration(microseconds: 0));
    mapBloc.add(OnChangeModalInfo(ModalStatus.init));
  }

  String getDistance(double distance) {
    bool areKm = (distance < 1000) ? true : false;
    String measurementUnit = areKm ? ' m' : ' Km' ;
    return areKm ? distance.toStringAsFixed(0) + measurementUnit : (distance / 1000).toStringAsFixed(1) + measurementUnit;
  }
}