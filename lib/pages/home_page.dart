
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:share_a_car/blocs/map/map_bloc.dart';
import 'package:share_a_car/widgets/custom_app_bar.dart';
import 'package:share_a_car/widgets/custom_drawer.dart';
import 'package:share_a_car/widgets/custom_card.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    context.read<MapBloc>().initLocation();
    super.initState();
  }

  @override
  void dispose() {
    context.read<MapBloc>().stopLocation();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      drawer: CustomDrawer(),
      appBar: CustomAppBar(),
      body: Stack(
        children: [
          BlocBuilder<MapBloc, MapState>(
            builder: ( _ , state) {
              if (state.position == null && !state.mapReady) {
                return Center(
                  child: CircularProgressIndicator()
                );
              } else {
                  return _createMap( state );
              }
            }
          ),
          BlocConsumer<MapBloc, MapState>(
            buildWhen: (previous, current) {
                return ( previous.modalStatus != current.modalStatus ) || current.mapReady;
            },
            listener: (context, state) {},
            builder: (context, state) {
              if (state.mapReady){
                return CustomCard(
                  modalStatus: state.modalStatus,
                  onEndTimerCallback: state.modalStatus == ModalStatus.routeInProgress ?  _onEndTimerCallback : () {}
                );
               } else {
                return Container();
              }
            },
          ),
          BlocBuilder<MapBloc, MapState>(
            builder: ( _ , state) {
              if (state.loadingRouteInMap) {
                return Stack(
                  children: [
                    Container(
                      decoration: new BoxDecoration(
                        color: new Color.fromRGBO(0, 0, 0, 0.5)
                      ),
                    ),
                    Center(
                      child: CircularProgressIndicator()
                    ),
                  ],
                );
              } else {
                  return Container();
              }
            }
          ),
        ]
      )
    );
  }

  Widget _createMap(MapState state) {

    final mapBloc = BlocProvider.of<MapBloc>(context);

    final cameraPosition = new CameraPosition(
      target: state.position,
      zoom: 16,
    );

    return GoogleMap (
        buildingsEnabled: false,
        mapToolbarEnabled: false,
        compassEnabled: false,
        markers: state.markers.toSet(),
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        zoomGesturesEnabled: false,
        mapType: MapType.normal,
        polylines: state.polylines.values.toSet(),
        initialCameraPosition: cameraPosition,
        onMapCreated: (GoogleMapController controller) {
            mapBloc.initMap(controller, _onClickMarker);
        }
    );
  }

  void _onClickMarker(String marker) {
    final mapBloc = BlocProvider.of<MapBloc>(context);
    final markerInList = mapBloc.state.markers.where((el) => el.markerId.value == marker).first;
    mapBloc.add(OnMapCreateRoute(markerInList.position));
  }

  void _onEndTimerCallback() {
    final mapBloc = BlocProvider.of<MapBloc>(context);
    mapBloc.add(OnRouteFinished());
  }
}