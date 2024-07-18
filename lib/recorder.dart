import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class TrackingData {
  final double longitude;
  final double latitude;
  final double altitude;
  final double speed;
  late final DateTime timestamp;
  final double maxSpeed;
  final double distance;
  final double heightDistance;
  final double averageSpeed;
  final Duration fullTime;
  final Duration driveTime;
  final Duration stillTime;

  TrackingData(
      {this.longitude = 0,
      this.latitude = 0,
      DateTime? timestamp,
      this.altitude = 0,
      this.speed = 0,
      this.distance = 0,
      this.heightDistance = 0,
      this.maxSpeed = 0,
      this.driveTime = Duration.zero,
      this.fullTime = Duration.zero,
      this.stillTime = Duration.zero,
      this.averageSpeed = 0}) {
    this.timestamp = timestamp ?? DateTime.now();
  }
}

class Recorder with ChangeNotifier {
  StreamSubscription<Position>? _positionStreamSubscription;
  List<TrackingData> _record = [];
  TrackingData get lastData => _data;
  TrackingData _data = TrackingData();

  bool get recording => this._positionStreamSubscription != null;
  bool get paused => this._positionStreamSubscription?.isPaused ?? false;

  void startRecording() {
    if (this.recording) return;

    double maxSpeed = 0;
    double averageSpeed = 0;
    double distance = 0;
    double heightDistance = 0;
    Duration fullTime = Duration.zero;
    Duration driveTime = Duration.zero;
    Duration stillTime = Duration.zero;

    DateTime? lastTimestamp;
    double? lastLng;
    double? lastLat;
    double? lastHeight;
    int step = 0;

    _positionStreamSubscription =
        Geolocator.getPositionStream().listen((event) {
      if (event.speed > maxSpeed) maxSpeed = event.speed;
      if (lastHeight != null) {
        heightDistance += (lastHeight! - event.altitude).abs();
      }

      double reachedDistance = 0;
      if (lastLat != null && lastLng != null && lastHeight != null) {
        double h = Geolocator.distanceBetween(
            lastLat!, lastLng!, event.latitude, event.longitude);
        double v = (lastHeight! - event.altitude).abs();
        reachedDistance = sqrt(h * h + v * v);
        distance += reachedDistance;
      }

      if (lastTimestamp != null) {
        var timediff = event.timestamp.difference(lastTimestamp!);
        fullTime += timediff;
        if (reachedDistance > 1) {
          driveTime += timediff;
        } else {
          stillTime += timediff;
        }
      }

      averageSpeed = ((averageSpeed * step++) + event.speed) / step;

      lastLat = event.latitude;
      lastLng = event.longitude;
      lastTimestamp = event.timestamp;
      lastHeight = event.altitude;
      var pd = TrackingData(
          longitude: event.longitude,
          latitude: event.latitude,
          timestamp: event.timestamp,
          altitude: event.altitude,
          speed: event.speed,
          distance: distance,
          heightDistance: heightDistance,
          maxSpeed: maxSpeed,
          driveTime: driveTime,
          fullTime: fullTime,
          stillTime: stillTime,
          averageSpeed: averageSpeed);
      _record.add(pd);

      _data = pd;
      notifyListeners();
    });
    notifyListeners();
  }

  void stopRecording() {
    this._positionStreamSubscription?.cancel().then((value) {
      // TODO record speichern
      _record = [];
      _positionStreamSubscription = null;
      notifyListeners();
    });
  }

  void pauseRecording() {
    this._positionStreamSubscription?.pause();
    notifyListeners();
  }

  void resumeRecording() {
    this._positionStreamSubscription?.resume();
    notifyListeners();
  }
}
