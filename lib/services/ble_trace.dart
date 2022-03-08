import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_beacon/flutter_beacon.dart' hide BeaconBroadcast;
import 'package:beacon_broadcast/beacon_broadcast.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tracenow/models/info.dart';
import 'package:tracenow/services/db.dart';

class TracingServices {
  final BeaconBroadcast beaconBroadcast = BeaconBroadcast();
  DatabaseHelper db = DatabaseHelper.instance;

  var deviceNumbers = ValueNotifier<int>(0);
  var regions = <Region>[];
  dynamic _streamRanging;
  bool _runningState = false;
  List<String> toRemove = [];
  List<Beacon> _rangingResult = [];
  final SplayTreeMap<String, int> _encounterList = SplayTreeMap<String, int>();

  void _startBroadcasting(String UserID) async {
    final BeaconStatus transmissionSupportStatus =
        await beaconBroadcast.checkTransmissionSupported();

    switch (transmissionSupportStatus) {
      // Good to go, can advertise as a beacon
      case BeaconStatus.supported:
        beaconBroadcast
            .setUUID(UserID)
            .setMajorId(1)
            .setMinorId(100)
            .setLayout('m:2-3=0215,i:4-19,i:20-21,i:22-23,p:24-24')
            .setManufacturerId(0x004c)
            .start();
        break;
      // Device doesn't support BLE
      case BeaconStatus.notSupportedBle:
        print("NOT supported");
        break;
      // Either chipset or driver is incompatible
      case BeaconStatus.notSupportedCannotGetAdvertiser:
        print("CANNOT GET ADVER");
        break;
      case BeaconStatus.notSupportedMinSdk:
        print("SDK ISSUE");
        break;
    }
  }

  void _startRanging() async {
    await flutterBeacon.initializeAndCheckScanning;
    // Android platform, it can ranging out of beacon that filter all of Proximity UUID
    if (Platform.isIOS) {
      // iOS platform, at least set identifier and proximityUUID for region scanning
      regions.add(Region(
          identifier: 'Apple Airlocate', proximityUUID: 'E2C56DB5-DFFB-48D2-B060-D0F5A71096E0'));
    } else {
      // android platform, it can ranging out of beacon that filter all of Proximity UUID
      regions.add(Region(identifier: 'com.beacon'));
    }

    // to start ranging beacons
    _streamRanging = flutterBeacon.ranging(regions).listen((RangingResult result) {
      //Getting the list from the ranging result, and add to another list
      //So, we can use that list to save the data in JSON / other similar type
      //to record other data
      print(result);
      result.beacons.forEach((beacon) async {
        String identifier = beacon.proximityUUID.toString().replaceAll('-', '');
        String currentDate = DateTime.now().toIso8601String().split("T")[0];

        _encounterList.putIfAbsent(
            identifier, () => (DateTime.now().millisecondsSinceEpoch / 1000).round());
        deviceNumbers.value = _encounterList.length;
      });

      if (_encounterHasChanges(_encounterList, result)) {
        for (String element in toRemove) {
          _encounterList.remove(element);
        }
        deviceNumbers.value = _encounterList.length;
        toRemove.clear();
      }
    });
  }

  void startService(String userID) {
    _startBroadcasting(userID);
    _startRanging();
  }

  void stopService() {
    beaconBroadcast.stop();
    getStreamRanging().cancel();
  }

  Future<String> checkStatus() async {
    bool permissionIsGranted = await Permission.location.isGranted;
    bool bluetoothIsOn = await FlutterBlue.instance.isOn;
    bool locationIsOn = await Permission.locationWhenInUse.serviceStatus.isEnabled;

    if (!permissionIsGranted) {
      await Permission.location.request();
      if (await Permission.location.isDenied) return "Please allow the permission for Location";
    }

    if (bluetoothIsOn && locationIsOn) {
      return "True";
    } else if (!locationIsOn && !bluetoothIsOn) {
      return "Please turn on your Location and Bluetooth";
    } else if (!bluetoothIsOn) {
      return "Please turn on your Bluetooth";
    } else if (!locationIsOn) {
      return "Please turn on your Location";
    }

    return "Your device may not support BLE";
  }

  Future isRunning() async {
    if (!_runningState) {
      await Future.delayed(const Duration(seconds: 1));

      bool? isAdvertising = await beaconBroadcast.isAdvertising();

      if (isAdvertising != null && _streamRanging != null && isAdvertising) {
        return _runningState = true;
      }
    }
    return _runningState = false;
  }

  bool _encounterHasChanges(SplayTreeMap<String, int> encounterList, RangingResult result) {
    bool noChanges = false;
    encounterList.forEach((key, value) async {
      for (var beacon in result.beacons) {
        String identifier = beacon.proximityUUID.toString().replaceAll("-", "");
        if (key == identifier) {
          noChanges = true;
          break;
        }
      }
      if (!noChanges) {
        toRemove.add(key);
        String encounterDate =
            DateTime.fromMillisecondsSinceEpoch(value * 1000).toIso8601String().split("T")[0];

        List<Info> dbInfo = await db.queryUser(key, encounterDate);
        int duration = (DateTime.now().millisecondsSinceEpoch / 1000).round() - value;

        if (dbInfo.isEmpty) {
          Info info = Info(uuid: key, date: encounterDate, duration: duration);
          debugPrint("First encounter , Duration: $duration ");
          await db.insert(info);
        } else {
          int newDuration = dbInfo.first.duration + duration;
          Info info = Info(uuid: key, date: encounterDate, duration: newDuration);
          debugPrint(
              "Update encounter , current duration $duration,  Updated duration: $newDuration");
          await db.update(info);
        }
      } else {
        noChanges = !noChanges;
      }
    });

    return toRemove.isNotEmpty;
  }

  ValueNotifier<int> getDevicesNum() {
    return deviceNumbers;
  }

  dynamic getStreamRanging() {
    return _streamRanging;
  }

  List<Beacon> getRangingResult() {
    return _rangingResult;
  }

  List getContactList() {
    return _encounterList.entries.map((entry) => entry.key).toList();
  }
}
