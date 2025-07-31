import 'package:flutter/material.dart';

class ConfirmationPage extends StatelessWidget {
  final Map<String, dynamic> extractedData;

  const ConfirmationPage({super.key, required this.extractedData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Confirm Your Details')),
      body: Center(
        child: Column(
          children: [
            Text('Name: ${extractedData['name']}'),
            Text('Surname: ${extractedData['surname']}'),
            Text('GPA: ${extractedData['gpa']}'),
            if (extractedData['subjects'] != null && extractedData['subjects'] is List)
              Column(
                children: [
                  const Text('Subjects:'),
                  ... (extractedData['subjects'] as List).map((subject) => Text(
                    '- ${subject['name']}: Marks ${subject['marks']}, Level ${subject['level']}, Passed: ${subject['passed'] ? 'Yes' : 'No'}',
                  )).toList(),
                ],
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // This page is no longer responsible for confirming profile data.
                    // The data is saved directly on the complete profile page.
                    // This button can be removed or repurposed if needed.
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  child: const Text('Continue'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Go Back & Re-upload'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
