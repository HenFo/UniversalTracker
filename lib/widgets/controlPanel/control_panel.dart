import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:universal_tracker/base_map.dart';
import 'package:universal_tracker/recorder.dart';

import 'recording_controller.dart';
import 'tracking_data_page.dart';

class ControlPanel extends StatelessWidget {
  const ControlPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (BuildContext context) => Recorder(),
        builder: (BuildContext context, Widget? child) {
          Recorder recorder = Provider.of<Recorder>(context);
          return PageView(children: [
            RecordingController(
              onPauseTap: () {
                recorder.pauseRecording();
              },
              onResumeTap: () {
                recorder.resumeRecording();
              },
              onRecordTap: () {
                recorder.startRecording();
              },
              onStopTap: () {
                recorder.stopRecording();
              },
            ),
            const TrackingDataPage()
          ]);
        });
  }
}
