import 'package:cuaca_apps/api/weather_api.dart';
import 'package:cuaca_apps/blocs/weather/weather_bloc.dart';
import 'package:cuaca_apps/services/http_service.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton(() => HttpService());
  getIt.registerLazySingleton(
      () => WeatherApi(httpService: getIt.get<HttpService>()));
  getIt.registerLazySingleton(
      () => WeatherBloc(weatherApi: getIt.get<WeatherApi>()));
}
