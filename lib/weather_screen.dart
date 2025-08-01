import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:weather_app/additional_forecast_item.dart';
import 'package:weather_app/hourly_forecast_item.dart';

class WeatherScreen extends StatefulWidget {
  final double latitude;
  final double longitude;

  const WeatherScreen({
     required this.latitude,
     required this.longitude,
    super.key, });

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {

late Future<Map<String, dynamic>> weather;
late double temperature;
String appID ="b5b39bb42dd670cfa5ace41df51b6892";


//because the retun type data has map key as string and value as dynamic
  Future<Map<String, dynamic>> getWeatherData() async {

    try{
  final response = await http.get(
      Uri.parse(  
        'https://api.openweathermap.org/data/2.5/forecast?lat=${widget.latitude}&lon=${widget.longitude}&appid=$appID&units=metric',
      ),
      ); 

final data = jsonDecode(response.body);
if (response.statusCode != 200) {
    throw Exception("Failed to load weather data");
  } 
 return data;
} catch(e){
  throw "Couldn't fetch weather data. Please check your internet or try again later.";

}
  }  

  @override
  void initState() {
    super.initState();
    weather = getWeatherData();
  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body:Stack(
  fit: StackFit.expand,
  children: [
    // 🔹 Background image
    Image.asset(
      'assets/background.jpg', // your background image path
      fit: BoxFit.cover,
    ),

    // 🔹 Overlay content (weather data)
    SafeArea(
      child: FutureBuilder(
        future: weather,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
      
          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
                style: const TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            );
          }
      
          final data = snapshot.data!;
          final currentweather = data['list'][0];
          final cityName = data['city']['name'];
          final country = data['city']['country'];
          final currenttempreature = currentweather['main']['temp'];
          final currenthumidity = currentweather['main']['humidity'];
          final currentpressure = currentweather['main']['pressure'];
          final currentwindspeed = currentweather['wind']['speed'];
          final weathertype = currentweather['weather'][0]['main'];
      
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
          
                // 🔹 City Info
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 30, color: Colors.black),
                        Text(
                          "$cityName, $country",
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w300,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: (){
                         setState(() {
                          weather = getWeatherData();
                        });  
                    }, 
                    icon: const Icon(Icons.replay_outlined,
                      size: 30,
                      color: Colors.black, 
                    ),
                    )
                  ],
                ),
          
                const SizedBox(height: 16),
          
                // 🔹 Weather Card with blur and translucency
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                              "$currenttempreature °C",
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Icon(
                              weathertype == "Rain"
                                  ? Icons.beach_access
                                  : weathertype == "Clouds"
                                      ? Icons.cloud
                                      : weathertype == "Clear"
                                          ? Icons.wb_sunny
                                          : Icons.help_outline,
                              size: 64,
                              color: Colors.black,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              '$weathertype',
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
          
                const SizedBox(height: 20),
          
                const Text("Hourly Forecast",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
                const SizedBox(height: 16),
          
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 39,
                    itemBuilder: (context, index) {
                      final hourlyData = data['list'][index + 1];
                      final dateTime = DateTime.parse(hourlyData['dt_txt']);
                      final time =
                          '${dateTime.hour.toString().padLeft(2, '0')}:00';
                      final temperature =
                          hourlyData['main']['temp'].toString();
                      final hourlyweathertype =
                          hourlyData['weather'][0]['main'];
          
                      return HourlyForecastItem(
                        time: time,
                        temperature: temperature,
                        icon: hourlyweathertype == "Rain"
                            ? Icons.beach_access
                            : hourlyweathertype == "Clouds"
                                ? Icons.cloud
                                : hourlyweathertype == "Clear"
                                    ? Icons.wb_sunny
                                    : Icons.help_outline,
                      );
                    },
                  ),
                ),
          
                const SizedBox(height: 20),
                const Text("Additional Information",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
                const SizedBox(height: 16),
          
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AdditionalForecastItem(
                      icon: Icons.water_drop,
                      label: 'Humidity',
                      value: '$currenthumidity',
                    ),
                    AdditionalForecastItem(
                      icon: Icons.air,
                      label: 'Wind Speed',
                      value: '$currentwindspeed',
                    ),
                    AdditionalForecastItem(
                      icon: Icons.beach_access,
                      label: 'Pressure',
                      value: '$currentpressure',
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    ),
  ],
),

    );
  }
}