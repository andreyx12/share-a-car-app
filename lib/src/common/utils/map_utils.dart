
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:share_a_car/src/models/home/marker_info.dart';
import 'package:share_a_car/src/common/utils/constants.dart';

class MapUtils {

  static final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

  static Future<double> getDistanceBetween(LatLng start, LatLng end) async {
    return await geolocator.distanceBetween(start.latitude, start.longitude, end.latitude, end.longitude);
  }

  static Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec =
        await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png)).buffer.asUint8List();
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
    currentPolylines['route'] = polyline;

    return currentPolylines;
  }

  static Future<List<MarkerInfo>> createDynamicMarkers(String imagePath, int imageSize, Function markerTappedCallback) async {

      List<MarkerInfo> markersList = [];

      List<LatLng> list = [];

      for (var i = 0; i < 100; i++) {

        final random = Random();
        double randomLat = 9 + random.nextDouble();
        double randomLng = -84 + random.nextDouble();

        list.add(LatLng(randomLat,randomLng));
      }

      final Uint8List markerIcon = await getBytesFromAsset(imagePath, imageSize);

      for (var i = 0; i < list.length; i++) {

        String markerId = new List.generate(10, (_) => new Random().nextInt(100)).toString();

        Marker selectedMarker = Marker(
          markerId: MarkerId(markerId.toString()),
          position: list[i],
          icon: BitmapDescriptor.fromBytes(markerIcon),
          consumeTapEvents: true,
          onTap: () {
            markerTappedCallback(markerId);
          }
        );
        final car = getRandomCar();
        markersList.add(MarkerInfo(int.parse(car["id"]), new Random().nextInt(999999).toString(), markerId, car["brand"], car["color"], car["model"], selectedMarker));
      }
      return markersList;
  }

  static Map<String, String> getRandomCar() {

    var carBrands = [{"id": "1", "brand": "Hyundai", "model": "Kona", "color": "Rojo"},{"id": "2", "brand": "Nissan", "model": "Leaf", "color": "Blanco"},{"id": "3", "brand": "BMW", "model": "i3", "color": "Negro"},{"id": "4", "brand": "Mazda", "model": "MX-30", "color": "Azul"}];

    return carBrands.elementAt(new Random().nextInt(carBrands.length - 1));
  }
}