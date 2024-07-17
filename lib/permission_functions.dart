import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

/// When the location services are not enabled or permissions
/// are denied the `Future` will return an error.
Future<void> getLocationPermission(BuildContext context) async {
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
      if (!context.mounted) return;
      showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: const Text('Permission denied'),
                content: const Text('App must have location permission'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      getLocationPermission(context);
                      Navigator.pop(context);
                    },
                    child: const Text('Give Permission'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Dismiss'),
                  ),
                ],
              ));
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    if (!context.mounted) return;
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: const Text('Permission denied'),
              content: const Text('App must have location permission'),
              actions: <Widget>[
                TextButton(
                  onPressed: () async {
                    if (await Geolocator.openAppSettings()) {
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Settings'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Dismiss'),
                ),
              ],
            ));
  }
}
