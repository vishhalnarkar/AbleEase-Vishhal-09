import 'package:flutter/material.dart';

class DoctorPatientView extends StatefulWidget {
  const DoctorPatientView({super.key});

  @override
  State<DoctorPatientView> createState() => _DoctorPatientViewState();
}

class _DoctorPatientViewState extends State<DoctorPatientView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          title: const Text('Patient View'),
          backgroundColor: Theme.of(context).colorScheme.secondary,
        ),
        body: ListView(children: [
          patientTile("Patient 1", 25, "ADHD", 12, 13),
          patientTile("Patient 2", 30, "Autism", 10, 15),
          patientTile("Patient 3", 35, "Down Syndrome", 8, 10),
          patientTile("Patient 4", 40, "Cerebral Palsy", 5, 8),
          patientTile("Patient 5", 45, "Dyslexia", 3, 5),
          patientTile("Patient 6", 42, "diagnosis", 2, 4),
        ]));
  }

  Widget patientTile(String name, int age, String diagnosis,
      int totalTasksCompleted, int totalTasksAssigned) {
    return Padding(
      padding: const EdgeInsets.only(left: 17, right: 17, top: 17),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimary),
              ),
              Text(
                "$age $diagnosis",
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Total Tasks Completed: $totalTasksCompleted",
                style: const TextStyle(fontSize: 14),
              ),
              Text(
                "Total Tasks Assigned: $totalTasksAssigned",
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// Compare this snippet from lib/pages/doctorPages/doctorPatientView.dart:
