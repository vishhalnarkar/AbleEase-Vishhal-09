import 'dart:ffi';

import 'package:ableeasefinale/resources/scores_methods.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MyBarChart extends StatefulWidget {
  @override
  State<MyBarChart> createState() => _MyBarChartState();
}

class _MyBarChartState extends State<MyBarChart> {
  // const MyBarChart({super.key});
  double tetrisRounds = 0;
  double flappyRounds = 0;
  double maxYValue=20;

  @override
  void initState() {
    super.initState();
    fetchRounds();
  }

  Future<void> fetchRounds() async {
    // print("Inside Fetch Detail");

    // print(stackingRounds);
    tetrisRounds = await ScoreMethods()
        .getTotalRounds(gameCategory: 'decison_making', gameName: 'tetris') ?? 0;

    flappyRounds = await ScoreMethods().getTotalRounds(
        gameCategory: 'decison_making', gameName: 'flappy_bird') ?? 0;

    double highestValue = [
      tetrisRounds,
      flappyRounds
    ].reduce((value, element) => value > element ? value : element);

    setState(() {
      maxYValue = highestValue+10; // Update maxYValue
    }); // Refresh UI after fetching data

    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    // List<int> allGameRounds;

    // double stackingRounds= await ScoreMethods().getTotalRounds(gameCategory: 'decison_making', gameName: 'stacking');

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
                'Decision Making',
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
                      x: 1, barRods: [BarChartRodData(toY: tetrisRounds)]),
                  BarChartGroupData(
                      x: 2, barRods: [BarChartRodData(toY: flappyRounds)]),
                ])),
          ),
          Container(child: const Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 100,),
                  Text("Tetris"),
                  SizedBox(width: 90),
                  Text("Flappy Bird"),
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
