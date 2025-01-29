// ignore_for_file: file_names

import 'dart:async';

import 'package:ableeasefinale/pages/games/stackGame/myButton.dart';
import 'package:ableeasefinale/pages/games/stackGame/myPixel.dart';
import 'package:flutter/material.dart';

import '../../../resources/scores_methods.dart';

class StackGame extends StatefulWidget {
  const StackGame({super.key});

  @override
  State<StackGame> createState() => _StackGameState();
}

class _StackGameState extends State<StackGame> {
  int numberOfSquares = 120;
  List<int> piece = [];
  var direction = "left";
  List<int> landed = [100000];
  int level = 0;
  var scoreMethods= ScoreMethods();

  void startGame() {
    level = 0;
    piece = [];
    landed = [100000];

    int startTime = DateTime.now().millisecondsSinceEpoch;

    piece = [
      numberOfSquares - 3 - level * 10,
      numberOfSquares - 2 - level * 10,
      numberOfSquares - 1 - level * 10
    ];
    int speed = 250;

    Timer.periodic(Duration(milliseconds: speed), (timer) {
      if (checkWinner()) {
        int totalTime =
            (DateTime.now().millisecondsSinceEpoch - startTime) ~/ 1000;
        _showDialog(totalTime);
        timer.cancel();
      }

      if (piece.first % 10 == 0) {
        direction = "right";
      } else if (piece.last % 10 == 9) {
        direction = "left";
      }

      setState(() {
        if (direction == "right") {
          for (int i = 0; i < piece.length; i++) {
            piece[i] += 1;
          }
        } else {
          for (int i = 0; i < piece.length; i++) {
            piece[i] -= 1;
          }
        }
      });
    });
  }

  bool checkWinner() {
    if (landed.last < 10) {
      return true;
    } else {
      return false;
    }
  }

  void _showDialog(int totalTime) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Winner!", style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Total Time: $totalTime seconds"),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Close the dialog
                      startGame(); // Restart the game
                    },
                    child: Text('Restart', style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Close the dialog
                      Navigator.pop(context); // Go back
                    },
                    child: Text('Go Back', style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
    await scoreMethods.addUserScores( score: level, gameCategory: 'decison_making', gameName: 'stacking');
    scoreMethods.updatePreviousGame("Stacking", 'assets/images/StackerGame.png');
  }

  void stack() {
    setState(() {
      level++;
      for (int i = 0; i < piece.length; i++) {
        landed.add(piece[i]);
      }
      if (level < 6) {
        piece = [
          numberOfSquares - 3 - level * 10,
          numberOfSquares - 2 - level * 10,
          numberOfSquares - 1 - level * 10
        ];
      } else if (level >= 6 && level < 10) {
        piece = [
          numberOfSquares - 2 - level * 10,
          numberOfSquares - 1 - level * 10
        ];
      } else if (level >= 10) {
        piece = [numberOfSquares - 1 - level * 10];
      }
      checkStack();
    });
  }

  void checkStack() {
    for (int i = 0; i < landed.length; i++) {
      if (!landed.contains(landed[i] + 10) &&
          (landed[i] + 10) < numberOfSquares - 1) {
        landed.remove(landed[i]);
      }
    }

    for (int i = 0; i < landed.length; i++) {
      if (!landed.contains(landed[i] + 10) &&
          (landed[i] + 10) < numberOfSquares - 1) {
        landed.remove(landed[i]);
      }
    }
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: const Icon(Icons.arrow_back_ios_new_rounded),
      ),
      // backgroundColor: Theme.of(context).colorScheme.background,
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),
    backgroundColor: Theme.of(context).colorScheme.background,
    body: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: 6,
          child: GridView.builder(
            itemCount: 120,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 10,
            ),
            itemBuilder: (BuildContext context, int index) {
              if (piece.contains(index) || landed.contains(index)) {
                return MyPixel(
                  color: Theme.of(context).colorScheme.secondary,
                );
              } else {
                return MyPixel(
                  color: const Color.fromARGB(255, 23, 0, 27),
                );
              }
            },
          ),
        ),
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20,),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: MyButton(
                    function: startGame,
                    child: Text(
                      "S T A R T",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: MyButton(
                    function: stack,
                    child: Text("S T O P", style: TextStyle(fontSize: 20)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

}
