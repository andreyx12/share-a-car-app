part of 'map_bloc.dart';

@immutable
abstract class MapEvent {}

class OnInitialState extends MapEvent{}

class OnMapPosition extends MapEvent{
  final LatLng latLng;
  OnMapPosition(this.latLng);
}

class OnMapReady extends MapEvent{
  final Function markerOnclickCallback;
  OnMapReady(this.markerOnclickCallback);
}

class OnMapCreateRoute extends MapEvent{
  final MarkerInfo targetMarker;
  OnMapCreateRoute(this.targetMarker);
}

class OnUpdateRoute extends MapEvent{}

class OnChangeModalInfo extends MapEvent{
   final ModalStatus modalStatus;
   final Function callback;
   OnChangeModalInfo(this.modalStatus, {this.callback});
}

class OnMovePanel extends MapEvent{
   final double panelHeight;
   OnMovePanel(this.panelHeight);
}
class OnSelectedmarker extends MapEvent{
   final MarkerInfo marker;
   OnSelectedmarker(this.marker);
}

class OnRouteFinished extends MapEvent{
  OnRouteFinished();
}

class OnDropOffCar extends MapEvent{
  final MarkerInfo targetMarker;
  OnDropOffCar(this.targetMarker);
}


class OnCancelDelivery extends MapEvent {
}

class OnCancelReservation extends MapEvent {
}

class OnCompleteTrip extends MapEvent {
  final String status;
  OnCompleteTrip(this.status);
}

class OnRegisterTrip extends MapEvent {
  final Trip trip;
  OnRegisterTrip(this.trip);
}

class OnUpdateDriverlicenseState extends MapEvent {
  final String status;
  OnUpdateDriverlicenseState(this.status);
}

class OnRequestStatusLicense extends MapEvent {
  final MarkerInfo targetMarker;
  OnRequestStatusLicense(this.targetMarker);
}
