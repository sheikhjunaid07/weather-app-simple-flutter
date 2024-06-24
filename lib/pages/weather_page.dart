import "package:flutter/material.dart";
import "package:lottie/lottie.dart";
import "package:weather_app/model/weather_model.dart";
import "package:weather_app/service/weather_service.dart";

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  //api key
  final _weatherService = WeatherService('336b6afe1f28bde57a61f16edec9b115');
  Weather? _weather;

  //fetch weather
  _fetchWeather() async {
    //get the current city
    String cityName = await _weatherService.getCurrentCity();

    //get weather for city
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }

  //get weather animation
  String getWeatherAnimation(String mainCondition) {
    if (mainCondition == null) return 'assets/sun.json';

    switch (mainCondition.toLowerCase()) {
      case "cloud":
      case "mist":
      case "smoke":
      case "haze":
      case "dust":
      case "fog":
        return 'assets/cloud.json';
      case "rain":
      case "drizzle":
      case "shower rain":
        return 'assets/rain.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      case 'clear':
        return 'assets/sun.json';
      default:
        return 'assets/sun.json';
    }
  }

  //weather animations
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //fetch weather on startup
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text("Weather Page", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //city name
            Text(
              _weather?.cityName ?? "Load city name",
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            //animation
            Lottie.asset(getWeatherAnimation(_weather!.mainCondition)),
            //temperature
            Text(
              "${_weather?.temperature.round().toString()} °C",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),

            //weather condition
            Text(
              _weather?.mainCondition ?? "",
              style:const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
