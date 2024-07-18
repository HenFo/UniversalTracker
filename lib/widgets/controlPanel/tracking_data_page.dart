import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:universal_tracker/recorder.dart';

class TrackingDataPage extends StatelessWidget {
  const TrackingDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Recorder>(
      builder: (BuildContext context, Recorder value, Widget? child) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // First text field
              _displayTrackingData(value.lastData.timestamp.toIso8601String()),
              const SizedBox(height: 20),
              _displayTrackingData(value.lastData.fullTime.toString()),
              const SizedBox(height: 20),
              _displayTrackingData("Tracking Data 3"),
            ],
          ),
        );
      },
    );
  }

  Container _displayTrackingData(String data) {
    return Container(
      height: 60,
      color: Colors.grey,
      child: Center(
        child: Text(
          data,
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}
