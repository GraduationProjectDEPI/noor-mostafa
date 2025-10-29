import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ChartPage extends StatelessWidget {
  const ChartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<FlSpot> points = [
      FlSpot(1, 3.5),
      FlSpot(2, 2.8),
      FlSpot(3, 4.1),
      FlSpot(4, 3.2),
      FlSpot(5, 4.4),
      FlSpot(6, 5.0),
      FlSpot(7, 4.6),
    ];
    final lineChartData = LineChartData(
      gridData: FlGridData(show: true), // show the network background
      //----- setting of names of x and y -------
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
      ),
      //----- the outliers of draw -------
      borderData: FlBorderData(show: true),
      //----- basic data for drawing --------
      lineBarsData: [
        LineChartBarData(
          spots: points, // the points that we did up
          isCurved: true,
          color: Colors.blueAccent,
          barWidth: 3, // line width
          dotData: FlDotData(show: false), // not show the small points
          belowBarData: BarAreaData(
            show: true,
            // ---- control the gradient color under the line -------
            gradient: LinearGradient(
              colors: [
                Colors.blueAccent.withOpacity(0.3),
                Colors.blueAccent.withOpacity(0.0),
              ],
              // ----  the gradient start and end -------
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ],
    );
    return Card(
      elevation: 4, // تحدد مدى بروز الكارت عن الخلفية
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LineChart(lineChartData),
      ),
    );
  }
}
