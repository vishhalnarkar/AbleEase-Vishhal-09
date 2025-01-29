import 'package:ableeasefinale/pages/games/flappyBird/barrier.dart';
import 'package:ableeasefinale/theme/paying_chart.dart';
import 'package:ableeasefinale/theme/profileBarChart.dart';
import 'package:ableeasefinale/theme/remembering_chart.dart';
import 'package:flutter/material.dart';

class InsightsPage extends StatefulWidget {
  const InsightsPage({super.key});

  @override
  State<InsightsPage> createState() => _InsightsPageState();
}

class _InsightsPageState extends State<InsightsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
        title: Text("See Insights"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            //Full screen container
            child: Column(
              children: [
                Container(
                  //First Graph Container
                  child: Column(
                    children: [
                      SizedBox(
                        height: 300,
                        width: 500,
                        child: MyBarChart(),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 300,
                        width: 500,
                        child: payingChart(),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 300,
                        width: 500,
                        child: rememberingChart(),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
