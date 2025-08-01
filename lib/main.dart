import 'package:flutter/material.dart';
import 'package:weather_app/geo_location_screen.dart';

void main(){
  runApp(Myapp());
}

class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
           
      themeMode: ThemeMode.system,

      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorSchemeSeed: Colors.blue,
      ),
      title: "Weather App",
      home: GeoLocationScreen(),

    );
  }
}