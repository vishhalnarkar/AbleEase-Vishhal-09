import 'package:ableeasefinale/pages/games/memory_game/memory_gameR.dart';
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
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 35),
      child: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              leading: null,
              bottom: const TabBar(tabs: [
                Tab(
                  text: "Pending",
                ),
                Tab(
                  text: "Completed",
                ),
              ]),
              title: const Text(
                "All Tasks",
                style: TextStyle(),
              ),
            ),
            body: TabBarView(children: [
              Container(
                color: Colors.green,
              ),
              Container(
                color: Colors.yellow,
              )
            ]),
          )),
    );
    //         gameCard("assets/images/eye.png", "Eye Exercise", "Level 1", 0,
    //             "EST: 30 sec"),
    //         gameCard("assets/images/eyeGame.png", "Blink Test    ", "Level 2", 1,
    //             "EST: 1 mins"),
    //         gameCard("assets/images/eyeGame.png", "Odd Color out", "Level 3", 2,
    //             "EST: 1 mins"),
    //       ],
    //     ),
    //   );
  }

  Widget gameCard(String imgPath, String gName, String lvl, int pgSelector,
      String estTime) {
    return Container(
      height: 200,
      margin: const EdgeInsets.only(top: 45, left: 35, right: 35),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(63, 0, 0, 0),
            blurRadius: 4.0,
            spreadRadius: -5.0,
            offset: Offset(0.0, 8.0),
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30, left: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      gName,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 22),
                    ),
                    Text(
                      lvl,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onSecondary,
                          fontSize: 13),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 50, top: 15, right: 15, bottom: 15),
                  child: Container(
                    height: 115,
                    width: 200,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Image.asset(imgPath, fit: BoxFit.cover),
                  ),
                ),
              ),
            ],
          ),
          Divider(
            height: 5,
            color: Theme.of(context).colorScheme.onSecondary,
          ),
          Row(
            children: [
              const SizedBox(width: 30), // Ensures proper alignment
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                    backgroundColor: Theme.of(context).colorScheme.background,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => switch (pgSelector) {
                          0 => const EyeExercise(),
                          1 => const EyeBlink(),
                          2 => const EyeBlink(),
                          // TODO: Handle this case.
                          int() => throw UnimplementedError(),
                        },
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Text("Start",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: 18,
                          )),
                      const SizedBox(width: 5),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Theme.of(context).colorScheme.secondary,
                        size: 18,
                      )
                    ],
                  )),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Text(
                  estTime,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondary),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
