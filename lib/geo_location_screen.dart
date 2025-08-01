import'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/weather_screen.dart';

class GeoLocationScreen extends StatefulWidget {
  const GeoLocationScreen({super.key});

  @override
  State<GeoLocationScreen> createState() => _GeoLocationScreenState();
}

class _GeoLocationScreenState extends State<GeoLocationScreen> {
  String _location = 'Unknown';
  late double latitude;
  late double longitude; 

  _getLocationAndCity() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Fluttertoast.showToast(
        msg: "Location services are disabled",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
    }

    // Check and request permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
      Fluttertoast.showToast(
        msg: "Location permission denied",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
      }
    }

    if (permission == LocationPermission.deniedForever) {
            Fluttertoast.showToast(
        msg: "Location permission permanently denied",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
    }

    // Get current position
    final Position position = await Geolocator.getCurrentPosition();

    // Reverse geocoding
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    if (placemarks.isNotEmpty) {
      final Placemark place = placemarks[0];
      setState(() {
        _location =
            '${place.locality}, ${place.administrativeArea}, ${place.country}';
        latitude = position.latitude;
        longitude = position.longitude;
      });
    } else {
      setState(() {
        _location = 'City not found.';
      });
    }
  }

@override
  void initState() {
    super.initState();
    _getLocationAndCity();
  }



@override
Widget build(BuildContext context) {
  return Scaffold(
    body: SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image on top (e.g., 40% of screen height)
          Image.asset(
            'assets/location.png',
            fit: BoxFit.contain,
          ),
         const SizedBox(height: 30),
          // Address text
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Image.asset(
            'assets/location_icon.png',
            width: 50,
            height:50,
          ),
          const SizedBox(width: 12),
              Expanded(
                child: _location=="Unknown"?Center(
          child: SizedBox(
            width: 30,
            height: 30,
            child: CircularProgressIndicator(strokeWidth: 3),
          ),
        ): Text(
                  _location,
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                 ),
              ),
            ],
          ),

          // Button at the bottom
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent.shade200, // or try blue.shade300
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WeatherScreen(
                      latitude: latitude,
                      longitude: longitude,
                    ),
                  ),
                );
                          },
            child: Text("Check Weather",
            style: TextStyle(fontFamily: 'Nunito',
             fontSize: 16,
             ),
             ),
          )
          ),
        ],
      ),
    ),
  );
}
}