import 'package:cuaca_apps/bloc/weather/weather_bloc.dart';
import 'package:cuaca_apps/model/city_suggestion_weather_model.dart';
import 'package:cuaca_apps/model/location_model.dart';
import 'package:cuaca_apps/model/weather_data_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class CuacaApps extends StatefulWidget {
  const CuacaApps({Key? key}) : super(key: key);

  @override
  State<CuacaApps> createState() => _CuacaAppsState();
}

class _CuacaAppsState extends State<CuacaApps> {
  @override
  void initState() {
    getUserLocationAndWeather();
    super.initState();
  }

  Future<void> getUserLocationAndWeather() async {
    await Location.checkLocationPermission();
    context.read<WeatherBloc>().add(WeatherFetchEvent());
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final TextEditingController _cityController = TextEditingController();
    bool isFirstClick = true;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cuaca Apps'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TypeAheadFormField<WeatherLocation>(
                textFieldConfiguration: TextFieldConfiguration(
                  controller: _cityController,
                  decoration: InputDecoration(
                    labelText: 'Enter city',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                suggestionsCallback: (pattern) async {
                  if (pattern.isNotEmpty && pattern.length > 2) {
                    final CitySuggestionWeather citySuggestionWeather =
                        await context
                            .read<WeatherBloc>()
                            .fetchCitySuggestionWeatherByInput(input: pattern);

                    return citySuggestionWeather.list;
                  }

                  return [];
                },
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    title: Text(
                      suggestion.name,
                      style: const TextStyle(color: Colors.black),
                    ),
                  );
                },
                onSuggestionSelected: (suggestion) {
                  _cityController.text = suggestion.name;
                  context
                      .read<WeatherBloc>()
                      .add(WeatherFetchByCityEvent(suggestion.name));
                },
              ),
              const SizedBox(height: 32),
              BlocBuilder<WeatherBloc, WeatherState>(
                builder: (context, state) {
                  return Card(
                      color: Colors.white.withOpacity(0.7),
                      child: (state is WeatherLoaded)
                          ? _buildWeatherCardLoaded(state.weatherData)
                          : (state is WeatherError)
                              ? _buildWeatherCardError(state.message)
                              : _buildWeatherCardLoading());
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherCardLoaded(WeatherData weatherData) {
    String kelvinToCelsius(double kelvin) {
      return '${(kelvin - 273.15).toStringAsFixed(0)}°C';
    }

    return Column(
      children: [
        ListTile(
          title: const Text(
            'City:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(weatherData.name!),
        ),
        ListTile(
          title: const Text(
            'Temperature:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            kelvinToCelsius(weatherData.main!.temp!),
          ),
        ),
        ListTile(
          title: const Text(
            'Description:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(weatherData.weather!.first.description!.toUpperCase()),
        ),
        const SizedBox(height: 16),
        Image.network(
          'https://openweathermap.org/img/w/${weatherData.weather!.first.icon!}.png',
          width: 75,
          height: 75,
          loadingBuilder: (
            BuildContext context,
            Widget child,
            ImageChunkEvent? loadingProgress,
          ) {
            if (loadingProgress == null) return child;

            return const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildWeatherCardLoading() {
    return const Center(
        child: Padding(
      padding: EdgeInsets.all(20.0),
      child: CircularProgressIndicator(),
    ));
  }

  Widget _buildWeatherCardError(String message) {
    return Center(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(message),
    ));
  }
}
