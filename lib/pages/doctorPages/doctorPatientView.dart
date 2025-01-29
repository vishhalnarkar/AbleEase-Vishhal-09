import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorPatientView extends StatefulWidget {
  const DoctorPatientView({super.key});

  @override
  State<DoctorPatientView> createState() => _DoctorPatientViewState();
}

class _DoctorPatientViewState extends State<DoctorPatientView> {
  List<String> allPatients = []; // Store all patient names
  List<String> filteredPatients = []; // Filtered list for search

  @override
  void initState() {
    super.initState();
    fetchPatientNames();
  }

  /// Fetch all patient names from Firestore
  Future<void> fetchPatientNames() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('patients').get();
      setState(() {
        allPatients =
            snapshot.docs.map((doc) => doc['name'].toString()).toList();
        filteredPatients = allPatients; // Initialize filtered list
      });
    } catch (e) {
      debugPrint('Error fetching patient names: $e');
    }
  }

  /// Fetch patient details based on selected name
  Future<Map<String, dynamic>?> getPatientDetails(String name) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('patients')
          .where('name', isEqualTo: name)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        var doc = snapshot.docs.first;
        return {
          'age': doc['age'],
          'diagnosis': doc['diagnosis'],
        };
      }
    } catch (e) {
      debugPrint('Error fetching patient details: $e');
    }
    return null;
  }

  /// Show Patient Form with integrated search field
  void showPatientForm(BuildContext context) {
    final nameController = TextEditingController();
    final ageController = TextEditingController();
    final diagnosisController = TextEditingController();
    String? selectedPatient;

    void filterSearchResults(String query) {
      setState(() {
        filteredPatients = allPatients
            .where((patient) =>
                patient.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Patient Form"),
          backgroundColor: Theme.of(context).colorScheme.surface,
          content: StatefulBuilder(
            builder: (context, setDialogState) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search Field
                    TextField(
                      controller: nameController,
                      onChanged: (value) {
                        setDialogState(() {
                          filterSearchResults(value);
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Search Patient',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                      ),
                    ),

                    // Dropdown Button for suggestions
                    if (filteredPatients.isNotEmpty)
                      DropdownButton<String>(
                        value: selectedPatient,
                        isExpanded: true,
                        underline: Container(),
                        hint: const Text("Select Patient"),
                        items: filteredPatients.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) async {
                          setDialogState(() {
                            selectedPatient = newValue;
                            nameController.text = newValue!;
                          });

                          // Fetch and autofill patient details
                          Map<String, dynamic>? patientData =
                              await getPatientDetails(newValue!);
                          if (patientData != null) {
                            setDialogState(() {
                              ageController.text =
                                  patientData['age'].toString();
                              diagnosisController.text =
                                  patientData['diagnosis'];
                            });
                          }
                        },
                      ),

                    const SizedBox(height: 10),

                    // Age Field
                    TextField(
                      controller: ageController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Age',
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Diagnosis Field
                    TextField(
                      controller: diagnosisController,
                      decoration: const InputDecoration(
                        labelText: 'Diagnosis',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
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
                debugPrint(
                    'Name: ${nameController.text}, Age: ${ageController.text}, Diagnosis: ${diagnosisController.text}');
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
                "$diagnosis",
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
