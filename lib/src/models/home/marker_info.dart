
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerInfo {

    int vehicleId;
    String _markerId;
    String _carName;
    String _color;
    String _model;
    String _licensePlate;
    double _distance;
    DateTime _rentalDate;
    Marker _marker;

    MarkerInfo(this.vehicleId, this._licensePlate, this._markerId, this._carName, this._color, this._model, this._marker);

    int get getVehicleId => this.vehicleId;

    set setVehicleId(int vehicleId) => this.vehicleId = vehicleId;

    get licensePlate => this._licensePlate;

    set licensePlate( value) => this._licensePlate = value;

    String get markerId => _markerId;

    set markerId(String value) => _markerId = value;

    String get carName => _carName;

    set carName(String value) => _carName = value;

    String get color => _color;

    set color(String value) => _color = value;

    String get model => _model;

    set model(String value) => _model = value;

    double get distance => _distance;

    set distance(double value) => _distance = value;

    Marker get marker => _marker;

    set marker(Marker value) => _marker = value;

    DateTime get rentalDate => _rentalDate;

    set rentalDate(DateTime value) => _rentalDate = value;
}