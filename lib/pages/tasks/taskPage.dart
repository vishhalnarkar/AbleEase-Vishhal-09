import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:ableeasefinale/pages/games/OddOut.dart';
import 'package:ableeasefinale/pages/games/Testris%20Game/board.dart';
import 'package:ableeasefinale/pages/games/brickBreaker/brickHome.dart';
import 'package:ableeasefinale/pages/games/color_game_r.dart';
import 'package:ableeasefinale/pages/games/flappyBird/flappyPage.dart';
import 'package:ableeasefinale/pages/games/memory_game/memory_gameR.dart';
import 'package:ableeasefinale/pages/games/snakeGame/home_page.dart';
import '../eyeBlink_Game.dart';
import '../eyeExercise_Game.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  late String userUid;
  late String patientUid;
  late List<DocumentSnapshot> tasksList;

  List<String> games = [
    "Color Game",
    "Memory Game",
    "Tetris Game",
    "Flappy Bird",
    "Brick Breaker",
    "Snake Game",
    "Eye Exercise",
    "Blink Test",
    "Odd Color Out",
  ];

  @override
  void initState() {
    super.initState();
    tasksList = []; // Initialize tasksList
    getUserUid();
  }

  // Fetch the logged-in user's UID and PatientUid from Firestore
  Future<void> getUserUid() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userUid = user.uid;
      print("User UID: $userUid"); // Debugging line
      fetchPatientUid();
    } else {
      print("User not logged in.");
    }
  }

  // Fetch PatientUid from the users collection
  Future<void> fetchPatientUid() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Fetch the user document using the logged-in user's UID
    DocumentSnapshot userDoc = await firestore
        .collection('patient')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    if (userDoc.exists) {
      // Get the PatientUid from the user document
      patientUid = userDoc['PatientUid'];
      print("PatientUid: $patientUid"); // Debugging line

      // Now fetch tasks based on the PatientUid
      fetchTasks();
    } else {
      // Handle the case where the user document is not found
      print("User document not found.");
    }
  }

  // Fetch tasks assigned to the user from Firestore using PatientUid
  Future<void> fetchTasks() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Fetch tasks collection where the PatientUid matches the fetched PatientUid
    QuerySnapshot snapshot = await firestore
        .collection('tasks')
        .where('PatientUid', isEqualTo: patientUid)
        .get();

    print("Fetched tasks: ${snapshot.docs.length}"); // Debugging line

    setState(() {
      tasksList = snapshot.docs; // Assign the fetched documents to tasksList
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            leading: null,
            backgroundColor: Theme.of(context).colorScheme.secondary,
            bottom: const TabBar(tabs: [
              Tab(
                text: "Pending",
              ),
              Tab(
                text: "Completed",
              ),
            ]),
            title: const Center(
              child: Text(
                "All Tasks",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                ),
              ),
            ),
          ),
          body: TabBarView(children: [
            Container(
              color: Theme.of(context).colorScheme.surface,
              child: tasksList.isEmpty
                  ? const Center(
                      child: Text(
                          "No tasks available")) // Show message if no tasks
                  : ListView.builder(
                      itemCount: tasksList.length,
                      itemBuilder: (context, index) {
                        // Extract task details from Firestore data
                        var task = tasksList[index];
                        String gameName = task['GameName'];
                        // String assignedDate = task['assignedDate'];

                        // You can use the `games` list to find the correct pgSelector
                        int pgSelector = games.indexOf(gameName);

                        return gameCard(gameName, pgSelector, 'assignedDate');
                      },
                    ),
            ),
            Container(
              color: Colors.yellow,
            ),
          ]),
        ),
      ),
    );
  }

  Widget gameCard(String gName, int pgSelector, String assignedDate) {
    // Map game names to image assets
    Map<String, String> gameImages = {
      "Color Game": "assets/images/colorGamePic.png",
      "Memory Game": "assets/images/MemoryGamePic.png",
      "Tetris": "assets/images/tetris_game.png",
      "Flappy Bird": "assets/images/bird.png",
      "Brick Breaker": "assets/images/brickBreaker.png",
      "Snake Game": "assets/images/snake.png",
      "Eye Travel": "assets/images/eyeGame.png",
      "Blink Eyes": "assets/images/eye.png",
      "Odd one Out": "assets/images/oddOut.png",
    };

    return Container(
      height: 230, // Increased height for image
      margin: const EdgeInsets.only(top: 25, left: 20, right: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(63, 0, 0, 0),
            blurRadius: 4.0,
            spreadRadius: -2.0,
            offset: Offset(0.0, 8.0),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            // Display game image
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                gameImages[gName] ??
                    "assets/images/default.png", // Default if missing
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              gName,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 5),
            Divider(
              height: 5,
              color: Theme.of(context).colorScheme.onSecondary,
            ),
            Row(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => switch (pgSelector) {
                          0 => const ColorGameR(),
                          1 => const MemoryGame(),
                          2 => const GameBoard(),
                          3 => const FlappyPage(),
                          4 => const BrickHome(),
                          5 => const SnakeGame(),
                          6 => const EyeExercise(),
                          7 => const EyeBlink(),
                          8 => const Oddout(),
                          int() => throw UnimplementedError(),
                        },
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Text(
                        "Start",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Theme.of(context).colorScheme.secondary,
                        size: 16,
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Text(
                    assignedDate,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondary,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
