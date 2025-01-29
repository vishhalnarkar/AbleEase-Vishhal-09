import 'package:flutter/material.dart';
import 'package:ableeasefinale/resources/scores_methods.dart';
import 'package:fl_chart/fl_chart.dart';

class payingChart extends StatefulWidget {
  const payingChart({super.key});

  @override
  State<payingChart> createState() => _payingChartState();
}

class _payingChartState extends State<payingChart> {

  double brickRounds = 0;
  double snakeRounds = 0;
  double maxYValue=20;

  @override
  void initState() {
    super.initState();
    fetchRounds();
  }

  Future<void> fetchRounds() async {
    // print("Inside Fetch Detail");
    brickRounds = await ScoreMethods()
        .getTotalRounds(gameCategory: 'paying_attention', gameName: 'brick_breaker');

    // print(stackingRounds);
    snakeRounds = await ScoreMethods()
        .getTotalRounds(gameCategory: 'paying_attention', gameName: 'snake_game');

    double highestValue = [
      brickRounds,
      snakeRounds
    ].reduce((value, element) => value > element ? value : element);

    setState(() {
      maxYValue = highestValue+10; // Update maxYValue
    }); // Refresh UI after fetching data

    setState(() {
      
    });
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
                'Paying Attention',
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
                      x: 1, barRods: [BarChartRodData(toY: brickRounds)]),
                  BarChartGroupData(
                      x: 2, barRods: [BarChartRodData(toY: snakeRounds)]),
                ])),
          ),
          Container(child: const Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 70,),
                  Text("Brick Breaker"),
                  SizedBox(width: 70),
                  Text("Snake Game"),
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