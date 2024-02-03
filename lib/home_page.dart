import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

const colors = {
  'sunny': [Color(0xff2E5EF0), Color(0xff10A0AC)],
  'cloudy': [Color(0xffC0E9FE), Color(0xffFFFFFF)],
  'raining': [Color(0xff1D2837), Color(0xff1D2837)],
};
var forecastList = [1, 2, 3, 4, 5, 6, 7, 8, 9];

final List<ChartData> chartData = [
  ChartData(0, 8),
  ChartData(1, 8),
  ChartData(2, 7),
  ChartData(3, 6),
  ChartData(4, 5),
  ChartData(5, 6),
  ChartData(6, 5),
  ChartData(7, 9),
  ChartData(8, 10),
  ChartData(9, 11),
  ChartData(10, 12),
  ChartData(11, 12),
  ChartData(12, 13),
  ChartData(13, 13),
  ChartData(14, 12),
  ChartData(15, 11),
  ChartData(16, 11),
  ChartData(16, 11),
  ChartData(17, 10),
  ChartData(18, 8),
  ChartData(19, 7),
  ChartData(20, 7),
  ChartData(21, 7),
  ChartData(22, 6),
  ChartData(23, 6),
];

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(gradient: LinearGradient(colors: colors['sunny']!, begin: Alignment.topCenter, end: Alignment.bottomCenter)),
      child: Column(children: [_LocationAndTime(), _ImgTextTmp(), _TemperatureChart(), _HourlyReviewListView()]),
    ));
  }
}

class _TemperatureChart extends StatelessWidget {
  const _TemperatureChart({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      child: SfCartesianChart(
        margin: EdgeInsets.symmetric(horizontal: 28),
        plotAreaBorderWidth: 0,
        backgroundColor: Colors.transparent,
        primaryXAxis: NumericAxis(
          isVisible: false,
        ),
        primaryYAxis: NumericAxis(
          isVisible: false,
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
      ),
    );
  }
}

class _HourlyReviewListView extends StatelessWidget {
  const _HourlyReviewListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 170,
      margin: EdgeInsets.symmetric(horizontal: 12),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: forecastList.length,
        itemBuilder: (context, index) => Container(
          decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(12)),
          margin: EdgeInsets.symmetric(horizontal: 5),
          width: 70,
          child: Container(
            margin: EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                    text: TextSpan(children: [
                  TextSpan(text: '9', style: GoogleFonts.inter(color: Colors.white70, fontSize: 20)),
                  TextSpan(text: 'HS', style: GoogleFonts.inter(color: Colors.white70)),
                ])),
                Image.asset('assets/nube.png'),
                Text(
                  '24º',
                  style: GoogleFonts.inter(color: Colors.white70, fontSize: 22, fontWeight: FontWeight.w600),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ImgTextTmp extends StatelessWidget {
  const _ImgTextTmp({
    super.key,
  });

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
              child: Image.asset('assets/nube.png')),
        ),
        Container(
          child: Text(
            'Soleado',
            style: GoogleFonts.redHatDisplay(fontSize: 30, color: Colors.white, fontWeight: FontWeight.w400),
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 20),
          child: Text(
            '25º',
            style: GoogleFonts.inter(fontSize: 60, color: Colors.white, fontWeight: FontWeight.w900),
          ),
        ),
      ],
    );
  }
}

class _LocationAndTime extends StatelessWidget {
  const _LocationAndTime({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 36, vertical: 36),
      child: Row(
        children: [
          Text(
            'Barcelona',
            style: GoogleFonts.redHatDisplay(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w400),
          ),
          Text('11:00', style: GoogleFonts.redHatDisplay(fontSize: 20, color: Colors.white70, fontWeight: FontWeight.w400))
        ],
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final int x;
  final double? y;
}
