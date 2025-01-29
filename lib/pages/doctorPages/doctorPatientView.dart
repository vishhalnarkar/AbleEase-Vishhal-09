import 'package:flutter/material.dart';
import 'dart:math';

class DoctorPatientView extends StatefulWidget {
  const DoctorPatientView({super.key});

  @override
  State<DoctorPatientView> createState() => _DoctorPatientViewState();
}

class _DoctorPatientViewState extends State<DoctorPatientView> {
  int generateRandomNumber() {
    Random random = Random();
    return 7 + random.nextInt(60);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          title: const Text('Patient View'),
          backgroundColor: Theme.of(context).colorScheme.secondary,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: ListView(children: [
          patientTile("Patient 1", "ADHD", 12, 13),
          patientTile("Patient 2", "Autism", 10, 15),
          patientTile("Patient 3", "Down Syndrome", 8, 10),
          patientTile("Patient 4", "Cerebral Palsy", 5, 8),
          patientTile("Patient 5", "Dyslexia", 3, 5),
          patientTile("Patient 6", "diagnosis", 2, 4),
        ]),
        floatingActionButton: FloatingActionButton(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            child: Icon(
              Icons.add,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            onPressed: () {
              print('FAB Clicked!');
              showPatientForm(context);
            }));
  }

  Widget patientTile(String name, String diagnosis, int totalTasksCompleted,
      int totalTasksAssigned) {
    int age = generateRandomNumber();
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
                "$age, $diagnosis",
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

  void showPatientForm(BuildContext context) {
    final nameController = TextEditingController();
    final ageController = TextEditingController();
    final diagnosisController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          titleTextStyle:
              TextStyle(color: Theme.of(context).colorScheme.surface),
          contentTextStyle:
              TextStyle(color: Theme.of(context).colorScheme.surface),
          backgroundColor: Theme.of(context).colorScheme.onSecondary,
          title: Text("Patient Form"),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: ageController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Age'),
                ),
                TextField(
                  controller: diagnosisController,
                  decoration: InputDecoration(labelText: 'Diagnosis'),
                ),
              ],
            ),
          ),
          actions: [
            // Cancel button (border only)
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              style: TextButton.styleFrom(
                side: BorderSide(
                  color: Theme.of(context).colorScheme.secondary,
                  width: 1,
                ),
              ),
              child: Text(
                'Cancel',
                style:
                    TextStyle(color: Theme.of(context).colorScheme.secondary),
              ),
            ),
            // OK button (filled with color)
            ElevatedButton(
              onPressed: () {
                // You can get the form data here using the controllers
                String name = nameController.text;
                String age = ageController.text;
                String diagnosis = diagnosisController.text;

                // Close the dialog
                Navigator.of(context).pop();

                // Do something with the form data
                print('Name: $name, Age: $age, Diagnosis: $diagnosis');
              },
              child: Text('OK'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ],
        );
      },
    );
  }
}
// Compare this snippet from lib/pages/doctorPages/doctorPatientView.dart:
