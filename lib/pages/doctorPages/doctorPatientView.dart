import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorPatientView extends StatefulWidget {
  const DoctorPatientView({super.key});

  @override
  State<DoctorPatientView> createState() => _DoctorPatientViewState();
}

class _DoctorPatientViewState extends State<DoctorPatientView> {
  List<String> allPatients = []; // Store all patient names

  @override
  void initState() {
    super.initState();
    fetchPatientNames();
  }

  /// Fetch all patient names from Firestore
  Future<void> fetchPatientNames() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('patient').get();
      setState(() {
        allPatients =
            snapshot.docs.map((doc) => doc['PatientName'].toString()).toList();
      });
    } catch (e) {
      debugPrint('Error fetching patient names: $e');
    }
  }

  Future<void> assignData() async {
    try {
      await FirebaseFirestore.instance
          .collection('patient')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set(
              {
            'AssignedDoctorName': 'John Doe',
            'AssignedDoctorId': 25,
          },
              SetOptions(
                  merge:
                      true)); // Merges with existing data instead of overwriting
      print("Data assigned successfully");
    } catch (e) {
      print("Error assigning data: $e");
    }
  }

  /// Fetch patient details based on selected name
  Future<Map<String, dynamic>?> getPatientDetails(String name) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('patient')
          .where('PatientName', isEqualTo: name)
          .limit(1)
          .get();
    } catch (e) {
      debugPrint('Error fetching patient details: $e');
    }
    return null;
  }

  /// Show Patient Form with dropdown
  void showPatientForm(BuildContext context) {
    String? selectedPatient;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Patient Form"),
          backgroundColor: Theme.of(context).colorScheme.surface,
          content: StatefulBuilder(
            builder: (context, setDialogState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Dropdown Menu
                  DropdownButtonFormField<String>(
                    value: selectedPatient, // Default value
                    hint: const Text("Select a patient"),
                    items: allPatients.map((patient) {
                      return DropdownMenuItem<String>(
                        value: patient,
                        child: Text(patient),
                      );
                    }).toList(),
                    onChanged: (String? newValue) async {
                      setDialogState(() {
                        selectedPatient = newValue;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Patient Name',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 10),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Patient View'),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
      body: ListView(children: [
        patientTile("Patient 1", "ADHD", 12, 13),
        patientTile("Patient 2", "Autism", 10, 15),
        patientTile("Patient 3", "Down Syndrome", 8, 10),
        patientTile("Patient 4", "Cerebral Palsy", 5, 8),
        patientTile("Patient 5", "Dyslexia", 3, 5),
        patientTile("Patient 6", "Diagnosis", 2, 4),
      ]),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        onPressed: () {
          showPatientForm(context);
        },
      ),
    );
  }

  Widget patientTile(String name, String diagnosis, int totalTasksCompleted,
      int totalTasksAssigned) {
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
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              Text(
                diagnosis,
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Text("Total Tasks Completed: $totalTasksCompleted"),
              Text("Total Tasks Assigned: $totalTasksAssigned"),
            ],
          ),
        ),
      ),
    );
  }
}
