part of 'weather_bloc.dart';

class WeatherEvent extends Equatable {
  const WeatherEvent();

  @override
  List<Object> get props => [];
}

class WeatherFetchEvent extends WeatherEvent {}

class WeatherFetchByCityEvent extends WeatherEvent {
  final String city;

  const WeatherFetchByCityEvent(this.city);

  @override
  List<Object> get props => [city];
}
