/* import 'package:flutter/material.dart';
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
} */

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
  final TextEditingController _cityController = TextEditingController(); // Controlador para el campo de texto
  bool _isLoading = false; // Para manejar el estado de carga

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

  // Función para obtener el clima de la ciudad ingresada
  Future<void> _fetchWeatherForCity(BuildContext context) async {
    final weatherProvider = Provider.of<WeatherProvider>(context, listen: false);
    setState(() {
      _isLoading = true; // Activar el estado de carga
    });

    try {
      await weatherProvider.fetchWeatherForCity(_cityController.text.trim());
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() {
        _isLoading = false; // Desactivar el estado de carga
      });
    }
  }

  @override
  void dispose() {
    _cityController.dispose(); // Liberar el controlador
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Buscar Clima"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Campo de texto para ingresar la ciudad
            TextField(
              controller: _cityController,
              decoration: InputDecoration(
                labelText: "Ingresa una ciudad",
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => _fetchWeatherForCity(context),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Mostrar el clima o el estado de carga
            Consumer<WeatherProvider>(
              builder: (context, weatherProvider, child) {
                if (_isLoading) {
                  return LoadingWidget(title: "Obteniendo datos del clima...");
                }

                if (weatherProvider.lastFetchedWheater == null) {
                  return const Expanded(
                    child: Center(
                      child: Text("Ingresa una ciudad para ver el clima"),
                    ),
                  );
                }

                return getLoadedWiget(weatherProvider.lastFetchedWheater!);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget getLoadedWiget(Weather weather) {
    return Expanded(
      child: Column(
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
      ),
    );
  }
}
