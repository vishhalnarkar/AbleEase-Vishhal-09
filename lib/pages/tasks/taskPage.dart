import 'package:ableeasefinale/pages/games/OddOut.dart';
import 'package:ableeasefinale/pages/games/Testris%20Game/board.dart';
import 'package:ableeasefinale/pages/games/brickBreaker/brickHome.dart';
import 'package:ableeasefinale/pages/games/color_game_r.dart';
import 'package:ableeasefinale/pages/games/flappyBird/flappyPage.dart';
import 'package:ableeasefinale/pages/games/memory_game/memory_gameR.dart';
import 'package:ableeasefinale/pages/games/snakeGame/home_page.dart';
import 'package:ableeasefinale/pages/instructions/instr_color_game.dart';
import 'package:ableeasefinale/pages/instructions/instr_memory_game.dart';
import 'package:flutter/material.dart';

import '../eyeBlink_Game.dart';
import '../eyeExercise_Game.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  // Serever Data
  // User tasks
  // Game Name , Game image, assigned on

  @override
  Widget build(BuildContext context) {
    int x;
    List<String> assignedGame = [
      "Odd Color Out",
      "Tetris Game",
      "Blink Test",
      "Brick Breaker",
      "Memory Game",
      "Color Game",
      "Snake Game",
      "Flappy Bird",
      "Eye Exercise",
      "Snake Game",
    ];

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

    List<String> gameImagePaths = [
      "assets/images/colorGamePic.png",
      "assets/images/MemoryGamePic.png",
      "assets/images/tetris_game.png",
      "assets/images/bird.png",
      "assets/images/brickBreaker.png",
      "assets/images/snake.png",
      "assets/images/eye.png",
      "assets/images/eyeGame.png",
      "assets/images/OddOut.png",
    ];

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
                child: ListView(
                  children: [
                    for (int i = 0; i < games.length; i++)
                      gameCard(
                          gameImagePaths[games.indexOf(assignedGame[i])],
                          games[games.indexOf(assignedGame[i])],
                          games.indexOf(assignedGame[i]),
                          "13/01/2025"),
                    gameCard("assets/images/colorGamePic.png", "Color Game", 2,
                        "13/01/2025")

                    // for (int i = 0; i < games.length; i++)
                    //   gameCard(gameImagePaths[i], games[i], i, "13/01/2025"),
                  ],
                ),
              ),
              Container(
                color: Colors.yellow,
              )
            ]),
          )),
    );
  }

  Widget gameCard(
      String imgPath, String gName, int pgSelector, String assignedDate) {
    return Container(
      height: 203,
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
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 110,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      gName,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    color: Colors.white,
                    child: Image.asset(
                      imgPath,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
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
                          0 => const ColorGameR(), // Color Game
                          1 => const MemoryGame(), // Memory Game
                          2 => const GameBoard(), // Tetris Game
                          3 => const FlappyPage(), // Flappy Bird
                          4 => const BrickHome(), // Brick Breaker
                          5 => const SnakeGame(), // Snake Game
                          6 => const EyeExercise(), // Eye Exercise
                          7 => const EyeBlink(), // Blink Test
                          8 => const Oddout(), // Odd Color Out
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
                      )
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
