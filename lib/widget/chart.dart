import 'package:sim/theme/colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

List <Color> gradientColors = [primary];
List<FlSpot>data = [];
List data_dic = [];
double minx = 0;
double maxx = 1;
double miny = 0;
double maxy = 1;
double inter = 0;
external String get millisecondsSinceEpoch;

LineChartData mainData(List X_test, List mean) {
  data= [];
  print(X_test);
  print(mean);
  //minx = DateTime.parse(X_test[0]).millisecondsSinceEpoch.toDouble();
  //maxx = DateTime.parse(X_test[X_test.length-1]).millisecondsSinceEpoch.toDouble();
  //minx = 0.0;
  //maxx =double.parse(X_test.length.toString());

  for (var i= 0; i<X_test.length; i++){
    //print(DateTime.parse(DateFormat('MM-dd').format(DateTime.parse(X_test[i]))));
    double date = DateTime.parse(X_test[i]).toUtc().millisecondsSinceEpoch.toDouble();
    print(DateTime.fromMillisecondsSinceEpoch(date.toInt()).toString());
    print(mean[i]);
    data_dic.add({DateTime.fromMillisecondsSinceEpoch(date.toInt()).toString():mean[i]});

    //data.add(FlSpot(date,mean[i]));
    data.add(FlSpot(double.parse(i.toString()),mean[i]));

  }



  miny =  mean.reduce((curr, next) => curr < next? curr: next);
  maxy = mean.reduce((curr, next) => curr > next? curr: next);
  var avg = mean.reduce((a, b) => a + b) / mean.length;
  if(avg >=1000)
    inter = 1000;
    else
  if(avg >=500)
    inter = 100;
  else
      inter = 50;

  return LineChartData(
    gridData: FlGridData(
        show: true,
        drawHorizontalLine: false,
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
        reservedSize: 30,
        rotateAngle: 300,
        getTextStyles: (value) =>
            const TextStyle(color: Color(0xff68737d), fontSize: 10),
        getTitles: (value) {

          double date = DateTime.parse(X_test[value.toInt()]).toUtc().millisecondsSinceEpoch.toDouble();
          print(DateTime.fromMillisecondsSinceEpoch(date.toInt()).toString());
          return DateFormat('MM-dd').format(DateTime.fromMillisecondsSinceEpoch(date.toInt()));
         //print(DateFormat('MM-dd').format(DateTime.fromMillisecondsSinceEpoch(value.toInt())));
          //return DateFormat('MM-dd').format(DateTime.fromMillisecondsSinceEpoch(value.toInt()));
          //return DateFormat('MM-dd').format(DateTime.fromMillisecondsSinceEpoch(value.toInt()));
        },
        margin: 8,
      ),
      leftTitles: SideTitles(
        interval: inter,
        showTitles: true,
        getTextStyles: (value) => const TextStyle(
          color: Color(0xff67727d),
          fontSize: 10,
        ),
        getTitles: (value) {
        return value.toInt().toString();

        },
        reservedSize: 30,
        margin: 10,
      ),
    ),
    borderData: FlBorderData(
      show: false,
    ),
   //minX: minx,
    // maxX: maxx,
    minY: 0 ,
    maxY: double.parse(maxy.toString()),
    lineBarsData: [
      LineChartBarData(
        spots: data,
        //isCurved: true,
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
