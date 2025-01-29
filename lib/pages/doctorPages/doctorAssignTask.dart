import 'package:flutter/material.dart';

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
  // You can manage additional state like task assignments here.
  String taskDescription = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assign Task to ${widget.name}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Patient Name: ${widget.name}',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              'UID: ${widget.uid}',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Index: ${widget.index}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            // Task description input field
            TextField(
              onChanged: (text) {
                setState(() {
                  taskDescription = text; // Update task description
                });
              },
              decoration: InputDecoration(
                labelText: 'Task Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Logic to assign the task can be implemented here
                // For now, it prints the task description
                print('Task assigned to ${widget.name}: $taskDescription');
              },
              child: Text('Assign Task'),
            ),
          ],
        ),
      ),
    );
  }
}
