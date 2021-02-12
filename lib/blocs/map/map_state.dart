part of 'map_bloc.dart';


enum ModalStatus { 
   init,
   hide,
   routeInProgress,
   routeFinished
}

@immutable
class MapState {
  
  final bool mapReady;

  final bool routeInProgress;

  final bool loadingRouteInMap;

  final ModalStatus modalStatus;
  
  final LatLng targetMarkerPosition;

  final LatLng position;

  final List<Marker> markers;

  final Map<String, Polyline> polylines;

  MapState({
    this.mapReady = false,
    this.routeInProgress = false,
    this.targetMarkerPosition,
    this.loadingRouteInMap = false,
    this.modalStatus = ModalStatus.init,
    this.position,
    List<Marker> markers,
    Map<String, Polyline> polylines
  }): this.polylines = polylines ?? new Map(), this.markers = markers ?? new List<Marker>();


  MapState copyWith({
    bool mapReady,
    bool routeInProgress,
    LatLng targetMarkerPosition,
    bool loadingRouteInMap,
    ModalStatus modalStatus,
    LatLng position,
    Map<String, Polyline> polylines,
    List<Marker> markers
  }) => MapState(
    mapReady: mapReady ?? this.mapReady,
    loadingRouteInMap: loadingRouteInMap ?? this.loadingRouteInMap,
    modalStatus: modalStatus ?? this.modalStatus,
    polylines: polylines ?? this.polylines,
    markers: markers ?? this.markers,
    targetMarkerPosition : targetMarkerPosition ?? this.targetMarkerPosition,
    position : position ?? this.position,
    routeInProgress  : routeInProgress ?? this.routeInProgress,
  );
}