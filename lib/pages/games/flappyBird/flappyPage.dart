import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:ableeasefinale/pages/decisionMaking_Page.dart';
import 'package:ableeasefinale/pages/games/flappyBird/barrier.dart';
import 'package:ableeasefinale/pages/games/flappyBird/bird.dart';
import 'package:ableeasefinale/resources/scores_methods.dart';
import 'package:flutter/material.dart';

import '../../remembering_page.dart';

class FlappyPage extends StatefulWidget {
  const FlappyPage({super.key});

  @override
  State<FlappyPage> createState() => _FlappyPageState();
}

class _FlappyPageState extends State<FlappyPage> {
  static double birdYaxis = 0;
  double initialHeight = birdYaxis;
  double height = 0;
  double time = 0;
  double gravity = -4.9;
  double velocity = 2.8;
  static double barrierXOne = 2;
  double barrierXTwo = barrierXOne + 2;
  late Timer _timer;
  static int score = 0;

  var scoreMethods = ScoreMethods();

  bool gameHasStarted = false;

  void startGame() {
    gameHasStarted = true;
    Timer.periodic(Duration(milliseconds: 60), (timer) {
      checkCollision();
      moveBarriers();
      time += 0.05;
      height = gravity * time * time + velocity * time;

      setState(() {
        birdYaxis = initialHeight - height;
        barrierXOne -= 0.05;
        barrierXTwo -= 0.05;
      });

      setState(() {
        if (barrierXOne < -2) {
          barrierXOne += 3.5;
        } else {
          barrierXOne += 0.05;
        }
      });

      setState(() {
        if (barrierXTwo < -2) {
          barrierXTwo += 3.5;
        } else {
          barrierXTwo += 0.05;
        }
      });

      if (birdYaxis > 1) {
        timer.cancel();
        gameHasStarted = false;
      }
      // moveMap();

      // time += 0.1;
    });
  }

  void moveBarriers() {
  setState(() {
    barrierXOne -= 0.05;
    barrierXTwo -= 0.05;
  });

  if (barrierXOne < -2) {
    barrierXOne = 2.0 + Random().nextInt(3); // Randomize barrier position
  }
  if (barrierXTwo < -2) {
    barrierXTwo = 2.0 + Random().nextInt(3); // Randomize barrier position
  }

  // Check if bird has passed the barriers
  if (barrierXOne < -0.2 && barrierXOne > -0.3) {
    setState(() {
      score++; // Increment score
    });
  }
  if (barrierXTwo < -0.2 && barrierXTwo > -0.3) {
    setState(() {
      score++; // Increment score
    });
  }
}


  void checkCollision() {
    // Check collision with barriers
    if ((barrierXOne >= -0.2 && barrierXOne <= 0.2) &&
        (birdYaxis <= -0.3 || birdYaxis >= 0.3)) {
      endGame();
    }

    // Check collision with top and bottom of the screen
    if (birdYaxis <= -1 || birdYaxis >= 1) {
      endGame();
    }
  }

  void endGame() async {
    // Cancel any existing timers

    // Create a new timer for showing the dialog
    _timer = Timer.periodic(Duration(milliseconds: 100), (timer) async {
      timer.cancel();

      sleep(Duration(seconds: 1));

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.brown,
            title: Center(
              child: Text(
                "Game Over",
                style: TextStyle(color: Colors.white),
              ),
            ),
            actions: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  setState(() {
                    birdYaxis = 0;
                    gameHasStarted = false;
                    time = 0;
                    initialHeight = birdYaxis;
                    barrierXOne = 2;
                    barrierXTwo = barrierXOne + 2;
                  });
                  startGame(); // Start the game again
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    padding: EdgeInsets.all(7),
                    color: Colors.white,
                    child: Text(
                      'Try Again',
                      style: TextStyle(color: Colors.brown),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    birdYaxis = 0;
                    gameHasStarted = false;
                    time = 0;
                    initialHeight = birdYaxis;
                    barrierXOne = 2;
                    barrierXTwo = barrierXOne + 2;
                  });
                  
                  Navigator.pop(context);
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    padding: EdgeInsets.all(7),
                    color: Colors.white,
                    child: Text(
                      'Quit',
                      style: TextStyle(color: Colors.brown),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      );

      // if (res == "success") {
      // setState(() {
      //   print("Data Added");
      // });
      // }
    });
    await scoreMethods.addUserScores(
        score: score, gameCategory: 'decison_making', gameName: 'flappy_bird');
    scoreMethods.updatePreviousGame("Flappy Bird", 'assets/images/bird.png');
  }

  void jump() {
    setState(() {
      time = 0;
      initialHeight = birdYaxis;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (gameHasStarted) {
          jump();
        } else {
          startGame();
        }
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
          ),
          elevation: 0,
        ),
        body: Column(children: [
          Expanded(
              flex: 2,
              child: Stack(
                children: [
                  AnimatedContainer(
                    alignment: Alignment(0, birdYaxis),
                    duration: Duration(milliseconds: 0),
                    color: Colors.blue,
                    child: MyBird(),
                  ),
                  Container(
                    alignment: Alignment(0, -0.5),
                    child: gameHasStarted
                        ? Text(" ")
                        : Text(
                            "T A P  T O  P L A Y",
                            style: TextStyle(fontSize: 30, color: Colors.white),
                          ),
                  ),
                  AnimatedContainer(
                      alignment: Alignment(barrierXOne, 1.1),
                      duration: Duration(milliseconds: 0),
                      child: MyBarrier(
                        size: 200.0,
                      )),
                  AnimatedContainer(
                      alignment: Alignment(barrierXOne, -1.1),
                      duration: Duration(milliseconds: 0),
                      child: MyBarrier(
                        size: 200.0,
                      )),
                  AnimatedContainer(
                      alignment: Alignment(barrierXTwo, 1.1),
                      duration: Duration(milliseconds: 0),
                      child: MyBarrier(
                        size: 150.0,
                      )),
                  AnimatedContainer(
                      alignment: Alignment(barrierXTwo, -1.1),
                      duration: Duration(milliseconds: 0),
                      child: MyBarrier(
                        size: 250.0,
                      )),
                ],
              )),
          Container(
            height: 15,
            color: Colors.green,
          ),
          Expanded(
            child: Container(
              color: Colors.brown,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Score",
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                      SizedBox(
                        height: 20,
                      ),
                      Text("0",
                          style: TextStyle(color: Colors.white, fontSize: 35)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
