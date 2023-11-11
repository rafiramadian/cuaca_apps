class CitySuggestionWeather {
  String message;
  String cod;
  int count;
  List<WeatherLocation> list;

  CitySuggestionWeather({
    required this.message,
    required this.cod,
    required this.count,
    required this.list,
  });

  factory CitySuggestionWeather.fromJson(Map<String, dynamic> json) {
    return CitySuggestionWeather(
      message: json['message'],
      cod: json['cod'],
      count: json['count'],
      list: (json['list'] as List)
          .map((location) => WeatherLocation.fromJson(location))
          .toList(),
    );
  }
}

class WeatherLocation {
  int id;
  String name;
  Coord coord;
  Main main;
  int dt;
  Wind wind;
  Sys sys;
  Rain? rain;
  Snow? snow;
  Clouds clouds;
  List<WeatherCondition> weather;

  WeatherLocation({
    required this.id,
    required this.name,
    required this.coord,
    required this.main,
    required this.dt,
    required this.wind,
    required this.sys,
    required this.rain,
    required this.snow,
    required this.clouds,
    required this.weather,
  });

  factory WeatherLocation.fromJson(Map<String, dynamic> json) {
    return WeatherLocation(
      id: json['id'],
      name: json['name'],
      coord: Coord.fromJson(json['coord']),
      main: Main.fromJson(json['main']),
      dt: json['dt'],
      wind: Wind.fromJson(json['wind']),
      sys: Sys.fromJson(json['sys']),
      rain: json['rain'] != null ? Rain.fromJson(json['rain']) : null,
      snow: json['snow'] != null ? Snow.fromJson(json['snow']) : null,
      clouds: Clouds.fromJson(json['clouds']),
      weather: (json['weather'] as List)
          .map((condition) => WeatherCondition.fromJson(condition))
          .toList(),
    );
  }
}

class Coord {
  double lat;
  double lon;

  Coord({required this.lat, required this.lon});

  factory Coord.fromJson(Map<String, dynamic> json) {
    return Coord(
      lat: json['lat'],
      lon: json['lon'],
    );
  }
}

class Main {
  double temp;
  double feelsLike;
  double tempMin;
  double tempMax;
  int pressure;
  int humidity;

  Main({
    required this.temp,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.pressure,
    required this.humidity,
  });

  factory Main.fromJson(Map<String, dynamic> json) {
    return Main(
      temp: json['temp'].toDouble(),
      feelsLike: json['feels_like'].toDouble(),
      tempMin: json['temp_min'].toDouble(),
      tempMax: json['temp_max'].toDouble(),
      pressure: json['pressure'],
      humidity: json['humidity'],
    );
  }
}

class Wind {
  double speed;
  int deg;

  Wind({required this.speed, required this.deg});

  factory Wind.fromJson(Map<String, dynamic> json) {
    return Wind(
      speed: json['speed'].toDouble(),
      deg: json['deg'],
    );
  }
}

class Sys {
  String country;

  Sys({required this.country});

  factory Sys.fromJson(Map<String, dynamic> json) {
    return Sys(
      country: json['country'],
    );
  }
}

class Rain {
  double? oneHour;

  Rain({this.oneHour});

  factory Rain.fromJson(Map<String, dynamic> json) {
    return Rain(
      oneHour: json['1h']?.toDouble(),
    );
  }
}

class Snow {
  double? oneHour;

  Snow({this.oneHour});

  factory Snow.fromJson(Map<String, dynamic> json) {
    return Snow(
      oneHour: json['1h']?.toDouble(),
    );
  }
}

class Clouds {
  int all;

  Clouds({required this.all});

  factory Clouds.fromJson(Map<String, dynamic> json) {
    return Clouds(
      all: json['all'],
    );
  }
}

class WeatherCondition {
  int id;
  String main;
  String description;
  String icon;

  WeatherCondition({
    required this.id,
    required this.main,
    required this.description,
    required this.icon,
  });

  factory WeatherCondition.fromJson(Map<String, dynamic> json) {
    return WeatherCondition(
      id: json['id'],
      main: json['main'],
      description: json['description'],
      icon: json['icon'],
    );
  }
}
