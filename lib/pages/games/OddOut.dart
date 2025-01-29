import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Oddout extends StatefulWidget {
  const Oddout({super.key});

  @override
  State<Oddout> createState() => _ColorGameState();
}

class _ColorGameState extends State<Oddout> {
  final rnd = Random.secure();
  late Color currentColor;
  late int currentBox;
  double currentOpacity = 0.1;
  int currentScore = 0;
  int topScore = 0;

  String status = 'START';
  String btnTitle = 'START';

  bool isPlay = false;

  int get RandomBox {
    return rnd.nextInt(9);
  }

  int get randomColorCode {
    return rnd.nextInt(255);
  }

  Color get randomColor {
    return Color.fromARGB(randomColorCode, randomColorCode, randomColorCode, 1);
  }

  void boxListener(int indexBox) {
    setState(() {
      if (indexBox == currentBox) {
        if (currentOpacity < 0.1) {
          currentOpacity = double.parse(
            (currentOpacity + 0.1).toStringAsFixed(1),
          );
        }

        currentScore++;
        if (currentScore > topScore) {
          topScore++;
        }
        updateBox();
      } else {
        currentScore = 0;
        status = 'GAME OVER';
        isPlay = false;
      }
    });
  }

  void updateBox() {
    currentColor = randomColor;
    currentBox = RandomBox;
  }

  void startListener() {
    setState(() {
      currentScore = 0;
      currentOpacity = 0.1;
      isPlay = true;
      status = 'PLAYING';
      btnTitle = 'RESTART';
      updateBox();
    });
  }

  @override
  void initState() {
    updateBox();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: Text("Color game")),
      body: Container(
        child: Column(
          children: [
            Container(
              height: size.height * 0.6,
              child: GridView.builder(
                itemCount: 9,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemBuilder: (context, index) => boxBuilder(
                  currentBox == index
                      ? currentColor.withOpacity(currentOpacity)
                      : currentColor,
                  index,
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              status,
              style: TextStyle(fontWeight: FontWeight.bold, height: 2),
            ),
            Text(
              'Top Scores: $topScore',
              style: TextStyle(fontWeight: FontWeight.bold, height: 2),
            ),
            Text(
              'Your Scores: $currentScore',
              style: TextStyle(fontWeight: FontWeight.bold, height: 2),
            ),
            ElevatedButton(
                onPressed: startListener,
                child: Text(btnTitle),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white))
          ],
        ),
      ),
    );
  }

  Widget boxBuilder(Color color, int indexBox) {
    return InkWell(
      onTap: isPlay ? () => boxListener(indexBox) : null,
      child: Container(
        decoration: BoxDecoration(
            color: color, border: Border.all(color: Colors.white)),
      ),
    );
  }
}
