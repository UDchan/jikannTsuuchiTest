import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  final Function(int) onIntervalSet;

  NotificationScreen({required this.onIntervalSet});

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  int _selectedInterval = 60;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("通知設定")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
                "通知間隔: $_selectedInterval 分",
                style: TextStyle(fontSize: 20),),
            DropdownButton<int>(
              value: _selectedInterval,
              items: [15, 30, 60, 120].map((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text("$value 分"),
                );
              }).toList(),
              onChanged: (int? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedInterval = newValue;
                  });
                  widget.onIntervalSet(newValue);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}