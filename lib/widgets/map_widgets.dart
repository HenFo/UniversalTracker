import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';

import '../utils/permission_functions.dart';

class MapButtons extends StatelessWidget {
  final MapController mapController;
  const MapButtons({
    super.key,
    required this.mapController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CompassButton(mapController: mapController),
            // const LocationButton(),
            IconButton.filled(
              onPressed: () {},
              icon: const Icon(Icons.question_mark),
            ),
          ],
        ),
      ),
    );
  }
}

class CompassButton extends StatefulWidget {
  final MapController mapController;

  const CompassButton({super.key, required this.mapController});

  @override
  State<CompassButton> createState() => _CompassButtonState();
}

class _CompassButtonState extends State<CompassButton> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MapEvent>(
        stream: widget.mapController.mapEventStream,
        builder: (context, snapshot) {
          return Transform.rotate(
              angle: snapshot.data?.camera.rotationRad ?? 0,
              child: IconButton.filled(
                onPressed: () => rotateNorth(widget.mapController),
                icon: const Icon(Icons.north),
              ));
        });
  }

  void rotateNorth(MapController mapController) {
    mapController.rotate(0);
  }
}

class LocationButton extends StatefulWidget {
  const LocationButton({super.key});

  @override
  State<LocationButton> createState() => _LocationButtonState();
}

class _LocationButtonState extends State<LocationButton> {
  bool locationOn = false;

  @override
  Widget build(BuildContext context) {
    return IconButton.filled(
      onPressed: () {
        // TODO aktuelle Position anzeigen
        if (locationOn) {
          setState(() {
            locationOn = false;
          });
        } else {
          setState(() {
            locationOn = true;
          });
          // getLocationPermission();
        }
      },
      icon:
          Icon(locationOn ? Icons.location_disabled : Icons.location_searching),
    );
  }
}
