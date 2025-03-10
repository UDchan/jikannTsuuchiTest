import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ProgressScreen extends StatefulWidget {
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;

  ProgressScreen({this.startTime, this.endTime});

  @override
  _ProgressScreenState createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  late Timer timer;
  double progress = 0.0;
  String progressText = "";
  String remainingText = "";
  String currentTime = "";

  @override
  void initState() {
    super.initState();
    _updateTime();
    timer = Timer.periodic(Duration(minutes: 1), (Timer t) => _updateTime()); // 1分ごとに更新
  }

  void _updateTime() {
    DateTime now = DateTime.now();

    // 0埋めして「18:03」形式にする
    String formattedHour = now.hour.toString().padLeft(2, '0');
    String formattedMinute = now.minute.toString().padLeft(2, '0');
    setState(() {
      currentTime = "$formattedHour:$formattedMinute";
    });

    if (widget.startTime == null || widget.endTime == null) {
      setState(() {
        progress = 0.0;
        progressText = "開始時間と終了時間を設定してください";
        remainingText = "";
      });
      return;
    }

    DateTime startDateTime = DateTime(
        now.year, now.month, now.day, widget.startTime!.hour, widget.startTime!.minute);
    DateTime endDateTime = DateTime(
        now.year, now.month, now.day, widget.endTime!.hour, widget.endTime!.minute);

    if (now.isBefore(startDateTime)) {
      setState(() {
        progress = 0.0;
        progressText = "自由時間はまだ始まっていません";
        remainingText = "";
      });
    } else if (now.isAfter(endDateTime)) {
      setState(() {
        progress = 1.0;
        progressText = "自由時間が終了しました";
        remainingText = "残り時間: 0時間0分（0%）";
      });
    } else {
      Duration totalDuration = endDateTime.difference(startDateTime);
      Duration remainingDuration = endDateTime.difference(now);
      double progressPercentage = 1 - (remainingDuration.inSeconds / totalDuration.inSeconds);
      double remainingPercentage = 100 - (progressPercentage * 100);

      setState(() {
        progress = progressPercentage;
        progressText =
        "経過時間: ${(totalDuration.inMinutes - remainingDuration.inMinutes) ~/ 60}時間"
            "${(totalDuration.inMinutes - remainingDuration.inMinutes) % 60}分（${(progressPercentage * 100).toStringAsFixed(1)}%）";
        remainingText =
        "残り時間: ${remainingDuration.inHours}時間${remainingDuration.inMinutes % 60}分（${remainingPercentage.toStringAsFixed(1)}%）";
      });
    }
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("現在時")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("現在時刻: $currentTime", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text(progressText, textAlign: TextAlign.center, style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text(remainingText, textAlign: TextAlign.center, style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            _buildPieChart(),
          ],
        ),
      ),
    );
  }

  Widget _buildPieChart() {
    return SizedBox(
      height: 250,
      child: PieChart(
        PieChartData(
          sections: [
            PieChartSectionData(
              value: progress * 100,
              title: "${(progress * 100).toStringAsFixed(1)}%",
              color: Colors.blue,
              radius: 100,
              titleStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            PieChartSectionData(
              value: (1 - progress) * 100,
              title: "${((1 - progress) * 100).toStringAsFixed(1)}%",
              color: Colors.grey.shade300,
              radius: 100,
              titleStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ],
          sectionsSpace: 0,
          centerSpaceRadius: 0,
          startDegreeOffset: -90,
        ),
      ),
    );
  }
}