import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorAssignPage extends StatefulWidget {
  final String name;
  final String uid;
  final int index;

  const DoctorAssignPage({
    required this.name,
    required this.uid,
    required this.index,
  });

  @override
  _DoctorAssignPageState createState() => _DoctorAssignPageState();
}

class _DoctorAssignPageState extends State<DoctorAssignPage> {
  String taskDescription = '';
  String? selectedGame;
  List<String> gamesList = [];
  String gameIds = '';
  String gameCategories = '';
  var gameDetails = [];

  @override
  void initState() {
    super.initState();
    fetchGamesList();
  }

  Future<void> fetchGameDetails() async {
    try {
      QuerySnapshot gamesSnapshot =
          await FirebaseFirestore.instance.collection('games').get();

      Map<String, Map<String, String>> fetchedGameDetails = {};

      for (var doc in gamesSnapshot.docs) {
        String gameName = doc['GameName'];
        gameIds = doc.id;
        gameCategories = doc['GameCategory'];

        fetchedGameDetails[gameName] = {
          'GameId': gameIds,
          'GameCategory': gameCategories,
        };
      }

      // Store the fetched data locally
      gameDetails = fetchedGameDetails as List;
      print('Game details fetched successfully: $gameDetails');
    } catch (e) {
      print('Error fetching game details: $e');
    }
  }

  // 🔹 Fetch games from Firestore
  Future<void> fetchGamesList() async {
    try {
      QuerySnapshot gamesSnapshot =
          await FirebaseFirestore.instance.collection('games').get();
      List<String> fetchedGames =
          gamesSnapshot.docs.map((doc) => doc['GameName'] as String).toList();
      setState(() {
        gamesList = fetchedGames;
      });
    } catch (e) {
      print('Error fetching games: $e');
    }
  }

  // 🔹 Assign task to Firestore
  Future<void> assignTask() async {
    if (selectedGame == null || taskDescription.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Please select a game and enter a task description')),
      );
      return;
    }

    try {
      // var gameDetails = fetchGameDetails();
      DocumentReference taskRef =
          await FirebaseFirestore.instance.collection('tasks').add({
        'PatientName': widget.name,
        'PatientUid': widget.uid,
        'GameName': selectedGame,
        'GameCategory': gameCategories,
        'GameId': gameIds,
        'task': taskDescription,
        'timestamp': FieldValue.serverTimestamp(),
      });

      await taskRef.update({'TaskId': taskRef.id});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Task assigned successfully!')),
      );

      Navigator.pop(context); // Close the page after assigning the task
    } catch (e) {
      print('Error assigning task: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assign Task to ${widget.name}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Patient Name: ${widget.name}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              'UID: ${widget.uid}',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            SizedBox(height: 20),

            // 🔹 Game selection dropdown
            DropdownButtonFormField<String>(
              value: selectedGame,
              hint: Text("Select a game"),
              items: gamesList.map((game) {
                return DropdownMenuItem<String>(
                  value: game,
                  child: Text(game),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedGame = newValue;
                });
              },
              decoration: InputDecoration(
                labelText: 'Game Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),

            // 🔹 Task description input
            TextField(
              onChanged: (text) {
                setState(() {
                  taskDescription = text;
                });
              },
              decoration: InputDecoration(
                labelText: 'Task Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            SizedBox(height: 20),

            // 🔹 Assign Task Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // fetchGameDetails();
                  assignTask();
                },
                child: Text(
                  'Assign Task',
                  style: TextStyle(color: Color(0xffEA3EF7)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
