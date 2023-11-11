import 'package:cuaca_apps/bloc/weather/weather_bloc.dart';
import 'package:cuaca_apps/model/city_suggestion_weather_model.dart';
import 'package:cuaca_apps/model/location_model.dart';
import 'package:cuaca_apps/model/weather_data_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

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

    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildTitle(),
                const SizedBox(height: 32),
                _buildSearchFormField(_cityController),
                const SizedBox(height: 32),
                _buildWeatherCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      'Cuaca Apps',
      style: GoogleFonts.openSans(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildSearchFormField(TextEditingController cityController) {
    return TypeAheadFormField<WeatherLocation>(
      textFieldConfiguration: TextFieldConfiguration(
        controller: cityController,
        decoration: InputDecoration(
          labelText: 'Enter city',
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          labelStyle: GoogleFonts.openSans(),
        ),
      ),
      suggestionsCallback: (pattern) async {
        if (pattern.isNotEmpty && pattern.length > 2) {
          final CitySuggestionWeather citySuggestionWeather = await context
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
        cityController.text = suggestion.name;
        context
            .read<WeatherBloc>()
            .add(WeatherFetchByCityEvent(suggestion.name));
      },
    );
  }

  Widget _buildWeatherCard() {
    return BlocBuilder<WeatherBloc, WeatherState>(
      builder: (context, state) {
        return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.blue.withOpacity(0.7),
                  Colors.purple.withOpacity(0.7),
                ],
              ),
            ),
            child: (state is WeatherLoaded)
                ? _buildWeatherCardLoaded(state.weatherData)
                : (state is WeatherError)
                    ? _buildWeatherCardError(state.message)
                    : _buildWeatherCardLoading());
      },
    );
  }

  Widget _buildWeatherCardLoaded(WeatherData weatherData) {
    String kelvinToCelsius(num kelvin) {
      return '${(kelvin.toDouble() - 273.15).toStringAsFixed(0)}°C';
    }

    return Column(
      children: [
        ListTile(
          title: Text(
            'City:',
            style: GoogleFonts.openSans(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            weatherData.name!,
            style: GoogleFonts.openSans(),
          ),
        ),
        ListTile(
          title: Text(
            'Temperature:',
            style: GoogleFonts.openSans(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            kelvinToCelsius(weatherData.main!.temp!),
            style: GoogleFonts.openSans(),
          ),
        ),
        ListTile(
          title: Text(
            'Description:',
            style: GoogleFonts.openSans(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            weatherData.weather!.first.description!.toUpperCase(),
            style: GoogleFonts.openSans(),
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherCardLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.withOpacity(0.7),
              Colors.purple.withOpacity(0.7),
            ],
          ),
        ),
        child: Column(
          children: [
            ListTile(
              title: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.withOpacity(0.7),
                ),
                height: 16,
              ),
              subtitle: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.withOpacity(0.7),
                ),
                height: 12,
              ),
            ),
            ListTile(
              title: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.withOpacity(0.7),
                ),
                height: 16,
              ),
              subtitle: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.withOpacity(0.7),
                ),
                height: 12,
              ),
            ),
            ListTile(
              title: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.withOpacity(0.7),
                ),
                height: 16,
              ),
              subtitle: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.withOpacity(0.7),
                ),
                height: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherCardError(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(message),
      ),
    );
  }
}
