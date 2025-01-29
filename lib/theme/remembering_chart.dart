import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../resources/scores_methods.dart';

class rememberingChart extends StatefulWidget {
  const rememberingChart({super.key});

  @override
  State<rememberingChart> createState() => _rememberingChartState();
}

class _rememberingChartState extends State<rememberingChart> {

  double colorRounds = 0;
  double memoryRounds = 0;
  double maxYValue=20;

  @override
  void initState() {
    super.initState();
    fetchRounds();
  }

  Future<void> fetchRounds() async {
    // print("Inside Fetch Detail");
    colorRounds = await ScoreMethods()
        .getTotalRounds(gameCategory: 'remembering', gameName: 'color_game');

    // print(stackingRounds);
    memoryRounds = await ScoreMethods()
        .getTotalRounds(gameCategory: 'remembering', gameName: 'memory_game');

    double highestValue = [
      colorRounds,
      memoryRounds
    ].reduce((value, element) => value > element ? value : element);

    setState(() {
      maxYValue = highestValue+10; // Update maxYValue
    }); // Refresh UI after fetching data
  }


  @override
  Widget build(BuildContext context) {
    fetchRounds();
    // print(stackingRounds);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.graphic_eq),
              const SizedBox(
                width: 32,
              ),
              Text(
                'Remembering',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 32,
          ),
          Expanded(
            child: BarChart(BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxYValue,
                barTouchData: BarTouchData(
                  enabled: true,
                ),
                barGroups: [
                  BarChartGroupData(
                      x: 1, barRods: [BarChartRodData(toY: colorRounds)]),
                  BarChartGroupData(
                      x: 2, barRods: [BarChartRodData(toY: memoryRounds)]),
                ])),
          ),
          Container(child: const Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 70,),
                  Text("Color Game"),
                  SizedBox(width: 70),
                  Text("Memory Game"),
                ],
              ),
            ],
          ))
        ],
      ),
    );
  }

  BarChartGroupData makeGroupData(
    int x,
    double y,
  ) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: x >= 4 ? Colors.transparent : Colors.purple,
          borderRadius: BorderRadius.zero,
          borderDashArray: x >= 4 ? [4, 4] : null,
          width: 22,
          borderSide: BorderSide(color: Colors.white60, width: 2.0),
        ),
      ],
    );
  }
}