import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:prueba/widgets/loading_widget.dart';
import 'package:provider/provider.dart';
import 'package:prueba/services/weather_service.dart';
import '../models/weather_model.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // Weather animations
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) {
      return 'assets/sunny.json';
    }

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloud.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rain.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherProvider>(
        builder: (context, weatherProvider, child) {
      if (weatherProvider.lastFetchedWheater == null) {
        weatherProvider.fetchWeatherForCurrentCity();
      }

      return Scaffold(
        body: Center(
            child: weatherProvider.lastFetchedWheater == null
                ? LoadingWidget(title: "Getting weather data ...")
                : getLoadedWiget(weatherProvider.lastFetchedWheater!)),
      );
    });
  }

  Widget getLoadedWiget(Weather weather) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "${weather.temperature.round()}°C",
          style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold),
        ),
        Text(
          weather.cityName,
          style: const TextStyle(fontSize: 30),
        ),
        const SizedBox(height: 20),
        Lottie.asset(getWeatherAnimation(weather.mainCondition)),
        const SizedBox(height: 20),
      ],
    );
  }
}