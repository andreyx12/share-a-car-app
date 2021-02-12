
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:share_a_car/utils/constants.dart';

class MapUtils {

  static final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

  static Future<void> setCurrentCameraPosition(Function callback) async {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
          callback.call(position);
    }).catchError((e) {
      print(e);
    });
  }

  static Future<Map<String, Polyline>> getPolylines(LatLng source, LatLng target) async {
    
    List<LatLng> polylineCoordinates = [];

    PolylineResult result = await new PolylinePoints().getRouteBetweenCoordinates(
      Constants.GOOGLE_API_KEY,
      PointLatLng(source.latitude, source.longitude),
      PointLatLng(target.latitude, target.longitude),
      travelMode: TravelMode.walking,
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    Polyline polyline = Polyline(
      polylineId: PolylineId('polyline'),
      color: Colors.green,
      points: polylineCoordinates,
      width: 5,
    );

    final Map<String, Polyline> currentPolylines = new Map<String, Polyline>();
    currentPolylines['ruta'] = polyline;

    return currentPolylines;
  }

  static List<Marker> createDynamicMarkers(Function markerTappedCallback) {

      List<Marker> markersList = List<Marker>();

      List<LatLng> list = [];
      for (var i = 0; i < 500; i++) {

      final random = Random();
      double randomLat = 9 + random.nextDouble();
      double randomLng = -84 + random.nextDouble();

        list.add(LatLng(randomLat,randomLng));
      }

      // List<LatLng> list = [
      //   LatLng(9.893309688992582, -84.02695186436176),
      //   LatLng(9.884501387407344, -84.02613312005997),
      // ];

      for (var i = 0; i < list.length; i++) {

        String markerId = new List.generate(10, (_) => new Random().nextInt(100)).toString();

        Marker selectedMarker = Marker(
          markerId: MarkerId(markerId.toString()),
          position: list[i],
          icon: BitmapDescriptor.defaultMarker,
          // infoWindow: InfoWindow(
          //   title: "Hola"
          // ),
          consumeTapEvents: true,
          onTap: () {
            markerTappedCallback(markerId);
          }
        );

        markersList.add(selectedMarker);
      }
      return markersList;
  }
}