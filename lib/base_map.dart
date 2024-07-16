import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:universal_tracker/animated_bottom_drawer.dart';
import 'package:universal_tracker/tile_providers.dart';

class BaseMap extends StatelessWidget {
  const BaseMap({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Test"),
        automaticallyImplyLeading: true,
      ),
      body: Stack(children: [
        FlutterMap(
            options: const MapOptions(
              initialCenter: LatLng(51, 7),
              interactionOptions: InteractionOptions(
                  rotationThreshold: 10, enableMultiFingerGestureRace: true),
            ),
            children: [openStreetMapTileLayer]),
        const AnimatedBottomDrawer(
            animationHeight: 0.5,
            maxDrawerHeight: 0.5,
            handleColor: Colors.amber,
            child: ControlPanel()),
      ]),
    );
  }
}

class ControlPanel extends StatelessWidget {
  const ControlPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: const BoxConstraints(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Left column with buttons
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _recordButtonFactory(RecordButtonType.record),
                  const SizedBox(
                    height: 20,
                  ),
                  _recordButtonFactory(RecordButtonType.pause),
                ],
              ),
              const SizedBox(width: 40),
              // Right column with text fields
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // First text field
                    _displayTrackingData("Tracking Data 1"),
                    const SizedBox(height: 20),
                    _displayTrackingData("Tracking Data 2"),
                    const SizedBox(height: 20),
                    _displayTrackingData("Tracking Data 3"),
                    
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
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

  Widget _recordButtonFactory(RecordButtonType type) {
    const double size = 42;

    switch (type) {
      case RecordButtonType.record:
        return _recordButton(
            icon: const Icon(
          Icons.fiber_manual_record,
          color: Colors.red,
          size: size,
        ));
      case RecordButtonType.pause:
        return _recordButton(
            icon: const Icon(
          Icons.pause,
          color: Colors.white,
          size: size,
        ));
      case RecordButtonType.stop:
        return _recordButton(
            icon: const Icon(
          Icons.stop,
          color: Colors.red,
          size: size,
        ));
    }
  }

  Widget _recordButton({required Icon icon}) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: IconButton(
          icon: icon,
          onPressed: () {
            // Handle record button press
          },
        ),
      ),
    );
  }
}

enum RecordButtonType { record, pause, stop }
