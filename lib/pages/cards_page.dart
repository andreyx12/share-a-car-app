
import 'package:flutter/material.dart';

class CardsPage extends StatelessWidget {
  const CardsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ss
    return Scaffold(
      appBar: AppBar(
        title: Text("Mis tarjetas"),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 40.0),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: [
              if (false) _getCardsList(),
              Row(
                children: [
                  IconButton(
                    iconSize: 40.0,
                    icon: Icon(Icons.add_box),
                    onPressed: () {
                      Navigator.of(context).pushNamed("addCard");
                    },
                  ),
                  SizedBox(width: 20.0),
                  Text("Agregar tarjeta")
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getCardsList() {

      List<String> cards = new  List<String>();
      cards.add("12345");
      cards.add("23456");

      return new Row(children: cards.map((item) => new Text(item)).toList());
  }
}