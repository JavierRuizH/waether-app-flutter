import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import '../models/weather_model.dart';

class WeatherProvider extends ChangeNotifier {
  static const BASE_URL = "https://api.openweathermap.org/data/2.5/weather";
  final String apiKey;

  Weather? _lastFetchedWeather;
  Weather? get lastFetchedWheater => _lastFetchedWeather;

  WeatherProvider({required this.apiKey});

  Future fetchWeatherForCurrentCity() async {
    var cityName = await getCurrentCity();

    final url = '$BASE_URL?q=$cityName&appid=$apiKey&units=metric';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      _lastFetchedWeather = Weather.fromJson(jsonDecode(response.body));
      notifyListeners();
    } else {
      throw Exception('Error fetching weather data');
    }
  }

  Future<String> getCurrentCity() async {
    try {
      // Get permission from user
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      // Fetch the current location
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      // Convert the location into a list of placemark objects
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      // Extract the city name from the first placemark
      String? city = placemarks[0].locality;

      return city ?? "";
    } catch (e) {
      throw Exception('Error fetching city');
    }
  }
}