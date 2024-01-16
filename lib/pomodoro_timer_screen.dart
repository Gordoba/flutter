import 'package:flutter/material.dart';

class PomodoroTimerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pomodoro Timer'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('25:00', style: TextStyle(fontSize: 48)),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Implement logic to start/stop the timer
              },
              child: Text('Start Timer'),
            ),
          ],
        ),
      ),
    );
  }
}
