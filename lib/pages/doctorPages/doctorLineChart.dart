// ignore_for_file: camel_case_types, file_names
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class doctorLineChart extends StatelessWidget {
  doctorLineChart({super.key});

  // Line Chart Builder
  Widget lineChartBuilder(double minX, double maxX, List<FlSpot> spots) {
    return Container(
      alignment: Alignment.center,
      height: 350,
      width: 350,
      child: Center(
        child: LineChart(LineChartData(
          minX: minX,
          maxX: maxX,
          minY: 0,
          maxY: 3,
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  // Map the value to month names
                  final months = [
                    'Jan',
                    'Feb',
                    'Mar',
                  ];
                  if (value >= 0 && value < months.length) {
                    return Text(
                      months[value.toInt()],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    );
                  }
                  return const Text('');
                },
                reservedSize: 40, // Reserve space for the month names
              ),
            ),
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: FlGridData(
            show: true,
            drawHorizontalLine: true,
            getDrawingHorizontalLine: (value) {
              return const FlLine(
                color: Colors.white,
                strokeWidth: 0.5,
              );
            },
            drawVerticalLine: true,
            getDrawingVerticalLine: (value) {
              return const FlLine(
                color: Colors.white,
                strokeWidth: 0.5,
              );
            },
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: Colors.blue,
              barWidth: 4,
              isStrokeCapRound: true,
              belowBarData: BarAreaData(
                  show: true, color: const Color.fromARGB(128, 100, 181, 246)),
            ),
          ],
        )),
      ),
    );
  }

  // DB Data Write
  double maxX = 6;
  double minX = 0;
  List<FlSpot> spots = const [
    FlSpot(0, 1.5),
    FlSpot(1.3, 1),
    FlSpot(4.3, 2.5),
    FlSpot(6, 2),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 42,
            ),
            Container(
              alignment: Alignment.center,
              height: 300,
              width: 300,
              child: Center(
                child: LineChart(LineChartData(
                  minX: 0,
                  maxX: 6,
                  minY: 0,
                  maxY: 3,
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          // Map the value to month names
                          final months = [
                            'Jan',
                            'Feb',
                            'Mar',
                          ];
                          if (value >= 0 && value < months.length) {
                            return Text(
                              months[value.toInt()],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            );
                          }
                          return const Text('');
                        },
                        reservedSize: 40, // Reserve space for the month names
                      ),
                    ),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawHorizontalLine: true,
                    getDrawingHorizontalLine: (value) {
                      return const FlLine(
                        color: Colors.white,
                        strokeWidth: 0.5,
                      );
                    },
                    drawVerticalLine: true,
                    getDrawingVerticalLine: (value) {
                      return const FlLine(
                        color: Colors.white,
                        strokeWidth: 0.5,
                      );
                    },
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: const [
                        FlSpot(0, 1.5),
                        FlSpot(1.3, 1),
                        FlSpot(4.3, 2.5),
                        FlSpot(6, 2),
                      ],
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 4,
                      isStrokeCapRound: true,
                      belowBarData: BarAreaData(
                          show: true,
                          color: const Color.fromARGB(128, 100, 181, 246)),
                    ),
                  ],
                )),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            lineChartBuilder(0, 6, spots)
          ],
        ),
      ),
    );
  }
}
