
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_a_car/src/blocs/home/map_bloc.dart';
import 'package:ticketview/ticketview.dart';

class InvoicePage extends StatelessWidget {

  final BuildContext modalBuildContext;
  final MapState mapState;

  InvoicePage({Key key, this.modalBuildContext, this.mapState}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Center(child: Text("¡El viaje ha finalizado!")),
        elevation: 0.0
      ),
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: TicketView(
          contentPadding: EdgeInsets.symmetric(vertical: 24, horizontal: 0),
          drawArc: false,
          triangleAxis: Axis.vertical,
          borderRadius: 6,
          drawDivider: true,
          trianglePos: .5,
          child: Container(
            child: _getReceipt(),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: EdgeInsets.only(right: 5.0, left: 5.0, bottom: Platform.isAndroid ? 5.0 : 0.0),
          child: ElevatedButton(
              style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.all(20.0)),
                enableFeedback: true,
                minimumSize: MaterialStateProperty.all(Size.fromHeight(50.0)),
                backgroundColor:  MaterialStateProperty.all(Colors.green[900]),
              ),
              child: Text('Cerrar', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
        ),
      ),
    );
  }

  Widget _getReceipt() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white
      ),
      child: Column(
        children: [
          SizedBox(height: 20.0),
          Text("Recibo del viaje", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
          SizedBox(height: 20.0),
          ListTile(
            leading: Icon(Icons.confirmation_num, size: 40, color: Colors.black),
            title: Text('Número de transacción'),
            subtitle: Text(mapState.trip.tripId.toString()),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.directions_car, size: 40, color: Colors.black),
            title: Text('Placa'),
            subtitle: Text(mapState.targetMarker.licensePlate),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.car_rental, size: 40, color: Colors.black),
            title: Text('Vehículo'),
            subtitle: Text(mapState.targetMarker.carName + " " + mapState.targetMarker.model),
          ),
          Divider(),   
          ListTile(
            leading: Icon(Icons.calendar_today, size: 40, color: Colors.black),
            title: Text('Fecha inicio'),
            subtitle: Text(DateFormat('dd-MM-yyyy hh:mm a').format(mapState.trip.startTime)),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.calendar_today, size: 40, color: Colors.black),
            title: Text('Fecha fin'),
            subtitle: Text(DateFormat('dd-MM-yyyy hh:mm a').format(mapState.trip.endTime)),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.attach_money, size: 40, color: Colors.black),
            title: Text('Costo por minuto'),
            subtitle: Text(mapState.trip.costPerMinute.toString()),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.credit_card, size: 40, color: Colors.black),
            title: Text('Monto total'),
            subtitle: Text(double.parse(mapState.trip.totalAmount).toStringAsFixed(2).toString()),
          ),
          SizedBox(height: 10.0),
        ]
      ),
    );
  }
}