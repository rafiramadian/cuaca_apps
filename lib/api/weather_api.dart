import 'package:cuaca_apps/model/location_model.dart';
import 'package:cuaca_apps/model/weather_data_model.dart';
import 'package:cuaca_apps/services/http_service.dart';
import 'package:flutter/material.dart';

class WeatherApi {
  final HttpService httpService;
  WeatherApi({required this.httpService});

  final String apiKey = const String.fromEnvironment('API_KEY');

  Future<WeatherData> getWeatherData({required Location location}) async {
    try {
      Map<String, dynamic> response = await HttpService.get(
          '?lat=${location.latitude}&lon=${location.longitude}&appid=$apiKey');

      debugPrint(
          'getWeatherData | data: ${response.toString()} | status: Success');

      final WeatherData weatherData = WeatherData.fromJson(response);

      return weatherData;
    } catch (e) {
      rethrow;
    }
  }
}
