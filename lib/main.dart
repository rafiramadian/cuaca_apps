import 'package:cuaca_apps/blocs/weather/weather_bloc.dart';
import 'package:cuaca_apps/model/location_model.dart';
import 'package:cuaca_apps/utils/dependency_injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

void main() {
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => GetIt.instance.get<WeatherBloc>())
      ],
      child: MaterialApp(
        title: 'Cuaca Apps',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const CuacaApps(),
      ),
    );
  }
}

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
    await Location.requestLocationPermission();
    context.read<WeatherBloc>().add(WeatherFetchEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cuaca Apps'),
      ),
      body: BlocBuilder<WeatherBloc, WeatherState>(
        builder: (context, state) {
          if (state is WeatherLoaded) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Name: ${state.weatherData.name}'),
                  Text('Temp: ${state.weatherData.main?.temp}'),
                ],
              ),
            );
          } else if (state is WeatherError) {
            return Center(child: Text('Error: ${state.message}'));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
