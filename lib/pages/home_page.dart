import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:weather_app/providers/weather_provider.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/utils/utils.dart';

const colors = {
  'sunny': [Color(0xff2E5EF0), Color(0xff10A0AC)],
  'cloudy': [Color(0xffC0E9FE), Color(0xffFFFFFF)],
  'raining': [Color(0xff1D2837), Color(0xff1D2837)],
};
var forecastList = [1, 2, 3, 4, 5, 6, 7, 8, 9];

late TrackballBehavior _trackballBehavior;
late ItemScrollController controller;

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    _trackballBehavior = TrackballBehavior(
        // Enables the trackball
        enable: true,
        tooltipSettings: InteractiveTooltip(
          enable: false,
        ),
        activationMode: ActivationMode.singleTap,
        markerSettings: TrackballMarkerSettings(
          shape: DataMarkerType.circle,
          color: Colors.amber.shade700,
          borderColor: Colors.amber.shade700,
          markerVisibility: TrackballVisibilityMode.visible,
          width: 10,
          height: 10,
        ),
        shouldAlwaysShow: true,
        lineColor: Colors.transparent);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    controller = ItemScrollController();
    final weatherProvider = Provider.of<WeatherProvider>(context);

    weatherProvider.getTodayTemperatures();
    return Scaffold(
        body: Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(gradient: LinearGradient(colors: colors['sunny']!, begin: Alignment.topCenter, end: Alignment.bottomCenter)),
      child: Column(children: [
        _LocationAndTime(
          city: weatherProvider.city,
        ),
        _ImgDescriptionTmp(
          temperature: weatherProvider.temperature,
          description: weatherProvider.description,
          icon: weatherProvider.icon,
        ),
        _TemperatureChart(
          provider: weatherProvider,
        ),
        _HourlyReviewListView(
          provider: weatherProvider,
        )
      ]),
    ));
  }
}

class _TemperatureChart extends StatefulWidget {
  const _TemperatureChart({super.key, required this.provider});
  final WeatherProvider provider;

  @override
  State<_TemperatureChart> createState() => _TemperatureChartState();
}

class _TemperatureChartState extends State<_TemperatureChart> {
  @override
  Widget build(BuildContext context) {
    final List<ChartData> chartData = widget.provider.chartData;
    final double minTemperature = widget.provider.minTemperature;
    final double maxTemperature = widget.provider.maxTemperature;
    if (chartData.isEmpty) {
      return Container(
          height: 200,
          child: Center(
              child: CircularProgressIndicator(
            color: Colors.amber,
          )));
    } else {
      return Container(
        height: 180,
        child: SfCartesianChart(
          trackballBehavior: _trackballBehavior,
          margin: EdgeInsets.symmetric(horizontal: 28, vertical: 10),
          plotAreaBorderWidth: 0,
          // backgroundColor: Colors.transparent,
          primaryXAxis: NumericAxis(
            isVisible: false,
          ),
          primaryYAxis: NumericAxis(
            isVisible: false,
            initialVisibleMinimum: minTemperature - 5,
            initialVisibleMaximum: maxTemperature + 5,
          ),
          series: [
            SplineSeries<ChartData, int>(
              color: Colors.amber,
              width: 3.5,
              dataSource: chartData,
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y,
              enableTooltip: true,
            )
          ],
          onTrackballPositionChanging: (trackballArgs) {
            if (widget.provider.hourList.isNotEmpty) {
              widget.provider.selectedHour = widget.provider.hourList[trackballArgs.chartPointInfo.dataPointIndex ?? 0];
              controller.scrollTo(index: trackballArgs.chartPointInfo.dataPointIndex ?? 0, duration: Duration(milliseconds: 200));
            }
          },
        ),
      );
    }
  }
}

class _HourlyReviewListView extends StatefulWidget {
  const _HourlyReviewListView({
    required this.provider,
  });

  final WeatherProvider provider;

  @override
  State<_HourlyReviewListView> createState() => _HourlyReviewListViewState();
}

