import 'package:ableeasefinale/pages/doctorPages/doctorAssignTask.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorPatientView extends StatefulWidget {
  const DoctorPatientView({super.key});

  @override
  State<DoctorPatientView> createState() => _DoctorPatientViewState();
}

class _DoctorPatientViewState extends State<DoctorPatientView> {
  List<String> allPatients = []; // Store all patient names
  String? fetchedPatientId; // Nullable string
  List<Map<String, dynamic>> assignedPatients = []; // Store assigned patients
  Future<void> fetchAssignedPatients() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('doctors')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      if (snapshot.exists) {
        List<dynamic>? patients = snapshot['DoctorAssignedPatients'];

        if (patients != null) {
          print("Patients is not null");
          setState(() {
            assignedPatients = List<Map<String, dynamic>>.from(patients);
          });
        }
      }
    } catch (e) {
      debugPrint("Error fetching assigned patients: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchPatientNames();
    fetchAssignedPatients();
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

// FirebaseAuth.instance.currentUser!.uid

  /// Fetch patient details based on selected name
  Future<Map<String, dynamic>?> getPatientDetails(String name) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('patient')
          .where('PatientName', isEqualTo: name)
          .limit(1)
          .get();
      print("Got here somehow");
    } catch (e) {
      debugPrint('Error fetching patient details: $e');
    }
    return null;
  }

  /// Show Patient Form with dropdown
  void showPatientForm(BuildContext context) {
    String? selectedPatient;

    Future<String?> getPatientId() async {
      try {
        QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection('patient')
            .where('PatientName', isEqualTo: selectedPatient)
            .limit(1)
            .get();

        if (snapshot.docs.isNotEmpty) {
          return snapshot.docs.first.id; // Get the document ID
        } else {
          debugPrint("Patient not found");
          return null;
        }
      } catch (e) {
        debugPrint("Error getting patient ID: $e");
        return null;
      }
    }

    Future<void> fetchPatientId() async {
      fetchedPatientId = await getPatientId();
      print("Fetched Patient ID: $fetchedPatientId");
    }

    Future<Map<String, String>?> getDoctorDetails() async {
      try {
        DocumentSnapshot snapshot = await FirebaseFirestore.instance
            .collection('doctors')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get();

        if (snapshot.exists && snapshot.data() != null) {
          var data = snapshot.data() as Map<String, dynamic>;
          return {
            'id': snapshot.id, // Document ID
            'name':
                data['DoctorName'] ?? 'Unknown' // Doctor's Name from Firestore
          };
        } else {
          debugPrint("Doctor not found");
          return null;
        }
      } catch (e) {
        debugPrint("Error getting doctor details: $e");
        return null;
      }
    }

    Future<void> assignPatientData() async {
      Map<String, String>? doctorDetails = await getDoctorDetails();
      try {
        await FirebaseFirestore.instance
            .collection('patient')
            .doc(fetchedPatientId)
            .set(
                {
              'AssignedDoctorName': doctorDetails?['name'],
              'AssignedDoctorId': doctorDetails?['id'],
            },
                SetOptions(
                    merge:
                        true)); // Merges with existing data instead of overwriting
        print("Data assigned successfully");
      } catch (e) {
        print("Error assigning data: $e");
      }
    }

    Future<Map<String, dynamic>?> getPatientDetails() async {
      try {
        DocumentSnapshot snapshot = await FirebaseFirestore.instance
            .collection('patient') // Firestore collection
            .doc(fetchedPatientId) // Specific patient's document ID
            .get();

        if (snapshot.exists && snapshot.data() != null) {
          var data = snapshot.data() as Map<String, dynamic>;
          return {
            // Firestore Document ID
            'name': data['PatientName'] ?? '', // Patient's Name
            'PatientUid': data['PatientUid'] ?? '', // Patient's Name
          };
        } else {
          debugPrint("Patient not found");
          return null;
        }
      } catch (e) {
        debugPrint("Error getting patient details: $e");
        return null;
      }
    }

    Future<void> fetchAndUsePatientDetails() async {
      // String? patientId = fetchedPatientId; // Replace with actual patient ID

      Map<String, dynamic>? patientDetails = await getPatientDetails();

      if (patientDetails != null) {
        print("Patient Details: $patientDetails");

        try {
          await FirebaseFirestore.instance
              .collection('doctors')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .set(
                  {
                'DoctorAssignedPatients': FieldValue.arrayUnion([
                  {
                    'Patientname': patientDetails['name'],
                    'PatientUid': patientDetails['PatientUid'],
                    'PatientId': fetchedPatientId,
                  }
                ])
              },
                  SetOptions(
                      merge:
                          true)); // Merges with existing data instead of overwriting
          print("Data assigned successfully");
        } catch (e) {
          print("Error assigning data: $e");
        }
      }
    }

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
                        print("Now init patient Id");
                        selectedPatient = newValue;
                        fetchPatientId();
                        print(fetchedPatientId);
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
              child: const Text(
                'Cancel',
                style: TextStyle(color: Color(0xffEA3EF7)),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                getPatientId();
                getDoctorDetails();
                assignPatientData();
                getPatientDetails();
                setState(() {
                  fetchAndUsePatientDetails();
                });

                Navigator.of(context).pop();
              },
              child: const Text(
                'OK',
                style: TextStyle(color: Color(0xffEA3EF7)),
              ),
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
        leading: null,
        title: const Text('Patient View'),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
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
      body: assignedPatients.isEmpty
          ? const Center(
              child:
                  Text("Either Loading, or No data")) // Show loader if no data
          : ListView.builder(
              itemCount: assignedPatients.length,
              itemBuilder: (context, index) {
                var patient = assignedPatients[index];
                return patientTile(
                  patient['Patientname'] ?? "Unknown",
                  patient['PatientUid'] ?? "Unknown",
                  index,
                );
              },
            ),
    );
  }

  Widget patientTile(String name, String uid, int index) {
    return Padding(
      padding: const EdgeInsets.only(left: 17, right: 17, top: 17),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DoctorAssignPage(
                name: name,
                uid: uid,
                index: index,
              ),
            ),
          );
        },
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
                  "Uid: $uid",
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      removeAssignedPatient(index);
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> removeAssignedPatient(int index) async {
    try {
      // Reference to the doctor document in the Firestore collection
      DocumentReference doctorDoc = FirebaseFirestore.instance
          .collection('doctors')
          .doc(FirebaseAuth.instance.currentUser!.uid);

      // Fetch the current data from the doctor's document
      DocumentSnapshot doctorSnapshot = await doctorDoc.get();

      if (doctorSnapshot.exists) {
        // Get the 'DoctorAssignedPatients' array from the document
        List<dynamic> assignedPatients =
            doctorSnapshot.get('DoctorAssignedPatients');

        if (index >= 0 && index < assignedPatients.length) {
          // Remove the patient at the given index
          assignedPatients.removeAt(index);

          // Update the 'DoctorAssignedPatients' array with the modified list
          setState(() {
            doctorDoc.update({
              'DoctorAssignedPatients': assignedPatients,
            });
          });

          print('Patient removed successfully from the assigned list.');
        } else {
          print('Invalid index.');
        }
      } else {
        print('Doctor document not found.');
      }
    } catch (e) {
      print('Error removing patient: $e');
    }
  }
}
