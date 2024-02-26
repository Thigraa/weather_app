import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;
import 'package:weather_app/models/weather_response.dart';
import 'package:weather_app/utils/utils.dart';

class WeatherProvider extends ChangeNotifier {
  bool isCalled = false;
  String _baseUrl = 'api.open-meteo.com';
  String _city = 'Barcelona';
  String _latitude = '41.4921';
  String _longitude = '2.3652';
  String _description = '';
  String _icon = '';
  int _temperature = 0;
  List<double> _temperatureList = [];
  List<String> _hoursList = [];
  List<int> _codeList = [];
  List<String> _iconsList = [];
  List<ChartData> _chartData = [];
  double _minTemperature = 0;
  double _maxTemperature = 50;
  String _selectedHour = DateFormat('kk').format(DateTime.now());

  getTodayTemperatures() async {
    if (!isCalled) {
      final url = Uri.https(_baseUrl, '/v1/forecast', {'latitude': _latitude, 'longitude': _longitude, 'hourly': 'temperature_2m,weather_code', 'timezone': 'auto', 'forecast_days': '1'});
      final response = await http.get(url);
      // print(response.body);
      final weatherResponse = WeatherResponse.fromJson(json.decode(response.body));
      // print(weatherResponse);
      setWeatherData(weatherResponse);
    }
  }

  setWeatherData(WeatherResponse weatherResponse) {
    _latitude = weatherResponse.latitude.toString();
    _longitude = weatherResponse.longitude.toString();
    _temperatureList = weatherResponse.hourly.temperature2M;
    _hoursList = parseToOnlyHours(weatherResponse.hourly.time);
    _codeList = weatherResponse.hourly.weatherCode;

    _temperature = getCurrentTemperature(_hoursList, _temperatureList);
    _iconsList = getIconsList(_codeList);
    _chartData = buildChartData(_hoursList, _temperatureList);
    _minTemperature = getMinTemperature(_temperatureList);
    _maxTemperature = getMaxTemperature(_temperatureList);
    _icon = getCurrentIcon(_hoursList, _iconsList);

    _description = getCurrentDescription(_hoursList, _codeList);
    isCalled = true;
    notifyListeners();
  }

  set selectedHour(String hour) {
    _selectedHour = hour;
    notifyListeners();
  }

  set latitude(String latitude) {
    _latitude = latitude;
    notifyListeners();
  }

  set longitude(String longitude) {
    _longitude = longitude;
    notifyListeners();
  }

  set city(String city) {
    _city = city;
    notifyListeners();
  }

  String get city => this._city;
  get temperature => this._temperature;
  get description => this._description;
  get icon => this._icon;
  get temperatureList => this._temperatureList;
  List<String> get hourList => this._hoursList;
  get iconsList => this._iconsList;
  get chartData => this._chartData;
  get minTemperature => this._minTemperature;
  get maxTemperature => this._maxTemperature;
  String get selectedHour => this._selectedHour;
}
