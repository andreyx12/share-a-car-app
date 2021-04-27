import 'package:flutter/material.dart';

class ModalAlert {

    static showMyDialog({@required context, Widget title, ListBody body, List<Widget> actions}) async {
      return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          String contentText = "Content of Dialog";
          return AlertDialog(
            title: title,
            content: StatefulBuilder(
              builder: (BuildContext context, setState) {
                return SingleChildScrollView(
                  child: Text(contentText)
                );
              },
            ),
            actions: actions
          );
        },
      );
    }
}