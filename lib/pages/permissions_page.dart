import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:prueba/pages/weather_pages.dart';
import 'package:prueba/services/location_provider.dart';
import 'package:prueba/widgets/loading_widget.dart';
import 'package:prueba/widgets/sub_title_text.dart';
import 'package:prueba/widgets/title_text.dart';
import 'package:provider/provider.dart';

class PermissionsPage extends StatelessWidget {
  PermissionsPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Consumer<LocationProvider>(
      builder: (context, locationProvider, child) {
        var permission = locationProvider.locationPermission;

        if (permission == null) {
          // Use WidgetsBinding.instance.addPostFrameCallback to request permission after the widget is built
          WidgetsBinding.instance.addPostFrameCallback((_) {
            locationProvider.checkPermission();
          });

          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  LoadingWidget(title: 'Fetching permissions ...'),
                ],
              ),
            ),
          );
        } else if (permission == LocationPermission.deniedForever) {
          return Scaffold(
            body: Column( 
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.do_not_disturb_on,
                  color: Colors.red,
                  size: 128.0,
                ),
                48.0.heightBox,
                TitleText(text: 'Permission denied'),
                SubTitleText(
                        text:
                            'Permissions have been denied on this device. You need to manually active them from the settings on your phone and then restart the application.')
                    .paddingAll(24.0),
              ],
            ),
          );
        } else if (permission == LocationPermission.denied) {
          // Use WidgetsBinding.instance.addPostFrameCallback to request permission after the widget is built
          WidgetsBinding.instance.addPostFrameCallback((_) {
            locationProvider.requestPermission();
          });

          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  LoadingWidget(title: 'Waiting for user ...'),
                ],
              ),
            ),
          );
        } else {
          // Navigate to the WeatherPage when permission is granted
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const WeatherPage()),
            );
          });

          return Scaffold(
            body: Center(child: Text('Loading...')),
          );
        }
      },
    );
  }
}