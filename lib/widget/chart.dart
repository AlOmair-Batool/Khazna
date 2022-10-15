import 'package:sim/theme/colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

List <Color> gradientColors = [primary];
List<FlSpot>data = [];
double minx = 0;
double maxx = 1;
double miny = 0;
double maxy = 1;
external String get millisecondsSinceEpoch;

LineChartData mainData(List X_test, List mean) {
  print("Najat");
  print(X_test);
  print(mean);
  minx = DateTime.parse(X_test[0][0]).toUtc().millisecondsSinceEpoch.toDouble();
  maxx = DateTime.parse(X_test[X_test.length-1][0]).toUtc().millisecondsSinceEpoch.toDouble();
  miny = mean[0][0];
  maxy = mean[mean.length-1][0];

  print("outside");

  for (var i= 0 ; i<X_test.length; i++){
    print("loop");
    double date = DateTime.parse(X_test[i][0]).toUtc().millisecondsSinceEpoch.toDouble();
    print(DateTime.fromMillisecondsSinceEpoch(date.toInt()).toString());
    data.insert(0,  FlSpot(date,mean[i][0].abs()));

  }

  return LineChartData(
    gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 0.1,
          );
        }),
    titlesData: FlTitlesData(
      show: true,
      bottomTitles: SideTitles(
        showTitles: true,
        reservedSize: 22,
        rotateAngle: 300,
        getTextStyles: (value) =>
            const TextStyle(color: Color(0xff68737d), fontSize: 10),
        getTitles: (value) {

          return DateFormat('MM-dd'). format(DateTime.fromMillisecondsSinceEpoch(value.toInt()));
        },
        margin: 8,
      ),
      leftTitles: SideTitles(
        showTitles: true,
        getTextStyles: (value) => const TextStyle(
          color: Color(0xff67727d),
          fontSize: 12,
        ),
        getTitles: (value) {
        //return val.substring(0, val.indexOf(".")+2);
          print(value.toStringAsFixed(2));

        return value.toStringAsFixed(2);
        },
        reservedSize: 28,
        margin: 12,
      ),
    ),
    borderData: FlBorderData(
      show: false,
    ),
     minX: minx,
     maxX: maxx,

    lineBarsData: [
      LineChartBarData(
        spots: data,
        isCurved: true,
        colors: gradientColors,
        barWidth: 2.5,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: false,
        ),
      ),
    ],
  );
}
