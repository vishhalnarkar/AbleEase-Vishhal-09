import 'package:flutter/material.dart';

class Assignpage extends StatefulWidget {
  const Assignpage({super.key});

  @override
  State<Assignpage> createState() => _AssignPageState();
}

class _AssignPageState extends State<Assignpage> {
  List<String> games = [
    "",
    "",
    "",
    "",
  ];

  String? selectedGame; // Track the selected game
  final TextEditingController _noteController =
      TextEditingController(); // Controller for first TextField

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Assign Page"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity, // Ensures full width
              child: DropdownButtonFormField<String>(
                value: selectedGame,
                hint:
                    const Text("Select a Game"), // Placeholder before selection
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedGame = newValue;
                  });
                },
                items: games.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 10),
            Padding(padding: EdgeInsets.all(16.0)),
            const Text(
              "Note:",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _noteController,
              maxLines: 3, // Allows multiline input
              decoration: InputDecoration(
                hintText: "Enter your note here...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              ),
            ),
            const SizedBox(height: 20), // Add some spacing
            // Centered Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Add your button's functionality here
                  print("Selected Game: $selectedGame");
                  print("Note: ${_noteController.text}");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Submit",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
