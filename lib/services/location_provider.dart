import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationProvider with ChangeNotifier {
  LocationPermission? _locationPermission;
  LocationPermission? get locationPermission => _locationPermission;


  Future checkPermission() async {
    _locationPermission = await Geolocator.checkPermission();
    notifyListeners();
  }

  Future requestPermission() async {
    await Geolocator.requestPermission();
    await checkPermission();
  }
}