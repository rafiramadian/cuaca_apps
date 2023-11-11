import 'package:cuaca_apps/bloc/weather/weather_bloc.dart';
import 'package:cuaca_apps/util/dependency_injection.dart';
import 'package:cuaca_apps/view/cuaca_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';

void main() async {
  await dotenv.load();
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
        debugShowCheckedModeBanner: false,
        title: 'Cuaca Apps',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const CuacaApps(),
      ),
    );
  }
}
