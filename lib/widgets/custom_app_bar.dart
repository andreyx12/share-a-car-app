
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {

  @override
  Widget build(BuildContext context) {

    return AppBar(
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app_sharp),
            tooltip: 'Show Snackbar',
            onPressed: () {

            },
          ),
        ],
        centerTitle: true,
        title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/logo.png',
            //fit: BoxFit.contain,
            height: 40,
            alignment: FractionalOffset.center,
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}