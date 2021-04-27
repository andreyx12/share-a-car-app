
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:share_a_car/src/blocs/home/map_bloc.dart';
import 'package:share_a_car/src/common/utils/constants.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class MapWidget extends StatelessWidget {

  final MapBloc mapBloc;
  final PanelController panelController;
  final Function onMapReady;

  MapWidget({@required this.mapBloc, this.panelController, this.onMapReady});

  @override
  Widget build(BuildContext context) {

    final cameraPosition = new CameraPosition(
      target: mapBloc.state.currentPosition,
      zoom: Constants.DEFAULT_MAP_ZOOM_OUT,
    );
    // Build del mapa de Google maps
    return GoogleMap (
        buildingsEnabled: false,
        mapToolbarEnabled: false,
        compassEnabled: false,
        markers: mapBloc.state.markers.map((e) => e.marker).toSet(),
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: true,
        zoomGesturesEnabled: true,
        mapType: MapType.normal,
        //circles: circles,
        polylines: mapBloc.state.polylines.values.toSet(),
        initialCameraPosition: cameraPosition,
        onMapCreated: (GoogleMapController controller) {
            onMapReady();
            mapBloc.initMap(controller, _onClickMarker);
        }
    );
  }

  void _onClickMarker(String marker) async {
    if (!mapBloc.state.routeInProgress) {
        final markerInList = mapBloc.state.markers.where((el) => el.markerId == marker).first;
        mapBloc.add(OnRequestStatusLicense(markerInList));
    }
  }

  double getCircularRadious(){
    /* Se divide la cantidad de km/h promedio de una persona caminando entre 60,
    para obtener la velocidad en km por minuto, luego, se multiplica por 1000 para 
    obtener la velocidad en metros por minuto */
    double metersWalkingByMinute = (5 / 60) * 1000;
    return (metersWalkingByMinute * Constants.MAX_ARRIVAL_TIME_IN_MINUTES);
  }
}