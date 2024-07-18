import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class RecordingController extends StatefulWidget {
  final void Function() onRecordTap;
  final void Function() onStopTap;
  final void Function() onPauseTap;
  final void Function() onResumeTap;

  const RecordingController(
      {super.key,
      required this.onRecordTap,
      required this.onPauseTap,
      required this.onStopTap,
      required this.onResumeTap});

  @override
  State<RecordingController> createState() => _RecordingControllerState();
}

enum RecordButtonType { record, pause, stop, resume }

class _RecordingControllerState extends State<RecordingController>
    with AutomaticKeepAliveClientMixin<RecordingController> {
  bool recording = false;
  bool paused = false;
  bool permissionDenied = true;

  @override
  void didChangeDependencies() async {
    LocationPermission permission = await Geolocator.checkPermission();
    permissionDenied = permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    onRecordTap() async {
      if (permissionDenied) {
        showOnLocationPermissionDeniedPopup(context);
      } else {
        setState(() {
          recording = true;
          paused = false;
        });
        widget.onRecordTap();
      }
    }

    onStopTap() {
      setState(() {
        recording = false;
        paused = false;
      });
      widget.onStopTap();
    }

    onPauseTap() {
      setState(() {
        paused = true;
      });
      widget.onPauseTap();
    }

    onResumeTap() {
      setState(() {
        paused = false;
      });
      widget.onResumeTap();
    }

    Widget recordAndStop = recording
        ? _recordButtonFactory(RecordButtonType.stop,
            onTap: permissionDenied ? null : onStopTap)
        : _recordButtonFactory(RecordButtonType.record, onTap: onRecordTap);
    Widget pauseAndResume = paused
        ? _recordButtonFactory(RecordButtonType.resume, onTap: onResumeTap)
        : _recordButtonFactory(RecordButtonType.pause,
            onTap: recording ? onPauseTap : null);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [recordAndStop, pauseAndResume],
    );
  }

  Future<String?> showOnLocationPermissionDeniedPopup(BuildContext context) {
    return showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: const Text('No Location'),
              content: const Text('You denied location access'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, 'OK'),
                  child: const Text('OK'),
                ),
              ],
            ));
  }

  // Future<void> _getLocationPermission() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;

  //   // Test if location services are enabled.
  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     // Location services are not enabled don't continue
  //     // accessing the position and request users of the
  //     // App to enable the location services.
  //     return Future.error('Location services are disabled.');
  //   }

  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       // Permissions are denied, next time you could try
  //       // requesting permissions again (this is also where
  //       // Android's shouldShowRequestPermissionRationale
  //       // returned true. According to Android guidelines
  //       // your App should show an explanatory UI now.
  //       return Future.error('Location permissions are denied');
  //     }
  //   }

  //   if (permission == LocationPermission.deniedForever) {
  //     // Permissions are denied forever, handle appropriately.
  //     return Future.error(
  //         'Location permissions are permanently denied, we cannot request permissions.');
  //   }
  // }

  Widget _recordButtonFactory(RecordButtonType type, {void Function()? onTap}) {
    const double size = 128;

    switch (type) {
      case RecordButtonType.record:
        return _recordButton(
            icon: const Icon(
              Icons.fiber_manual_record,
              color: Colors.red,
              size: size,
            ),
            onTap: onTap);
      case RecordButtonType.pause:
        return _recordButton(
            icon: const Icon(
              Icons.pause,
              color: Colors.white,
              size: size,
            ),
            onTap: onTap);
      case RecordButtonType.stop:
        return _recordButton(
            icon: const Icon(
              Icons.stop,
              color: Colors.red,
              size: size,
            ),
            onTap: onTap);
      case RecordButtonType.resume:
        return _recordButton(
            icon: const Icon(
          Icons.play_arrow,
          color: Colors.white,
          size: size,
        ), onTap: onTap);
    }
  }

  Widget _recordButton({required Icon icon, void Function()? onTap}) {
    double size = 180;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 46, 46, 46),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Center(
        child: IconButton(
          icon: icon,
          onPressed: onTap,
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
