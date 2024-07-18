import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';
import 'package:universal_tracker/widgets/animated_bottom_drawer.dart';
import 'package:universal_tracker/utils/tile_providers.dart';

import 'widgets/controlPanel/control_panel.dart';
import 'widgets/map_widgets.dart';

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
          // CurrentLocationLayer(
          //   alignPositionOnUpdate: AlignOnUpdate.always,
          //   focalPoint: const FocalPoint(ratio: Point(0, -0.3)),
          // )
        ]);
  }
}
