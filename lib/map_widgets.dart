import 'package:flutter/material.dart';

class MapButtons extends StatelessWidget {
  const MapButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const LocationButton(),
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
        }
      },
      icon:
          Icon(locationOn ? Icons.location_disabled : Icons.location_searching),
    );
  }
}
