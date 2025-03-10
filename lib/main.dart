import 'package:flutter/material.dart';
import 'package:ai_sakusei/schedule_screen.dart' as schedule;
import 'package:ai_sakusei/progress_screen.dart' as progress;
import 'package:ai_sakusei/notification_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '時間通知アプリ',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  int notificationInterval = 60; // デフォルトの通知間隔（60分）

  void _updateSchedule(TimeOfDay newStart, TimeOfDay newEnd) {
    setState(() {
      startTime = newStart;
      endTime = newEnd;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = [
      schedule.ScheduleScreen(
        startTime: startTime,
        endTime: endTime,
        onTimeSet: _updateSchedule,
      ),
      progress.ProgressScreen(
        startTime: startTime ?? TimeOfDay(hour: 0, minute: 0), // nullチェック
        endTime: endTime ?? TimeOfDay(hour: 23, minute: 59),  // nullチェック
      ),
      NotificationScreen(
        onIntervalSet: (interval) {
          setState(() {
            notificationInterval = interval;
          });
        },
      ),
    ];

    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.schedule), label: "スケジュール"),
          BottomNavigationBarItem(icon: Icon(Icons.access_time), label: "現在時"),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: "通知設定"),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}