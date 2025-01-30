import 'package:ableeasefinale/pages/doctorPages/doctorLineChart.dart';
import 'package:ableeasefinale/theme/linechart.dart';
import 'package:flutter/material.dart';

class doctorInsightsPage extends StatefulWidget {
  const doctorInsightsPage({super.key});

  @override
  State<doctorInsightsPage> createState() => _doctorInsightsPageState();
}

class _doctorInsightsPageState extends State<doctorInsightsPage> {
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
        title: const Text("Doctor Insights"), // Updated title
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 350,
                width: 350,
                child: doctorLineChart(), // Display doctor-patient chart
              ),
            ],
          ),
        ),
      ),
    );
  }
}
