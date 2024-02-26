// To parse this JSON data, do
//
//     final weatherResponse = weatherResponseFromJson(jsonString);

import 'dart:convert';

WeatherResponse weatherResponseFromJson(String str) => WeatherResponse.fromJson(json.decode(str));

class WeatherResponse {
  double latitude;
  double longitude;
  double generationtimeMs;
  int utcOffsetSeconds;
  String timezone;
  String timezoneAbbreviation;
  double elevation;
  HourlyUnits hourlyUnits;
  Hourly hourly;

  WeatherResponse({
    required this.latitude,
    required this.longitude,
    required this.generationtimeMs,
    required this.utcOffsetSeconds,
    required this.timezone,
    required this.timezoneAbbreviation,
    required this.elevation,
    required this.hourlyUnits,
    required this.hourly,
  });

  factory WeatherResponse.fromJson(Map<String, dynamic> json) => WeatherResponse(
        latitude: json["latitude"],
        longitude: json["longitude"],
        generationtimeMs: json["generationtime_ms"],
        utcOffsetSeconds: json["utc_offset_seconds"],
        timezone: json["timezone"],
        timezoneAbbreviation: json["timezone_abbreviation"] ?? '',
        elevation: json["elevation"],
        hourlyUnits: HourlyUnits.fromJson(json["hourly_units"]),
        hourly: Hourly.fromJson(json["hourly"]),
      );
}

class Hourly {
  List<String> time;
  List<double> temperature2M;
  List<int> weatherCode;

  Hourly({
    required this.time,
    required this.temperature2M,
    required this.weatherCode,
  });

  factory Hourly.fromJson(Map<String, dynamic> json) => Hourly(
        time: List<String>.from(json["time"].map((x) => x)),
        temperature2M: List<double>.from(json["temperature_2m"].map((x) => x?.toDouble())),
        weatherCode: List<int>.from(json["weather_code"].map((x) => x)),
      );
}

class HourlyUnits {
  String time;
  String temperature2M;
  String weatherCode;

  HourlyUnits({
    required this.time,
    required this.temperature2M,
    required this.weatherCode,
  });

  factory HourlyUnits.fromJson(Map<String, dynamic> json) => HourlyUnits(
        time: json["time"],
        temperature2M: json["temperature_2m"],
        weatherCode: json["weather_code"],
      );
}
