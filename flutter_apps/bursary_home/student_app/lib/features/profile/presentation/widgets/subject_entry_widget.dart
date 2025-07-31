import 'package:flutter/material.dart';
import 'package:data_layer/data_layer.dart';

class SubjectEntryWidget extends StatefulWidget {
  final int index;
  final Subject subject;
  final Function(int) onRemove;
  final ValueChanged<String> onSubjectNameChanged;
  final ValueChanged<int> onSubjectMarksChanged;

  const SubjectEntryWidget({
    super.key,
    required this.index,
    required this.subject,
    required this.onRemove,
    required this.onSubjectNameChanged,
    required this.onSubjectMarksChanged,
  });

  @override
  State<SubjectEntryWidget> createState() => _SubjectEntryWidgetState();
}

class _SubjectEntryWidgetState extends State<SubjectEntryWidget> {
  late TextEditingController _subjectNameController;
  late TextEditingController _marksController;
  late TextEditingController _levelController;

  @override
  void initState() {
    super.initState();
    _subjectNameController = TextEditingController(text: widget.subject.name);
    _marksController = TextEditingController(text: widget.subject.marks.toString());
    _levelController = TextEditingController(text: widget.subject.level);

    _marksController.addListener(_onMarksChanged);
  }

  @override
  void dispose() {
    _subjectNameController.dispose();
    _marksController.removeListener(_onMarksChanged);
    _marksController.dispose();
    _levelController.dispose();
    super.dispose();
  }

  void _onMarksChanged() {
    final marks = int.tryParse(_marksController.text) ?? 0;
    final level = _calculateLevel(marks);
    _levelController.text = level.toString();
    widget.onSubjectMarksChanged(marks); // Notify BLoC about marks change
  }

  int _calculateLevel(int marks) {
    if (marks >= 75) {
      return 7;
    } else if (marks >= 70) {
      return 6;
    } else if (marks >= 60) {
      return 5;
    } else if (marks >= 50) {
      return 4;
    } else if (marks >= 40) {
      return 3;
    } else if (marks >= 30) {
      return 2;
    } else {
      return 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _subjectNameController,
                  onChanged: widget.onSubjectNameChanged,
                  decoration: const InputDecoration(
                    labelText: 'Subject Name',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: 63,
                child: TextFormField(
                  controller: _marksController,
                  decoration: const InputDecoration(
                    labelText: 'Marks',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: 60,
                child: TextFormField(
                  controller: _levelController,
                  readOnly: true, // Level is auto-calculated
                  decoration: const InputDecoration(
                    labelText: 'Level',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => widget.onRemove(widget.index),
              child: const Text('Remove'),
            ),
          ),
        ],
      ),
    );
  }
}
