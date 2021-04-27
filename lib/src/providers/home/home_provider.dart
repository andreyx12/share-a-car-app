import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:share_a_car/src/common/utils/constants.dart';
import 'package:share_a_car/src/models/home/trip.dart';

class HomeProvider {

  String usernameBasicAuth = 'shareacar';
  String passwordBasicAuth = 'E6XZ_kbU%9d%Z2@V';

  static HomeProvider _instance;


  Future<Trip> postTripStatus(Trip trip) async {
    
      final url = Uri.http(Constants.BASE_URL, 'admin/trip');

      String basicAuth = 'Basic ' + base64Encode(utf8.encode('$usernameBasicAuth:$passwordBasicAuth'));

      final resp = await http.post(
        url,
        headers: {
          'authorization': basicAuth,
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<dynamic, dynamic>{
          'vehicle_id': trip.vehicleId,
          'user_id': trip.userId,
          'trip_status': trip.tripStatus,
          'trip_notes': trip.tripNotes
        })
      );

      if (resp.statusCode != 200) {
        throw Exception();
      }

      final decodedData = json.decode(resp.body);

      final tripResult = new Trip.fromJsonMap(decodedData);

      return tripResult;
  }

  Future<Trip> putTripStatus(Trip trip) async {
    
      final url = Uri.http(Constants.BASE_URL, 'admin/trip/${trip.tripId}');

      String basicAuth = 'Basic ' + base64Encode(utf8.encode('$usernameBasicAuth:$passwordBasicAuth'));

       final resp = await http.put(
        url,
        headers: {
          'authorization': basicAuth,
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<dynamic, dynamic>{
          'vehicle_id': trip.vehicleId,
          'user_id': trip.userId,
          'trip_status': trip.tripStatus,
          'trip_notes': trip.tripNotes,
        })
      );

      if (resp.statusCode != 200) {
        throw Exception();
      }

      final decodedData = json.decode(resp.body);

      final tripResult = new Trip.fromJsonMap(decodedData);

      return tripResult;
  }
  

  HomeProvider._internal() {
    _instance = this;
  }

  factory HomeProvider() => _instance ?? HomeProvider._internal();
}