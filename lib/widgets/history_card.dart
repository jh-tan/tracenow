import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class HistoryCard extends StatelessWidget {
  final String date, duration;
  final int index;
  const HistoryCard({
    Key? key,
    required this.date,
    required this.duration,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.grey,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Text(
              'Individual # ${index.toString()}',
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            SizedBox(height:1.h),
            const Divider(
              height: 2.0,
              thickness: 1.0,
              color: Colors.black,
            ),
            SizedBox(height: 1.h),
            Text(
              'Last Encounter date',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: (0.5).h),
            Text(
              date,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13.sp),
            ),
            SizedBox(height: (1).h),
            Text(
              'Total contact duration in the past 21 days',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
            Text(
              formatDuration(int.parse(duration)),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.sp),
            ),
            SizedBox(height: 1.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
            Text(
              'Risk: ',
              style: TextStyle(fontSize: 14.sp),
            ),
            Text(
              _calculateRisk(int.parse(duration)),
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
            )
              ],
            )
          ])),
    );
  }

    String formatDuration(int totalSeconds) {
    final duration = Duration(seconds: totalSeconds);
    final minutes = duration.inMinutes;
    final seconds = totalSeconds % 60;

    final minutesString = '$minutes'.padLeft(2, '0');
    final secondsString = '$seconds'.padLeft(2, '0');
    return '$minutesString min $secondsString sec';
  }


  String _calculateRisk(int seconds) {
    if (seconds <= 900) {
      return "Low Risk";
    } else if (seconds <= 1800) {
      return "Middle Risk";
    } else {
      return "High Risk";
    }
  }
}
