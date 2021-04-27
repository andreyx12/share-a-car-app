
import 'package:flutter/material.dart';

class GenericContentPanelWidget extends StatelessWidget {

  final String text;
  final IconData icon;
  final MaterialColor color;

  GenericContentPanelWidget({this.text, this.icon, this.color});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(text, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15.0)),
        leading: Icon(
          icon,
          color: color != null ? color : Theme.of(context).accentColor,
        ),
    );
  }
}