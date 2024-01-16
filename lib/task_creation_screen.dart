// task_creation_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'task_list_notifier.dart';
import 'task_model.dart';

class TaskCreationScreen extends StatelessWidget {
    final Task? editingTask;

  // Constructor
  TaskCreationScreen({Key? key, this.editingTask}) : super(key: key);

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Task Title'),
            ),
            SizedBox(height: 16),
            DropdownButton<String>(
              hint: Text('Select Category'),
              value: _categoryController.text.isEmpty ? null : _categoryController.text, // Update this line
              onChanged: (String? newValue) {
                _categoryController.text = newValue ?? '';
              },
              items: <String>['Category 1', 'Category 2', 'Category 3']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
       ElevatedButton(
  onPressed: () async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        // Combine the picked date and time
        _selectedDate = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
      }
    }
  },
  child: Text('Select Deadline'),
),

            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final String title = _titleController.text;
                final String category = _categoryController.text;
                final DateTime? deadline = _selectedDate;

                if (title.isNotEmpty && category.isNotEmpty && deadline != null) {
                  Provider.of<TaskListNotifier>(context, listen: false)
                          .addTask(title, category, deadline ?? DateTime.now());

                  Navigator.pop(context);
                }
              },
              child: Text('Save Task'),
            ),
          ],
        ),
      ),
    );
  }
}
