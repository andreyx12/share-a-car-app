
import 'package:flutter/material.dart';


class EmergencyReportPage extends StatefulWidget {
  @override
  _EmergencyReportPageState createState() => _EmergencyReportPageState();
}

class _EmergencyReportPageState extends State<EmergencyReportPage> {

  final TextEditingController _emergencyDescription = TextEditingController(); 
  final _formKey = GlobalKey<FormState>();
  bool _wasSentReport = false;

  @override
  void initState() { 
    super.initState();
  }

  @override
  void dispose() {
    _emergencyDescription.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("Reporte de emergencias"),
      ),
      body: !_wasSentReport ? SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 40.0),
              padding: EdgeInsets.all(10.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Text("* Para reportar su emergencia, favor escribirla de forma detallada (mínimo 10 carácteres), y, posteriormente nos pondremos en contacto para poder ayudarle.",
                      style: TextStyle(fontSize: 16.0)),
                    SizedBox(height: 15.0),
                    _showTextfield(),
                    SizedBox(height: 30.0),
                   _showReportButton(),
                  ]
                ),
              ),
            ),
          ]
        ),
      ): successScreen(size),
    );
  }

  Widget successScreen(Size size) {
     return SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: size.height * 0.5,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.green[400],
                    Colors.green[800]
                  ]
                )
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    iconSize: 110.0,
                    icon: Icon(Icons.check_circle_outline, color: Colors.white), 
                    onPressed: null
                  ),
                  SizedBox(height: 40.0),
                  Text("¡Éxito!", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30.0))
                ],
              ),
            ),
            Container(
              child: Column(
                children: [
                  SizedBox(height: 30.0),
                  Text("Reporte realizado con éxito", style: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.bold, fontSize: 20.0)),
                  SizedBox(height: 15.0),
                  Container(
                    padding: EdgeInsets.only(right: 30.0, left: 30.0),
                    child: Text("El reporte será gestionado por el departamente encargado, Share a Car se pondrá en contacto con usted lo más pronto posible.", style: TextStyle(color: Colors.grey[800])),
                  ),
                  SizedBox(height: 50.0),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.green),
                      textStyle: MaterialStateProperty.all(TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      shape: MaterialStateProperty.all(StadiumBorder())
                    ),
                    onPressed: (){
                        setState(() {
                          _wasSentReport = false;
                        });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
                      child: Text('Realizar otro reporte'),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
     );
  }

  Widget _showTextfield() {
    return TextFormField(
      decoration: InputDecoration(
        hintText: "Por favor, especifique la emergencia"
      ),
      maxLength: 100,
      validator: (value) {
        if (value.trim().length < 1) {
          return 'Debe ingresar una descripción';
        }
        if (value.trim().length > 1 && value.trim().length < 10) {
          return 'Debe ingresar una descripción más detallada';
        }
        return null;
      },
      controller: _emergencyDescription,
      minLines: 6,
      keyboardType: TextInputType.multiline,
      maxLines: null,
    );
  }

  Widget _showReportButton() {
    return  ElevatedButton(
      style: ButtonStyle(
        padding: MaterialStateProperty.all(EdgeInsets.all(20.0)),
        enableFeedback: true,
        minimumSize: MaterialStateProperty.all(Size.fromHeight(50.0)),
        backgroundColor:  MaterialStateProperty.all(Colors.green[900]),
      ),
      child: Text('Reportar', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),),
      onPressed: () {
        if(_formKey.currentState.validate()){
          setState(() {
            _wasSentReport = true;
          });
          _emergencyDescription.clear();
          _formKey.currentState.reset();
        } 
      },
    );
  }
}