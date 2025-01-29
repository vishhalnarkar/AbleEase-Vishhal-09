import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DoctorPatientChart extends StatefulWidget {
  const DoctorPatientChart({super.key});

  @override
  State<DoctorPatientChart> createState() => _DoctorPatientChartState();
}

class _DoctorPatientChartState extends State<DoctorPatientChart> {
  Map<String, int> doctorPatientCount = {}; // Stores doctor -> patient count
  bool isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();
    fetchDoctorPatientData();
  }

  /// Fetch patient assignment data from Firestore
  Future<void> fetchDoctorPatientData() async {
    try {
      QuerySnapshot usersSnapshot =
          await FirebaseFirestore.instance.collection('users').get();

      Map<String, int> tempCount = {};

      for (var doc in usersSnapshot.docs) {
        String? doctorId = doc['assignedDoctor']; // Check if field exists
        if (doctorId != null) {
          tempCount[doctorId] = (tempCount[doctorId] ?? 0) + 1;
        }
      }

      setState(() {
        doctorPatientCount = tempCount;
        isLoading = false; // Mark as loaded
      });
    } catch (e) {
      debugPrint('Error fetching data: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (doctorPatientCount.isEmpty) {
      return const Center(child: Text("No data available"));
    }

    return SizedBox(
      height: 300,
      width: double.infinity,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: true),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true, reservedSize: 40),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  int index = value.toInt();
                  if (index >= 0 && index < doctorPatientCount.keys.length) {
                    return Text(doctorPatientCount.keys.elementAt(index));
                  }
                  return const Text('');
                },
                reservedSize: 40,
              ),
            ),
          ),
          borderData: FlBorderData(show: true),
          lineBarsData: [
            LineChartBarData(
              spots: doctorPatientCount.isNotEmpty
                  ? doctorPatientCount.entries
                      .toList()
                      .asMap()
                      .entries
                      .map((e) =>
                          FlSpot(e.key.toDouble(), e.value.value.toDouble()))
                      .toList()
                  : [const FlSpot(0, 0)], // Prevent empty state crash
              isCurved: true,
              color: Colors.blue,
              barWidth: 3,
              isStrokeCapRound: true,
              belowBarData:
                  BarAreaData(show: true, color: Colors.blue.withOpacity(0.3)),
            ),
          ],
        ),
      ),
    );
  }
}
