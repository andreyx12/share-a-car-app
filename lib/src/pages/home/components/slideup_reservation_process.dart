
import 'dart:io';

import 'package:countdown_flutter/countdown_flutter.dart';
import 'package:flutter/material.dart';
import 'package:share_a_car/src/blocs/home/map_bloc.dart';
import 'package:share_a_car/src/common/utils/constants.dart';
import 'package:share_a_car/src/models/home/trip.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class ReservationProcessPanelWidget extends StatelessWidget {
  
  final MapBloc mapBloc;
  final PanelController panelController;
  final Widget dragIconWidget;

  ReservationProcessPanelWidget({@required this.mapBloc, this.panelController, this.dragIconWidget});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        dragIconWidget,
        _createTimer(context),
        _getPanelCarInfo(context),
        _getPanelButtons(context),
      ],
    );
  }

  Widget _createTimer(BuildContext context) {
    return Countdown(
      duration: Duration(minutes: Constants.MAX_ARRIVAL_TIME_IN_MINUTES),
      onFinish: _closePanel,
      builder: ( _ , Duration remaining) {

        String twoDigits(int n) => n.toString().padLeft(2, "0");

        String twoDigitMinutes = remaining.inMinutes >= 1 ? remaining.inMinutes.remainder(60).toString() + " min(s)" : Constants.EMPTY_STRING;
        String twoDigitSeconds = twoDigits(remaining.inSeconds.remainder(60)) + " seg(s)";

          return ListTile(
          title: Text('Tiempo para llegar: ${twoDigitMinutes} ${twoDigitSeconds}.', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.0)),
          leading: Icon(
            Icons.alarm,
            color: Theme.of(context).accentColor,
          ),
        );
      },
    );
  }

  Widget _getPanelCarInfo(BuildContext context) {
    return Column(
      children: [
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
        )
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
                  child: Text('Ingresar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17.0),),
                  onPressed: () {
                    _showValidationCodeDialog(context);
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

  void _showValidationCodeDialog(BuildContext context) {

    final _formKey = GlobalKey<FormState>();
    final textfieldController = TextEditingController();
    final FocusNode myFocusNode = FocusNode();

      bool isLoading = false;
      bool isReadOnly = false;

     showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (dialogContex) {
        
        return StatefulBuilder(
          builder: (buildContent, setState) {
            return Form(
              key: _formKey,
              child: Container(
                color: Colors.transparent,
                child: new Container(
                  decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(10.0),
                      topRight: const Radius.circular(10.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10.0,
                        spreadRadius: 0.0,
                      )
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      _getContentVerificationModalHeader(dialogContex, isReadOnly),
                      Container(
                        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: const Color(0xfff8f8f8),
                              width: 1,
                            ),
                          ),
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: 15.0),
                            Text(
                              "Por favor, ingrese el código que se encuentra en la puerta del auto para poder validar su identidad y brindarle acceso al vehículo.",
                              style: TextStyle(
                                fontSize: 17.0
                              ),
                            ),
                            SizedBox(height: 40.0),
                            TextFormField(
                              readOnly: isReadOnly,
                              controller: textfieldController,
                              focusNode: myFocusNode,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 30.0,
                                color: Colors.black                  
                              ),
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.green, width: 2.0),
                                ),
                                border: OutlineInputBorder(),
                                hintText: "Ej: XV7JW2YA",
                              ),
                              validator: (value) {
                                if (value.trim().length < 1 || value.trim().length < 8) {
                                  return 'Debe ingresar un código válido';
                                }
                                return null;
                              },
                              autofocus: true,
                              maxLength: 8,
                              minLines: 1,
                              textCapitalization: TextCapitalization.characters
                            ),
                            SizedBox(height: 20.0),
                            !isLoading ? TextButton(
                              style: ButtonStyle(
                                overlayColor: MaterialStateProperty.all(Colors.green[900]),
                                minimumSize: MaterialStateProperty.all(Size.fromHeight(70.0)),
                                backgroundColor:  MaterialStateProperty.all(Colors.green),
                              ),
                              child: Text('Verificar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 19.0),),
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {

                                  setState(() {
                                    isLoading = true;
                                    isReadOnly = true;
                                  });

                                  Trip _trip = await mapBloc.putUserAction(Constants.SHARE_A_CAR_RENTED);
                                   if (_trip.errorCode == null) {
                                    mapBloc.add(OnRegisterTrip(_trip));
                                    panelController.close().then((value) {
                                      mapBloc.add(OnChangeModalInfo(ModalStatus.routeInProgresss));
                                      Navigator.of(dialogContex).pop();
                                      _showVerificationAlert(context);        
                                    });
                                   } else {
                                    setState(() {
                                      isLoading = false;
                                      isReadOnly = false;
                                    });
                                   }
                                }
                              },
                            ): CircularProgressIndicator(),
                            SizedBox(height: Platform.isAndroid? 5.0 : 20.0),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      });
  }

  Widget _getContentVerificationModalHeader(BuildContext dialogContex, bool isReadOnly){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
          margin: EdgeInsets.only(top: 5, left: 10),
          child: Text(
            "Verificación de código",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: Colors.black87),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 5, right: 5),
          child: TextButton(
            style: ButtonStyle(
              padding: MaterialStateProperty.all(EdgeInsets.fromLTRB(5, 0, 5, 0)),
            ),
            onPressed: () {
              if (!isReadOnly) {
                Navigator.pop(dialogContex);
              }
            },
            child: Text(
              "Cerrar",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xff999999),
              ),
            ),
          )
        ),
      ],
    );
  }

  void _showVerificationAlert(BuildContext context){

    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      pageBuilder: (BuildContext buildContext, __, ___) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            title: Center(
              child: RichText(
                text: TextSpan(
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                ),
                text:  "¡Vehículo alquilado con éxito!",
                  children:[
                    WidgetSpan(
                      child: Icon(Icons.check, color: Colors.green,),
                    ),
                ],
                ),
              ),
            ),
            elevation: 0.0
          ),
          backgroundColor: Colors.white,
          body: Container(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: const Color(0xfff8f8f8),
                  width: 1,
                ),
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.0),
                  RichText(
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                      text:"El vehículo reservado fue alquilado con éxito, cuando termine de utilizarlo, diríjase al punto 'Share' más cercano:",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Colors.black,
                        wordSpacing: 1
                      )
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Image(
                      image: AssetImage("assets/images/dropoffmap.png")
                    )
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  RichText(
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                      text:"Si el vehículo presenta algún inconveniente, favor reportarlo de inmediato:",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Colors.black,
                        wordSpacing: 1
                      )
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: OutlinedButton(
                      child: Text("Reportar incidente"),
                      onPressed: () {
                        Navigator.of(buildContext).pushNamed("emergencyReport");
                      },
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all(Colors.green),
                        padding: MaterialStateProperty.all(EdgeInsets.all(20.0)),
                        minimumSize: MaterialStateProperty.all(Size.fromHeight(50.0)),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          bottomNavigationBar: SafeArea(
            child: Container(
              padding: EdgeInsets.only(right: 5.0, left: 5.0, bottom: Platform.isAndroid ? 5.0 : 0.0),
              decoration: BoxDecoration(

              ),
              child: ElevatedButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(EdgeInsets.all(20.0)),
                    enableFeedback: true,
                    minimumSize: MaterialStateProperty.all(Size.fromHeight(50.0)),
                    backgroundColor:  MaterialStateProperty.all(Colors.green[900]),
                  ),
                  child: Text('Aceptar', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),),
                  onPressed: () {
                    Navigator.of(buildContext).pop();
                  },
                ),
            ),
          ),
        );
      },
    );
  }

  void _closePanel() {
    panelController.animatePanelToPosition(0.0, duration: Duration(microseconds: 0));
    mapBloc.add(OnCancelReservation());
  }
}