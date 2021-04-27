import 'package:flutter/material.dart';

class AddCard extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children:[
            Text("Agregar tarjeta"),
            Icon(Icons.credit_card)
          ], 
        ),
      ),
    );
  }
}