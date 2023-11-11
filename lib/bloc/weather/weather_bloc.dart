import 'package:cuaca_apps/api/weather_api.dart';
import 'package:cuaca_apps/model/city_suggestion_weather_model.dart';
import 'package:cuaca_apps/model/location_model.dart';
import 'package:cuaca_apps/model/weather_data_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherApi weatherApi;
  WeatherBloc({required this.weatherApi}) : super(WeatherInitial()) {
    // Fetch weather data by User's location
    Future<void> fetchWeatherData(WeatherFetchEvent event, emit) async {
      try {
        emit(WeatherLoading());

        // Get User's Location
        final Location location = await Location.getUserLocation();

        // Get Weather Data from API
        final WeatherData weatherData =
            await weatherApi.getWeatherDataByLocation(location: location);

        emit(WeatherLoaded(weatherData));
      } catch (e) {
        emit(WeatherError(e.toString()));
      }
    }

    // Fetch weather data by city selected
    Future<void> fetchWeatherDataByCity(
        WeatherFetchByCityEvent event, emit) async {
      try {
        emit(WeatherLoading());

        // Get Weather Data from API
        final WeatherData weatherData = await weatherApi.getWeatherDataByCity(
            city: event.city.toLowerCase());

        emit(WeatherLoaded(weatherData));
      } catch (e) {
        emit(WeatherError(e.toString()));
      }
    }

    on<WeatherFetchEvent>(fetchWeatherData);
    on<WeatherFetchByCityEvent>(fetchWeatherDataByCity);
  }

  // Additional function for TypeaheadFormField needs
  // Fetch city suggestion by User's search input
  Future<CitySuggestionWeather> fetchCitySuggestionWeatherByInput(
      {required String input}) async {
    try {
      // Get city suggestion data from API
      final CitySuggestionWeather citySuggestionWeather =
          await weatherApi.getCitySuggestion(input: input);

      return citySuggestionWeather;
    } catch (e) {
      rethrow;
    }
  }
}
