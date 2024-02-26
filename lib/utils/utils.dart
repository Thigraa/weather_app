import 'package:intl/intl.dart';

String translateCodeWMO(int codigo) {
  List<Map<String, dynamic>> rangos = [
    {"start": 0, "end": 9, "description": "Despejado"},
    {"start": 9, "end": 19, "description": "Nublado"},
    {"start": 20, "end": 30, "description": "Nube"},
    {"start": 30, "end": 40, "description": "Viento con polvo"},
    {"start": 40, "end": 50, "description": "Niebla"},
    {"start": 50, "end": 60, "description": "Llovizna"},
    {"start": 60, "end": 70, "description": "Lluvia"},
    {"start": 70, "end": 80, "description": "Nieve"},
    {"start": 80, "end": 100, "description": "Tormenta"},
  ];

  for (var rango in rangos) {
    if (codigo >= rango['start'] && codigo < rango['end']) {
      return rango['description'];
    }
  }
  return '';
}

String iconCodeWMO(int codigo) {
  List<Map<String, dynamic>> rangos = [
    {"start": 0, "end": 9, "description": "sol.png"},
    {"start": 9, "end": 19, "description": "nublado.png"},
    {"start": 20, "end": 30, "description": "nube.png"},
    {"start": 30, "end": 40, "description": "viento.png"},
    {"start": 40, "end": 50, "description": "niebla.png"},
    {"start": 50, "end": 60, "description": "llovizna.png"},
    {"start": 60, "end": 70, "description": "lluvia.png"},
    {"start": 70, "end": 80, "description": "nieve.png"},
    {"start": 80, "end": 100, "description": "tormenta.png"},
  ];

  for (var rango in rangos) {
    if (codigo >= rango['start'] && codigo < rango['end']) {
      return rango['description'];
    }
  }
  return '';
}

parseToOnlyHours(List<String> complexHoursList) {
  List<String> simpleHoursList = [];

  for (int i = 0; i < complexHoursList.length; i++) {
    String complexHour = complexHoursList[i];
    var splitHour = complexHour.split('T');
    simpleHoursList.add(splitHour[1].substring(0, 2));
  }

  return simpleHoursList;
}

getIconsList(List<int> wmoCodes) {
  List<String> iconsList = [];
  for (int i = 0; i < wmoCodes.length; i++) {
    iconsList.add(iconCodeWMO(wmoCodes[i]));
  }
  return iconsList;
}

int getCurrentTemperature(List<String> hoursList, List<double> temperatureList) {
  final now = DateTime.now();
  final time = DateFormat('kk').format(now);
  int currentTemperature = 0;
  for (int i = 0; i < hoursList.length; i++) {
    if (time == hoursList[i]) {
      currentTemperature = temperatureList[i].round();
      break;
    }
  }
  return currentTemperature;
}

getCurrentIcon(List hoursList, List iconsList) {
  final now = DateTime.now();
  final time = DateFormat('kk').format(now);
  String currentIcon = '';
  for (int i = 0; i < hoursList.length; i++) {
    if (time == hoursList[i]) {
      currentIcon = iconsList[i];
      break;
    }
  }
  print(currentIcon);
  return currentIcon;
}

getCurrentDescription(List hoursList, List codeList) {
  final now = DateTime.now();
  final time = DateFormat('kk').format(now);
  String currentDescription = '';
  for (int i = 0; i < hoursList.length; i++) {
    if (time == hoursList[i]) {
      currentDescription = translateCodeWMO(codeList[i]);
      print(codeList[i]);
      break;
    }
  }
  print(currentDescription);
  return currentDescription;
}

buildChartData(List hourList, List temperatureList) {
  final List<ChartData> chartTempData = [];
  for (int i = 0; i < hourList.length; i++) {
    ChartData chartData = ChartData(int.parse(hourList[i]), temperatureList[i]);
    chartTempData.add(chartData);
  }
  return chartTempData;
}

getMinTemperature(List temperatureList) {
  double minValue = temperatureList[0];
  for (int i = 0; i < temperatureList.length; i++) {
    if (temperatureList[i] < minValue) {
      minValue = temperatureList[i];
    }
  }
  print(minValue);
  return minValue;
}

getMaxTemperature(List temperatureList) {
  print(temperatureList);
  double maxValue = temperatureList[0];
  for (int i = 0; i < temperatureList.length; i++) {
    if (temperatureList[i] > maxValue) {
      maxValue = temperatureList[i];
    }
  }
  return maxValue;
}

class ChartData {
  ChartData(this.x, this.y);
  final int x;
  final double? y;
}
