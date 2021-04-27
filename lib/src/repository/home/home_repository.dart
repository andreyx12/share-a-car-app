import 'package:share_a_car/src/models/home/trip.dart';
import 'package:share_a_car/src/providers/home/home_provider.dart';

class HomeRepository {

  static Future<Trip> postTripStatus(Trip trip){
    return HomeProvider().postTripStatus(trip);
  }

  static Future<Trip> putTripStatus(Trip trip){
    return HomeProvider().putTripStatus(trip);
  }
}