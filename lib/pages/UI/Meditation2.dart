import 'package:ableeasefinale/pages/games/Testris%20Game/Board.dart';
import 'package:ableeasefinale/pages/games/flappyBird/flappyPage.dart';
import 'package:ableeasefinale/pages/games/stackGame/stack_gameD.dart';
import 'package:flutter/material.dart';

class Meditation2 extends StatefulWidget {
  const Meditation2({super.key});

  @override
  State<Meditation2> createState() => _MeditationPage();
}

class _MeditationPage extends State<Meditation2> {
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
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 0, top: 20, right: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "DO THIS 2 TIMES",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 40,
                  ),
                ),
                const SizedBox(height: 8), // Space between text and line
                Container(
                  width: double.infinity, // Full-width underline
                  height: 2, // Thickness of the underline
                  color: Theme.of(context)
                      .colorScheme
                      .onPrimary, // Color of the underline
                ),
              ],
            ),
          ),
          Container(
            height: 150,
            margin: const EdgeInsets.only(top: 40, left: 35, right: 35),
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
                      padding: const EdgeInsets.only(top: 10, left: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Meditation",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontSize: 28),
                          ),
                          Text(
                            "Desc: Do this 2 times",
                            style: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                                fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    const Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 50, top: 10),
                        child: Image(
                          image: AssetImage("assets/images/meditating.png"),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
