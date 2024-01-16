
class Task {
  static int _nextId = 1;

  int id ;
  final String title;
  final String category;
  int? priority; // Now priority can be updated after creation
  DateTime? deadline; // Now deadline is nullable
  bool isSelected; // New property to track selection

  Task({
    required this.title,
    required this.category,
    this.deadline,
  
    this.isSelected = false, // Default is not selected
  }): id = _nextId++;

  String formattedDeadline() {
    if (deadline != null) {
      return '${deadline!.day}-${deadline!.month}-${deadline!.year} ${deadline!.hour}:${deadline!.minute}:${deadline!.second}';
    } else {
      return 'No deadline';
    }
  }

  // Add a method to toggle selection
  void toggleSelection() {
    isSelected = !isSelected;
  }
}
