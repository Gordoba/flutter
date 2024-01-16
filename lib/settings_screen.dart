import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Pomodoro Duration'),
            subtitle: Text('Set the duration for each work session'),
          ),
          ListTile(
            title: Text('Break Duration'),
            subtitle: Text('Set the duration for breaks'),
          ),
        ],
      ),
    );
  }
}
