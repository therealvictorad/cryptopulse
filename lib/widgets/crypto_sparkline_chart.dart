import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CryptoSparklineChart extends StatelessWidget {
  final List<double> sparkline;

  const CryptoSparklineChart({super.key, required this.sparkline});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: LineChart(
        LineChartData(
          titlesData: const FlTitlesData(show: false),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          lineTouchData: const LineTouchData(enabled: false),
          lineBarsData: [
            LineChartBarData(
              spots: sparkline
                  .asMap()
                  .entries
                  .map((e) => FlSpot(e.key.toDouble(), e.value))
                  .toList(),
              isCurved: true,
              barWidth: 2,
              color: Colors.greenAccent,
              dotData: const FlDotData(show: false),
            ),
          ],
        ),
      ),
    );
  }
}
