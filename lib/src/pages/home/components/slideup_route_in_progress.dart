
import 'package:flutter/material.dart';
import 'package:share_a_car/src/blocs/home/map_bloc.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:intl/intl.dart';

class RouteInProgress extends StatelessWidget {

  final MapBloc mapBloc;
  final PanelController panelController;
  final Widget dragIconWidget;

  RouteInProgress({@required this.mapBloc, this.panelController, this.dragIconWidget});

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
    
    final String formattedDate =  DateFormat('dd-MM-yyyy hh:mm a').format(mapBloc.state.trip.startTime);

    return Column(
      children: [
        ListTile(
          title: RichText(
            text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children:[
                TextSpan(text: "Alquilado desde: ", style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: formattedDate),
              ],
            ),
          ),
          leading: Icon(
            Icons.date_range,
            color: Theme.of(context).accentColor,
          ),
        ),
        ListTile(
          title: Text(mapBloc.state.targetMarker.carName + " " + mapBloc.state.targetMarker.model.toString()),
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
      ],
    );
  }

  Widget _getPanelButtons(BuildContext context) {
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
            SizedBox(width: 3.0),
             Expanded(
              child: ElevatedButton(
                style: ButtonStyle(
                  enableFeedback: true,
                  minimumSize: MaterialStateProperty.all(Size.fromHeight(50.0)),
                  backgroundColor:  mapBloc.state.enableDeliveryButton ? MaterialStateProperty.all(Colors.green) : null,
                ),
                child: Text('Entregar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17.0),),
                onPressed: mapBloc.state.enableDeliveryButton ? () async {
                    _onClickCarDelivery(context);
                } : null,
              ),
            ),
            SizedBox(width: 3.0),
            Expanded(
              child: ElevatedButton(
                style: ButtonStyle(
                  enableFeedback: true,
                  minimumSize: MaterialStateProperty.all(Size.fromHeight(50.0)),
                  backgroundColor: mapBloc.state.enableDeliveryButton ? MaterialStateProperty.all(Colors.green[900]) : null,
                ),
                child: Text('Cancelar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17.0),),
                onPressed: mapBloc.state.enableDeliveryButton ? () {
                  _onClickCancelCarDelivery();
                } : null,
              ),
            ),
        ]
      )
    );
  }

  void _onClickCarDelivery(BuildContext context) async {
    if(await mapBloc.validateIfUserIsInDeliveryPlace()) {
        _showRouteFinishedAlert(context);
    } else {
        _showErrorValidationAlert(context);
    }
  }

  void _showErrorValidationAlert(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("¡Atención!"),
          content: SingleChildScrollView(
            child: Text("Auto aún se encuentra lejos del punto requerido.")
          ),
        );
      },
    );
  }

    void _showRouteFinishedAlert(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext contextDialog) {
        return AlertDialog(
          title: Text("¡Atención!"),
          content: SingleChildScrollView(
            child: Text("Está a punto de finalizar el recorrido. ¿Está seguro de finalizar el viaje?.")
          ),
          actions: [
              TextButton(
              child: Text('Aceptar', style: TextStyle(color: Colors.green)),
              onPressed: () async {
                await panelController.animatePanelToPosition(0.0, duration: Duration(microseconds: 0));
                mapBloc.add(OnRouteFinished());
                Navigator.of(contextDialog).pop();
              },
            ),
            TextButton(
              child: Text('Cancelar', style: TextStyle(color: Colors.green)),
              onPressed: () {
                Navigator.of(contextDialog).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _onClickCancelCarDelivery() {
    mapBloc.add(OnCancelDelivery());
    panelController.close();
  }

  String getDistance(double distance) {
    bool areKm = (distance < 1000) ? true : false;
    String measurementUnit = areKm ? ' m' : ' Km' ;
    return areKm ? distance.toStringAsFixed(0) + measurementUnit : (distance / 1000).toStringAsFixed(1) + measurementUnit;
  }
}