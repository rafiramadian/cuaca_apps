import 'package:cuaca_apps/api/weather_api.dart';
import 'package:cuaca_apps/model/location_model.dart';
import 'package:cuaca_apps/model/weather_data_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherApi weatherApi;
  WeatherBloc({required this.weatherApi}) : super(WeatherInitial()) {
    Future<void> fetchWeatherData(event, emit) async {
      try {
        emit(WeatherLoading());
        // Get User's Location
        final Location location = await Location.getUserLocation();

        // Get Weather Data from API
        final WeatherData weatherData =
            await weatherApi.getWeatherData(location: location);
        emit(WeatherLoaded(weatherData));
      } catch (e) {
        emit(WeatherError(e.toString()));
      }
    }

    on<WeatherFetchEvent>(fetchWeatherData);
  }
}
