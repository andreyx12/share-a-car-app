part of 'map_bloc.dart';

@immutable
abstract class MapEvent {}

class OnMapPosition extends MapEvent{
  final LatLng latLng;
  OnMapPosition(this.latLng);
}

class OnMapReady extends MapEvent{
  final Function markerOnclickCallback;
  OnMapReady(this.markerOnclickCallback);
}

class OnMapCreateRoute extends MapEvent{
  final LatLng latLng;
  OnMapCreateRoute(this.latLng);
}

class OnRouteFinished extends MapEvent{
  OnRouteFinished();
}

class OnUpdateRoute extends MapEvent{}

class OnAddMarkers extends MapEvent{
   final List<Marker> markers;
   OnAddMarkers(this.markers);
}

class OnChangeInfo extends MapEvent{
   final ModalStatus modalStatus;
   OnChangeInfo(this.modalStatus);
}