import 'package:flutter/foundation.dart';
import 'task_model.dart';

class TaskListNotifier extends ChangeNotifier {
  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;


  // Other methods...

  // Add a method to get selected tasks
  List<Task> get selectedTasks => _tasks.where((task) => task.isSelected).toList();

  // Add a method to get non-selected tasks
  List<Task> get nonSelectedTasks => _tasks.where((task) => !task.isSelected).toList();

  // Sort tasks based on selection status
  void sortTasksBySelection() {
    _tasks.sort((a, b) => a.isSelected ? -1 : 1);
    notifyListeners();
  }

void updateTask(Task oldTask, String title, String category, DateTime? deadline) {
  // Find the index of the old task
  int index = _tasks.indexOf(oldTask);

  
    // Remove the old task
    removeTask(oldTask);

    // Add the updated task
    addTask(title, category, deadline);
    
    notifyListeners();
  
}


void addTask(String title, String category, DateTime? deadline) {
  if (deadline != null) {
    // Set the seconds to 0
    deadline = DateTime(deadline.year, deadline.month, deadline.day, deadline.hour, deadline.minute, 0);

    _tasks.add(Task(title: title, category: category, deadline: deadline));
    notifyListeners();
  }
}

void removeTask(Task task) {
  _tasks.remove(task);
  notifyListeners();
}
  void toggleTaskSelection(Task task) {
    int index = _tasks.indexOf(task);
    if (index != -1) {
      _tasks[index].toggleSelection();
      notifyListeners();
    }
  }

}
