import 'package:sim/theme/colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

List <Color> gradientColors = [primary];

LineChartData mainData() {
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
        getTextStyles: (value) =>
            const TextStyle(color: Color(0xff68737d), fontSize: 12),
        getTitles: (value) {
          switch (value.toInt()) {
            case 2:
              return 'Jan';
            case 5:
              return 'Feb';
            case 8:
              return 'Mar';
            case 11:
              return 'Apr';
            case 14:
              return 'May';
          }
          return '';
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
          switch (value.toInt()) {
            case 1:
              return '500';
            case 4:
              return '1K';
            case 7:
              return '15K';
            case 10:
              return '20K';
            case 13:
              return '25k';
          }
          return '';
        },
        reservedSize: 28,
        margin: 12,
      ),
    ),
    borderData: FlBorderData(
      show: false,
    ),
    minX: 0,
    maxX: 18,
    minY: 0,
    maxY: 12,
    lineBarsData: [
      LineChartBarData(
        spots: [
          FlSpot(0, 3),
          FlSpot(2.6, 2),
          FlSpot(4.9, 5),
          FlSpot(6.8, 3.1),
          FlSpot(8, 4),
          FlSpot(9.5, 3),
          FlSpot(11, 4),
          FlSpot(12, 5),
          FlSpot(13, 7),
          FlSpot(15, 5),
        ],
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
