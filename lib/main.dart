import 'package:flutter/material.dart';
import 'package:prueba/pages/permissions_page.dart';
import 'package:prueba/services/location_provider.dart';
import 'package:prueba/services/weather_service.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocationProvider()),
        ChangeNotifierProvider(create: (_) => WeatherProvider(apiKey: '36b6a5271ad392915f89f66d73b89cd4')),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PermissionsPage(),
    );
  }
}