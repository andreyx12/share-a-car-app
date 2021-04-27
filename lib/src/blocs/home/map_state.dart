part of 'map_bloc.dart';


enum ModalStatus { 
   init,
   licenseNotRegistered,
   selectedMarker,
   reservationProcess,
   routeInProgresss,
   dropOffVehicle,
   finishingTrip,
   routeFinished
}

@immutable
class MapState {

  final String username;
  
  final bool mapReady;

  final bool routeInProgress;

  final bool showAppBarLoading;

  final bool loadingRouteInMap;

  final bool enableDeliveryButton;

  final String driverLicenseStatus;

  final Trip trip;

  final double panelHeight;

  final ModalStatus modalStatus;
  
  final MarkerInfo targetMarker;

  final MarkerInfo deliveryTargetMarker;

  final LatLng currentPosition;

  final List<MarkerInfo> markers;
  
  final List<MarkerInfo> deliveryMarkers;

  final Map<String, Polyline> polylines;

  MapState({
    this.username,
    this.mapReady = false,
    this.routeInProgress = false,
    this.enableDeliveryButton = false,
    this.showAppBarLoading = false,
    this.targetMarker,
    this.deliveryTargetMarker,
    this.loadingRouteInMap = false,
    this.driverLicenseStatus,
    this.panelHeight = 120,
    this.modalStatus = ModalStatus.init,
    this.currentPosition,
    this.trip,
    List<MarkerInfo> markers,
    List<MarkerInfo> deliveryMarkers,
    Map<String, Polyline> polylines
  }): this.polylines = polylines ?? new Map(), this.markers = markers ?? [], this.deliveryMarkers = markers ?? [];


  MapState copyWith({
    String username,
    bool mapReady,
    bool routeInProgress,
    bool enableDeliveryButton,
    bool showAppBarLoading,
    MarkerInfo targetMarker,
    MarkerInfo deliveryTargetMarker,
    bool loadingRouteInMap,
    double panelHeight,
    Trip trip,
    String driverLicenseStatus,
    ModalStatus modalStatus,
    LatLng currentPosition,
    Map<String, Polyline> polylines,
    List<MarkerInfo> markers,
    List<MarkerInfo> deliveryMarkers,
  }) => MapState(
    username: username ?? this.username,
    mapReady: mapReady ?? this.mapReady,
    showAppBarLoading: showAppBarLoading ?? this.showAppBarLoading,
    loadingRouteInMap: loadingRouteInMap ?? this.loadingRouteInMap,
    modalStatus: modalStatus ?? this.modalStatus,
    enableDeliveryButton: enableDeliveryButton ?? this.enableDeliveryButton,
    polylines: polylines ?? this.polylines,
    driverLicenseStatus: driverLicenseStatus ?? this.driverLicenseStatus,
    panelHeight: panelHeight ?? this.panelHeight,
    markers: markers ?? this.markers,
    deliveryMarkers: deliveryMarkers ?? this.deliveryMarkers,
    targetMarker : targetMarker ?? this.targetMarker,
    deliveryTargetMarker: deliveryTargetMarker ?? this.deliveryTargetMarker,
    currentPosition : currentPosition ?? this.currentPosition,
    routeInProgress  : routeInProgress ?? this.routeInProgress,
    trip: trip ?? this.trip
  );

  MapState initialState() => new MapState();
}