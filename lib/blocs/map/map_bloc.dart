
import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:share_a_car/utils/map_utils.dart';

import 'package:share_a_car/themes/uber_map_theme.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {

  MapBloc() : super( MapState() );

  GoogleMapController _mapController;

  final _geolocator = new Geolocator();

  StreamSubscription<Position> _positionSubscription;

  void initLocation() {
    final locationOptions = LocationOptions(
      accuracy: LocationAccuracy.high,
      distanceFilter: 1
    );
    _positionSubscription = this._geolocator.getPositionStream(locationOptions).listen(( Position position ) {
      final location = new LatLng(position.latitude, position.longitude);
      add( OnMapPosition( location ) );
      add(OnUpdateRoute());
    });
  }

  void initMap( GoogleMapController controller, Function markerOnclickCallback ) {
    if ( !state.mapReady ) {
      this._mapController = controller;
      //this._mapController.setMapStyle( jsonEncode(uberMapTheme) );
      add(OnMapReady(markerOnclickCallback));
    }
  }

  void stopLocation() {
    _positionSubscription?.cancel();
  }

  void moveCamera( LatLng destino ) {
    final cameraUpdate = CameraUpdate.newLatLng(destino);
    this._mapController?.animateCamera(cameraUpdate);
  }

  @override
  Stream<MapState> mapEventToState( MapEvent event ) async* {
    
    if ( event is OnMapPosition ) {
      yield state.copyWith(  
        position: event.latLng 
      );

    } else if ( event is OnMapReady) {

      yield state.copyWith(
        mapReady: true,
        markers: MapUtils.createDynamicMarkers(event.markerOnclickCallback)
      );

    } else if ( event is OnMapCreateRoute ) {
       yield* this._createRoute( event );

    } else if ( event is OnUpdateRoute ) {
       yield* this._updateRoute();

    } else if ( event is OnRouteFinished) {
        yield* _routeFinished();
    } else if ( event is OnChangeInfo) {
        yield state.copyWith(
          modalStatus: event.modalStatus,
        );
    }
  }

  Stream<MapState> _createRoute(OnMapCreateRoute event) async* {
         
      yield state.copyWith(
        loadingRouteInMap: true
      );

      final position = await MapUtils.getPolylines(state.position, event.latLng);

      this.moveCamera(LatLng(state.position.latitude, state.position.longitude));
      
      yield state.copyWith(
        polylines: position,
        targetMarkerPosition: event.latLng,
        routeInProgress: true,
        loadingRouteInMap: false,
        modalStatus: ModalStatus.routeInProgress,
      );
  }

  Stream<MapState> _updateRoute() async* {

      if (state.routeInProgress) {

        final newPosition = await MapUtils.getPolylines(state.position, state.targetMarkerPosition);
        
        // Mejora: Validar sobreescribir con spread operator el array para actualizar
        //   final points = [ ...this._miRuta.points, event.ubicacion ];
  //   this._miRuta = this._miRuta.copyWith( pointsParam: points );

        yield state.copyWith(
          polylines: newPosition,
        );
      }
  }

  Stream<MapState> _routeFinished() async* {
      yield state.copyWith(
        polylines: new Map(),
        routeInProgress: false,
        modalStatus: ModalStatus.init
      );
  }

  
  // Stream<MapState> _onNuevaUbicacion( OnNuevaUbicacion event ) async* {

  //   if ( state.seguirUbicacion ) {
  //     this.moverCamara( event.ubicacion );
  //   }


  //   final points = [ ...this._miRuta.points, event.ubicacion ];
  //   this._miRuta = this._miRuta.copyWith( pointsParam: points );

  //   final currentPolylines = state.polylines;
  //   currentPolylines['mi_ruta'] = this._miRuta;

  //   yield state.copyWith( polylines: currentPolylines );

  // }

  // Stream<MapState> _onMarcarRecorrido( OnMarcarRecorrido event ) async* {

  //   if ( !state.dibujarRecorrido ) {
  //     this._miRuta = this._miRuta.copyWith( colorParam: Colors.black87 );
  //   } else {
  //     this._miRuta = this._miRuta.copyWith( colorParam: Colors.transparent );
  //   }

  //   final currentPolylines = state.polylines;
  //   currentPolylines['mi_ruta'] = this._miRuta;

  //   yield state.copyWith( 
  //     dibujarRecorrido: !state.dibujarRecorrido,
  //     polylines: currentPolylines
  //   );
  // }

  // Stream<MapState> _onSeguirUbicacion( OnSeguirUbicacion event ) async* {

  //   if ( !state.seguirUbicacion ) {
  //     this.moverCamara( this._miRuta.points[ this._miRuta.points.length - 1 ] );
  //   }
  //   yield state.copyWith( seguirUbicacion: !state.seguirUbicacion );
  // }
}
