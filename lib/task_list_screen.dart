import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'task_creation_screen.dart';
import 'task_list_notifier.dart';
import 'task_model.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart' as notifications;

class TaskListScreen extends StatelessWidget {
  final notifications.FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  late notifications.NotificationDetails platformChannelSpecifics;
  final BuildContext context;

  TaskListScreen({
    required this.flutterLocalNotificationsPlugin,
    required this.context,
  });

  Future<void> scheduleNotification(Task task, DateTime? scheduledDate) async {
    if (scheduledDate != null) {
      await flutterLocalNotificationsPlugin.schedule(
        task.id, // Use a unique ID for each task
        'Task Deadline Reached',
        task.title,
        scheduledDate,
        platformChannelSpecifics,
      );
    }
  }

  Future<void> cancelNotification(int notificationId) async {
    await flutterLocalNotificationsPlugin.cancel(notificationId);
  }

  // Function to check for due notifications
  Future<void> checkForDueNotifications() async {
    DateTime now = DateTime.now();

    // Replace this with your logic to fetch tasks with deadlines that have passed
    List<Task> tasksDue = fetchTasksDue( now);

    for (Task task in tasksDue) {
      await showNotificationForTask(task);
    }
  }

  // Function to show notification for a specific task
  Future<void> showNotificationForTask(Task task) async {
    const notifications.AndroidNotificationDetails androidPlatformChannelSpecifics =
        notifications.AndroidNotificationDetails(
      'your_channel_id', // Replace with your channel ID
      'your_channel_name', // Replace with your channel name
      channelDescription: 'your_channel_description', // Replace with your channel description
      importance: notifications.Importance.max,
      priority: notifications.Priority.high,
    );

    const notifications.NotificationDetails platformChannelSpecifics =
        notifications.NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      task.id, // Use a unique ID for each task
      'Task Deadline Reached',
      task.title,
      platformChannelSpecifics,
    );
  }

  // Function to fetch tasks with deadlines that have passed
  List<Task> fetchTasksDue(DateTime now) {
    List<Task> allTasks = Provider.of<TaskListNotifier>(widget.context).tasks;

    List<Task> tasksDue = allTasks
        .where((task) =>
            task.deadline != null && task.deadline!.isBefore(now))
        .toList();

    print(tasksDue);
    return tasksDue;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task List'),
      ),
      body: Consumer<TaskListNotifier>(
        builder: (context, taskList, child) {
          List<Task> allTasks = taskList.tasks;
          List<Task> selectedTasks = taskList.selectedTasks;
          List<Task> nonSelectedTasks = taskList.nonSelectedTasks;

          return ListView.builder(
            itemCount: allTasks.length,
            itemBuilder: (context, index) {
              Task task = index < selectedTasks.length
                  ? selectedTasks[index]
                  : nonSelectedTasks[index - selectedTasks.length];

              return ListTile(
                title: Text(
                  task.title,
                  style: TextStyle(
                    color: task.isSelected ? Colors.yellow : Colors.black,
                  ),
                ),
                subtitle: Text('Category: ${task.category}\nDeadline: ${task.formattedDeadline()}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () async {
                        Task? updatedTask = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TaskCreationScreen(editingTask: task),
                          ),
                        );

                        if (updatedTask != null) {
                          taskList.removeTask(task);
                          taskList.addTask(updatedTask.title, updatedTask.category, updatedTask.deadline);

                          // Schedule a notification when a task is edited
                          DateTime? taskDeadline = updatedTask.deadline;
                          if (taskDeadline != null) {
                            await scheduleNotification(updatedTask, taskDeadline);
                          }
                        }
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Delete Task'),
                              content: Text('Are you sure you want to delete this task?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    taskList.removeTask(task);

                                    // Cancel the notification when a task is deleted
                                    cancelNotification(task.id);

                                    Navigator.pop(context);
                                  },
                                  child: Text('Delete'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
                onTap: () {
                  taskList.toggleTaskSelection(task);
                },
              );
            },
          );
        },
      ),
      floatingActionButton: Consumer<TaskListNotifier>(
        builder: (context, taskList, child) {
          return FloatingActionButton(
            onPressed: () async {
              Task? updatedTask = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TaskCreationScreen(),
                ),
              );

              if (updatedTask != null) {
                taskList.addTask(updatedTask.title, updatedTask.category, updatedTask.deadline);

                DateTime? taskDeadline = updatedTask.deadline;
                if (taskDeadline != null) {
                  await scheduleNotification(updatedTask, taskDeadline);
                }
              }
            },
            child: Icon(Icons.add),
          );
        },
      ),
    );
  }
}
