
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_a_car/src/blocs/home/map_bloc.dart';
import 'package:share_a_car/src/common/utils/constants.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {

  final MapBloc mapBloc;

  CustomAppBar(this.mapBloc);

  @override
  Widget build(BuildContext context) {

    return AppBar(
        bottom: mapBloc.state.showAppBarLoading ? MyLinearProgressIndicator() : null,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: 'Abrir menú',
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app_sharp),
            tooltip: 'Salir de la aplicación',
            onPressed: () {
              BlocProvider.of<MapBloc>(context).positionSubscription.cancel().then((value) {
                 Navigator.of(context).pushNamedAndRemoveUntil('login', (Route<dynamic> route) => false);
                 _completeTrip();
              });
            },
          ),
        ],
        centerTitle: true,
        title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/logo.png',
            height: 40,
            alignment: FractionalOffset.center,
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  void _completeTrip(){
    if (mapBloc.state.modalStatus == ModalStatus.routeInProgresss) {
      mapBloc.putUserAction(Constants.SHARE_A_CAR_COMPLETED, notes: "Usuario cerró la sesión");
    }
  }
}


const double _kMyLinearProgressIndicatorHeight = 6.0;

class MyLinearProgressIndicator extends LinearProgressIndicator implements PreferredSizeWidget {

  MyLinearProgressIndicator({
    Key key,
    double value,
    Color backgroundColor,
    Animation<Color> valueColor,
  }) : super(
          key: key,
          value: value,
          backgroundColor: Colors.white,
          valueColor: valueColor,
        ) {
    preferredSize = Size(double.infinity, _kMyLinearProgressIndicatorHeight);
  }

  @override
  Size preferredSize;
}
