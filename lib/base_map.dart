import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:universal_tracker/animated_bottom_drawer.dart';
import 'package:universal_tracker/permission_functions.dart';
import 'package:universal_tracker/recorder.dart';
import 'package:universal_tracker/tile_providers.dart';

import 'map_widgets.dart';

class BaseMapWithTracker extends StatelessWidget {
  BaseMapWithTracker({super.key});

  final MapController _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    var theme = ThemeData.dark();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Test"),
        automaticallyImplyLeading: true,
      ),
      body: Stack(children: [
        BaseMap(mapController: _mapController),
        MapButtons(mapController: _mapController),
        AnimatedBottomDrawer(
            animationHeight: 0.5,
            maxDrawerHeight: 0.5,
            handleColor: theme.cardColor,
            color: theme.primaryColor,
            child: ControlPanel()),
      ]),
    );
  }
}

class BaseMap extends StatelessWidget {
  const BaseMap({
    super.key,
    required this.mapController,
  });

  final MapController mapController;

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
        mapController: mapController,
        options: const MapOptions(
          initialCenter: LatLng(51, 7),
          interactionOptions: InteractionOptions(
              rotationThreshold: 10, enableMultiFingerGestureRace: true),
        ),
        children: [
          openStreetMapTileLayer,
          CurrentLocationLayer(
            alignPositionOnUpdate: AlignOnUpdate.always,
          )
        ]);
  }
}

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

enum RecordButtonType { record, pause, stop }

class RecordingController extends StatefulWidget {
  final void Function() onRecordTap;
  final void Function() onPauseTap;
  final void Function() onStopTap;
  const RecordingController(
      {super.key,
      required this.onRecordTap,
      required this.onPauseTap,
      required this.onStopTap});

  @override
  State<RecordingController> createState() => _RecordingControllerState();
}

class _RecordingControllerState extends State<RecordingController> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _recordButtonFactory(RecordButtonType.record, onTap: () async {
          LocationPermission permission = await Geolocator.checkPermission();
          if (permission == LocationPermission.denied ||
              permission == LocationPermission.deniedForever) {
            showDialog(
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
          } else {
            widget.onRecordTap();
          }
        }),
        _recordButtonFactory(RecordButtonType.pause, onTap: widget.onPauseTap),
      ],
    );
  }

  Future<void> _getLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
  }

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
}
