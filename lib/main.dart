import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'task_list_screen.dart';
import 'task_list_notifier.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart' as notifications;
late BuildContext initialContext;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final notifications.FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      notifications.FlutterLocalNotificationsPlugin();

  await initializeNotifications(flutterLocalNotificationsPlugin);

  late BuildContext initialContext;

  // Schedule a periodic timer to check for due notifications every minute
  Timer.periodic(Duration(minutes: 1), (Timer t) {
    checkForDueNotifications(flutterLocalNotificationsPlugin, initialContext);
  });

  runApp(MyApp(
    flutterLocalNotificationsPlugin: flutterLocalNotificationsPlugin,
    onContextReady: (context) {
      initialContext = context;
    },
  ));
}

Future<void> initializeNotifications(notifications.FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
  const notifications.AndroidInitializationSettings initializationSettingsAndroid =
      notifications.AndroidInitializationSettings('app_icon');

  final notifications.InitializationSettings initializationSettings =
      notifications.InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
  );
}

Future<void> checkForDueNotifications(notifications.FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin, BuildContext context) async {
  final now = DateTime.now();
  print("Checking for due notifications at: $now");
  TaskListScreen(
    flutterLocalNotificationsPlugin: flutterLocalNotificationsPlugin,
    context: context, // Pass the initialContext to TaskListScreen
  ).checkForDueNotifications();
}


class MyApp extends StatefulWidget {
  final notifications.FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final ValueSetter<BuildContext> onContextReady;

  MyApp({
    required this.flutterLocalNotificationsPlugin,
    required this.onContextReady,
  });

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  

  @override
  Widget build(BuildContext context) {
    widget.onContextReady(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<TaskListNotifier>(
          create: (context) => TaskListNotifier(),
        ),
        // Add other providers if needed
      ],
      child: MaterialApp(
        title: 'TimeMaster',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Builder(
          builder: (context) {
            initialContext = context; // Assign the context when the widget is built
            return TaskListScreen(
              flutterLocalNotificationsPlugin: widget.flutterLocalNotificationsPlugin,
              context: initialContext,
            );
          },
        ),
      ),
    );
  }
}

