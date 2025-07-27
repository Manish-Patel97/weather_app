import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:weather_app/additional_forecast_item.dart';
import 'package:weather_app/hourly_forecast_item.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
late Future<Map<String, dynamic>> weather;
late double temperature;
String cityName = "delhi";
String appID ="b5b39bb42dd670cfa5ace41df51b6892";


//because the retun type data has map key as string and value as dynamic
  Future<Map<String, dynamic>> getWeatherData() async {

    try{
  final response = await http.get(
      Uri.parse("https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$appID"),
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
      appBar:AppBar(
      title: Text("Weather App",
      style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
          ),
      centerTitle: true,
      actions: [
        IconButton(onPressed: (){
          setState(() {
            weather = getWeatherData();
          });
        },
         icon: Icon(Icons.refresh)),
      ],
    
      ),
      body: FutureBuilder(
        future: getWeatherData(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(
              child: CircularProgressIndicator()
              );
            }

          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString(),
              style: TextStyle(
              fontSize: 20,
              ),
              textAlign: TextAlign.center,
              ),
            );
          }

          final data = snapshot.data!;
          final currentweather = data['list'][0];
          final currenttempreature = currentweather['main']['temp'];
          final currenthumidity = currentweather['main']['humidity'];
          final currentpressure = currentweather['main']['pressure'];
          final currentwindspeed = currentweather['wind']['speed'];
          final weathertype = currentweather['weather'][0]['main'];
          

          return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      cityName,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.location_on,
                     size: 30,
                     ),
                    
                  ],
                  ),
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    //clipRRect is used to round the corners of the card
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      // Using BackdropFilter to create a blurred background effect
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                               Text(
                                      "$currenttempreature k",
                                      style: TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                    Icon(
            
                                      weathertype == "Rain"
                                          ? Icons.beach_access
                                          : weathertype == "Clouds"
                                              ? Icons.cloud
                                              : weathertype == "Clear"
                                                  ? Icons.wb_sunny
                                                  : Icons.help_outline,
                                      size: 64,
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      '$weathertype',
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            
              const SizedBox(height: 20,),
             Text("Hourly Forecast", 
             textAlign: TextAlign.left,
             style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
             ),
            
              const SizedBox(height: 16),
              
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    itemCount: 39,
                    scrollDirection:Axis.horizontal,
                    itemBuilder: (context, index) {
        
                   final hourlyData = data['list'][index + 1];
                   final dateTime = DateTime.parse(hourlyData['dt_txt']);
                  final time = '${dateTime.hour.toString().padLeft(2, '0')}:00';
                   final temperature = hourlyData['main']['temp'].toString(); 
                   final hourlyweathertype = hourlyData['weather'][0]['main'];
                    return HourlyForecastItem(
                      time: time,
                      temperature: temperature.toString(), 
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
            
              Text("Additional Information", 
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            
              const SizedBox(height: 16,),
              
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
          ));
        },
      ),
    );
  }
}