
import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:share_a_car/src/common/utils/custom_exception.dart';
import 'package:share_a_car/src/common/utils/shared_preferences_utils.dart';
import 'package:share_a_car/src/models/driver_license/driver_license.dart';
import 'package:share_a_car/src/models/home/marker_info.dart';
import 'package:share_a_car/src/common/themes/uber_map_theme.dart';
import 'package:share_a_car/src/common/utils/constants.dart';
import 'package:share_a_car/src/common/utils/map_utils.dart';
import 'package:share_a_car/src/models/home/trip.dart';
import 'package:share_a_car/src/repository/driver_license/driver_license_repository.dart';
import 'package:share_a_car/src/repository/home/home_repository.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {

  MapBloc() : super( MapState() );

  Function carMarkerOnclickCallback;

  GoogleMapController _mapController;

  final _geolocator = new Geolocator();

  final PanelController _pc = PanelController();

  StreamSubscription<Position> _positionSubscription;

  PanelController get panelController => _pc;

  GoogleMapController get mapController => _mapController;

  StreamSubscription<Position> get positionSubscription => _positionSubscription;

  void set positionSubscription(value) => _positionSubscription = value;

  void initLocation() {
    final locationOptions = LocationOptions(
      accuracy: LocationAccuracy.high,
      distanceFilter: 15
    );
    _positionSubscription = this._geolocator.getPositionStream(locationOptions).listen(( Position position ) {
      final location = new LatLng(position.latitude, position.longitude);
      Future.delayed(const Duration(seconds: 1), (){
        add( OnMapPosition( location ) );
        // Si hay una ruta en progreso, se manda a actualizar la ruta conforme el usuario avance
        if (state.routeInProgress) {
          add(OnUpdateRoute());
        }
      });
    });
  }

  void initMap( GoogleMapController controller, Function markerOnclickCallback) {
      this._mapController = controller;
      carMarkerOnclickCallback = markerOnclickCallback;
      addMapStyle();
      add(OnMapReady(markerOnclickCallback));
  }

  void addMapStyle() {
    this._mapController.setMapStyle( jsonEncode(mapLightTheme) );
  }

  void moveCamera( LatLng destino, double zoom ) {
    final cameraUpdate = CameraUpdate.newLatLngZoom(destino, zoom);
    this._mapController?.animateCamera(cameraUpdate);
  }

   Future<bool> validateIfUserIsInDeliveryPlace() async {
    if (state.deliveryTargetMarker == null) {
      return false;
    } else {
      double distance = await MapUtils.getDistanceBetween(state.currentPosition, state.deliveryTargetMarker.marker.position);
      return distance <= 5;
    }
  }

  Future<String> fetchDriverLicenseData() async {
     String _status;
      try {
        DriverLicense _driverlicense = await DriverLicenseRepository.getDriverLicenseStatus(SharedPreferencesUtils.getValue(Constants.USER_ID));
        _status =  _driverlicense.status;
      } on CustomException catch (e) {
        if (e.errorCode == "404") {
          _status =  Constants.DRIVER_LICENSE_STATUS_NOT_REGISTERED;
        }
      }
      return _status;
  }

  Future<Trip> postUserAction(String tripStatus) async {
    Trip _tripRequest = new Trip(
      vehicleId: state.targetMarker.vehicleId,
      userId: int.parse(SharedPreferencesUtils.getValue(Constants.USER_ID)),
      tripStatus: tripStatus
    );
    Trip _tripResponse;
    try {
      _tripResponse = await HomeRepository.postTripStatus(_tripRequest);
    } on CustomException catch (e) {
        _tripResponse = Trip.setError(e.errorCode, e.errorMessage);
    }
    return _tripResponse;
  }

  Future<Trip> putUserAction(String tripStatus, {String notes}) async {
     Trip _tripRequest = new Trip(
      tripId: state.trip.tripId,
      vehicleId: state.targetMarker.vehicleId,
      userId: int.parse(SharedPreferencesUtils.getValue(Constants.USER_ID)),
      startTime: state.trip.startTime,
      endTime: state.trip.endTime,
      tripStatus: tripStatus,
      tripNotes: notes != null ? notes : null
    );
    Trip _tripResponse;
    try {
      _tripResponse = await HomeRepository.putTripStatus(_tripRequest);
    } on CustomException catch (e) {
        _tripResponse = Trip.setError(e.errorCode, e.errorMessage);
    }
    return _tripResponse;
  }

  @override
  Stream<MapState> mapEventToState( MapEvent event ) async* {

    if ( event is OnMapPosition ) {
      yield state.copyWith(  
        currentPosition: event.latLng 
      );

    } else if ( event is OnMapReady) {
      yield* this._onMapReady( event );

    } else if ( event is OnSelectedmarker ) {
        yield* this._selectedMarker( event );

    } else if ( event is OnMapCreateRoute ) {
       yield* this._createRoute( event );

    } else if ( event is OnDropOffCar ) {
       yield* this._dropOffCar( event );

    } else if ( event is OnUpdateRoute ) {
       yield* this._updateRoute();

    } else if ( event is OnRouteFinished) {
        yield* _routeFinished();
        
    } else if ( event is OnChangeModalInfo) {
       yield* this._onChangeModalInfo(event);

    } else if ( event is OnInitialState) {
      yield state.initialState();

    } else if ( event is OnMovePanel) {
      yield state.copyWith(
        panelHeight: event.panelHeight,
      );
    } else if ( event is OnCancelDelivery) {
      yield* this._cancelDelivery(event);

    } else if ( event is OnCancelReservation) {
      yield* this._cancelReservation(event);

    } else if ( event is OnRegisterTrip) {
      yield state.copyWith(
        trip: event.trip,
      );
    } else if ( event is OnUpdateDriverlicenseState) {
      yield state.copyWith(
        driverLicenseStatus: event.status,
      );

    } else if ( event is OnRequestStatusLicense) {
         yield* this._onRequestStatusLicense(event);
    }
  }

  Stream<MapState> _onMapReady(OnMapReady event) async* {

    List<MarkerInfo> markersList = await MapUtils.createDynamicMarkers(Constants.PICK_UP_MARKER_ICON, 200, event.markerOnclickCallback);

    yield state.copyWith(
      mapReady: true,
      markers: markersList,
      driverLicenseStatus: await fetchDriverLicenseData()
    );
  }

  Stream<MapState> _selectedMarker(OnSelectedmarker event) async* {

    final distance = await MapUtils.getDistanceBetween(state.currentPosition, event.marker.marker.position);

      event.marker.distance = distance;

      yield state.copyWith(
        trip: new Trip(),
        targetMarker: event.marker,
        modalStatus: ModalStatus.selectedMarker
      );
  }

  Stream<MapState> _createRoute(OnMapCreateRoute event) async* {
         
      yield state.copyWith(
        loadingRouteInMap: true,
      );

      final position = await MapUtils.getPolylines(state.currentPosition, event.targetMarker.marker.position);

      this.moveCamera(LatLng(state.currentPosition.latitude, state.currentPosition.longitude), Constants.DEFAULT_MAP_ZOOM_IN);
      
      yield state.copyWith(
        polylines: position,
        targetMarker: event.targetMarker,
        routeInProgress: true,
        loadingRouteInMap: false
      );
  }

    Stream<MapState> _dropOffCar(OnDropOffCar event) async* {
         
      yield state.copyWith(
        loadingRouteInMap: true,
      );

      final position = await MapUtils.getPolylines(state.currentPosition, event.targetMarker.marker.position);

      this.moveCamera(LatLng(state.currentPosition.latitude, state.currentPosition.longitude), Constants.DEFAULT_MAP_ZOOM_IN);
      
      yield state.copyWith(
        polylines: position,
        deliveryTargetMarker: event.targetMarker,
        routeInProgress: true,
        loadingRouteInMap: false,
        enableDeliveryButton: true,
      );
  }

  Stream<MapState> _updateRoute() async* {
      final newPosition = await MapUtils.getPolylines(state.currentPosition, state.targetMarker.marker.position);
      yield state.copyWith(
        polylines: newPosition,
      );
  }

  Stream<MapState> _routeFinished() async* {
      yield state.copyWith(
        modalStatus: ModalStatus.finishingTrip
      );

      Trip _trip = await putUserAction(Constants.SHARE_A_CAR_COMPLETED);
    
      if (_trip.errorCode == null) {
        this.moveCamera(LatLng(state.currentPosition.latitude, state.currentPosition.longitude), Constants.DEFAULT_MAP_ZOOM_OUT);
        add(OnMapReady(this.carMarkerOnclickCallback));
        _trip.invoiceId = 10;
        yield state.copyWith(
          trip: _trip,
          polylines: new Map(),
          routeInProgress: false,
          modalStatus: ModalStatus.init
        );
      }
  }

  Stream<MapState> _cancelDelivery(OnCancelDelivery event) async* {
      this.moveCamera(LatLng(state.currentPosition.latitude, state.currentPosition.longitude), Constants.DEFAULT_MAP_ZOOM_IN);
      yield state.copyWith(
        deliveryTargetMarker: null,
        enableDeliveryButton: false,
        polylines: new Map(),
      );
  }

  Stream<MapState> _cancelReservation(OnCancelReservation event) async* {
      putUserAction(Constants.SHARE_A_CAR_CANCELED, notes:"Usuario canceló la reserva");
      this.moveCamera(LatLng(state.currentPosition.latitude, state.currentPosition.longitude), Constants.DEFAULT_MAP_ZOOM_OUT);
      add(OnMapReady(this.carMarkerOnclickCallback));

      yield state.copyWith(
        trip: new Trip(),
        polylines: new Map(),
        routeInProgress: false,
        modalStatus: ModalStatus.init
      );
  }

  Stream<MapState> _onChangeModalInfo(OnChangeModalInfo event) async* {
      switch (event.modalStatus) {
        case ModalStatus.routeInProgresss:
          this.moveCamera(LatLng(state.currentPosition.latitude, state.currentPosition.longitude), Constants.DEFAULT_MAP_ZOOM_OUT);
          List<MarkerInfo> markersList = await MapUtils.createDynamicMarkers(Constants.DROP_OFF_MARKER_ICON, 100, (value){
            panelController.animatePanelToPosition(0.0, duration: Duration(microseconds: 0));
            final markerInList = state.markers.where((el) => el.markerId == value).first;
            add(OnDropOffCar(markerInList));
          });
          yield state.copyWith(
            markers: markersList,
            modalStatus: event.modalStatus,
            polylines: new Map()
          );
          break;
        case ModalStatus.reservationProcess:
          state.targetMarker.rentalDate = DateTime.now();
          yield state.copyWith(
            modalStatus: event.modalStatus,
            targetMarker: state.targetMarker
          );
          break;
        default:
          yield state.copyWith(
            modalStatus: event.modalStatus,
          );
          break;
      }
  }

  Stream<MapState> _onRequestStatusLicense(OnRequestStatusLicense event) async* {

    yield state.copyWith(showAppBarLoading: true);

    String status = await fetchDriverLicenseData();

    if (status == Constants.DRIVER_LICENSE_STATUS_APPROVED) {
      /* Si la licencia fue aprobada. */
      add(OnSelectedmarker(event.targetMarker));
      yield state.copyWith(showAppBarLoading: false);
      panelController.open();
    } else {
      /* En caso de que la licencia aún no haya sido aprobada. */
      yield state.copyWith(
        driverLicenseStatus: status,
        showAppBarLoading: false,
        modalStatus: ModalStatus.licenseNotRegistered
      );
    }
  }
}