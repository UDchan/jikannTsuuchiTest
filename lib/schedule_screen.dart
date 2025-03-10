import 'package:flutter/material.dart';

class ScheduleScreen extends StatefulWidget {
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;
  final Function(TimeOfDay, TimeOfDay) onTimeSet;

  ScheduleScreen({required this.startTime, required this.endTime, required this.onTimeSet});

  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  @override
  void initState() {
    super.initState();
    _startTime = widget.startTime;
    _endTime = widget.endTime;
  }

  Future<void> _selectTime(bool isStartTime) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });

      if (_startTime != null && _endTime != null) {
        widget.onTimeSet(_startTime!, _endTime!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("スケジュール設定")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("開始時間: ${_startTime?.format(context) ?? "未設定"}"),
            ElevatedButton(onPressed: () => _selectTime(true), child: Text("開始時間を選択")),
            SizedBox(height: 20),
            Text("終了時間: ${_endTime?.format(context) ?? "未設定"}"),
            ElevatedButton(onPressed: () => _selectTime(false), child: Text("終了時間を選択")),
          ],
        ),
      ),
    );
  }
}