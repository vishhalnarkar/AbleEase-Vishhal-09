import 'package:ableeasefinale/resources/scores_methods.dart';
import 'package:flutter/material.dart';// Import the GameDetailsExtractor class

class PreviousGameBox extends StatelessWidget {
  const PreviousGameBox({Key? key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _fetchGameDetails(), // Call the function to fetch game details
      builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Show loading indicator while fetching data
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}'); // Show error message if data fetching fails
        } else if (snapshot.data == null || snapshot.data!.isEmpty) {
          return Text('Play your first game!'); // Display text if no data is found
        } else {
          String gameName = snapshot.data!['gameName'] ?? 'Unknown'; // Extract game name
          String gameImagePath = snapshot.data!['gameImagePath'] ?? 'assets/images/MemoryGamePic.png'; // Extract game image path

          return Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Theme.of(context).colorScheme.primary,
              ),
              width: MediaQuery.of(context).size.width / 2 - 25,
              height: 200,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      "Previous Exercise:",
                      style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Image(
                      image: AssetImage(gameImagePath), // Use game image path
                      width: 250,
                      height: 80,
                    ),
                  ),
                  Text(
                    gameName, // Use game name
                    style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Future<Map<String, dynamic>> _fetchGameDetails() async {
    GameDetailsExtractor gameDetailsExtractor = GameDetailsExtractor(); // Create an instance of GameDetailsExtractor
    String? gameName = await gameDetailsExtractor.getGameName(); // Fetch game name
    String? gameImagePath = await gameDetailsExtractor.getGameImagePath(); // Fetch game image path

    return {
      'gameName': gameName,
      'gameImagePath': gameImagePath,
    };
  }
}