class _HourlyReviewListViewState extends State<_HourlyReviewListView> {
  @override
  Widget build(BuildContext context) {
    final List hoursList = widget.provider.hourList;
    final List temperaturesList = widget.provider.temperatureList;
    final List iconsList = widget.provider.iconsList;
    if (temperaturesList.isEmpty) {
      return Container(
          height: 200,
          child: Center(
              child: CircularProgressIndicator(
            color: Colors.amber,
          )));
    } else {
      final selectedIndex = temperaturesList.isNotEmpty ? hoursList.indexOf(widget.provider.selectedHour) : 0;

      return Container(
        width: double.infinity,
        height: 170,
        margin: EdgeInsets.symmetric(horizontal: 12),
        child: ScrollablePositionedList.builder(
          key: GlobalKey(),
          initialScrollIndex: selectedIndex,
          itemScrollController: controller,
          initialAlignment: 0.05,
          scrollDirection: Axis.horizontal,
          itemCount: hoursList.length,
          itemBuilder: (context, index) => Container(
            decoration: BoxDecoration(color: widget.provider.selectedHour == hoursList[index] ? Colors.white24 : Colors.white12, borderRadius: BorderRadius.circular(12)),
            margin: EdgeInsets.symmetric(horizontal: 5),
            width: 75,
            child: Container(
              margin: EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(text: '${hoursList[index]}', style: GoogleFonts.inter(color: Colors.white70, fontSize: 20)),
                    TextSpan(text: 'HS', style: GoogleFonts.inter(color: Colors.white70)),
                  ])),
                  Container(
                      decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
                        BoxShadow(
                          color: Colors.yellow.withOpacity(0.25),
                          blurRadius: 10,
                          spreadRadius: 0.1,
                        )
                      ]),
                      child: Image.asset('assets/${iconsList[index]}')),
                  Text(
                    '${temperaturesList[index].round()}º',
                    style: GoogleFonts.inter(color: Colors.white70, fontSize: 20, fontWeight: FontWeight.w600),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
}

class _ImgDescriptionTmp extends StatefulWidget {
  const _ImgDescriptionTmp({
    super.key,
    required this.temperature,
    required this.icon,
    required this.description,
  });

  final temperature;
  final description;
  final String icon;

  @override
  State<_ImgDescriptionTmp> createState() => _ImgDescriptionTmpState();
}

class _ImgDescriptionTmpState extends State<_ImgDescriptionTmp> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(left: 120, right: 120, top: 40, bottom: 14),
          child: Container(
              decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
                BoxShadow(
                  color: Colors.yellow.withOpacity(0.25),
                  blurRadius: 50,
                  spreadRadius: 0.1,
                )
              ]),
              child: widget.icon != '' ? Image.asset('assets/${widget.icon}') : Container()),
        ),
        Container(
          child: Text(
            '${widget.description}',
            style: GoogleFonts.redHatDisplay(fontSize: 30, color: Colors.white, fontWeight: FontWeight.w400),
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 20),
          child: Text(
            '${widget.temperature}º',
            style: GoogleFonts.inter(fontSize: 60, color: Colors.white, fontWeight: FontWeight.w900),
          ),
        ),
      ],
    );
  }
}

class _LocationAndTime extends StatefulWidget {
  const _LocationAndTime({
    super.key,
    required this.city,
  });
  final String city;

  @override
  State<_LocationAndTime> createState() => _LocationAndTimeState();
}

class _LocationAndTimeState extends State<_LocationAndTime> {
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final time = DateFormat('kk:mm').format(now);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 36, vertical: 36),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, 'search'),
            child: Text(
              '${widget.city}',
              style: GoogleFonts.redHatDisplay(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w400),
            ),
          ),
          Text('$time', style: GoogleFonts.redHatDisplay(fontSize: 20, color: Colors.white70, fontWeight: FontWeight.w400))
        ],
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ),
    );
  }
}
