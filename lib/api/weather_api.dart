import 'package:cuaca_apps/model/city_suggestion_weather_model.dart';
import 'package:cuaca_apps/model/location_model.dart';
import 'package:cuaca_apps/model/weather_data_model.dart';
import 'package:cuaca_apps/service/http_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WeatherApi {
  final HttpService httpService;
  WeatherApi({required this.httpService});

  final String apiKey = dotenv.get('API_KEY');

  Future<WeatherData> getWeatherDataByLocation(
      {required Location location}) async {
    try {
      Map<String, dynamic> response = await HttpService.get(
          'weather?lat=${location.latitude}&lon=${location.longitude}&appid=$apiKey');

      debugPrint(
          'getWeatherDataByLocation | data: ${response.toString()} | status: Success');

      final WeatherData weatherData = WeatherData.fromJson(response);

      return weatherData;
    } catch (e) {
      rethrow;
    }
  }

  Future<CitySuggestionWeather> getCitySuggestion(
      {required String input}) async {
    try {
      Map<String, dynamic> response =
          await HttpService.get('find?q=$input&appid=$apiKey');

      debugPrint(
          'getSuggestionCity | data: ${response.toString()} | status: Success');

      final CitySuggestionWeather citySuggestionWeather =
          CitySuggestionWeather.fromJson(response);

      return citySuggestionWeather;
    } catch (e) {
      rethrow;
    }
  }

  Future<WeatherData> getWeatherDataByCity({required String city}) async {
    try {
      Map<String, dynamic> response =
          await HttpService.get('weather?q=$city&appid=$apiKey');

      debugPrint(
          'getWeatherDataByCity | data: ${response.toString()} | status: Success');

      final WeatherData weatherData = WeatherData.fromJson(response);

      return weatherData;
    } catch (e) {
      rethrow;
    }
  }
}
