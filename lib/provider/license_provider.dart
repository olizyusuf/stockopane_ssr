import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:device_uuid/device_uuid.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stockopname/model/license.dart';

class LicenseProvider with ChangeNotifier {
  String _platformVersion = 'unknown';
  final uuid = DeviceUuid().getUUID();
  String macAddressVal = '';
  String enkripsi = '';
  String idToSn = '';
  bool isValidSn = false;

  TextEditingController cMac = TextEditingController();
  TextEditingController cSerialNum = TextEditingController();

  final String dataBoxName = "licenseDb";
  late Box<License> dataBox;

  // init platform for collect mac address
  Future<void> initPlatformState() async {
    String uuid;
    dataBox = await Hive.openBox<License>(dataBoxName);
    try {
      uuid = await DeviceUuid().getUUID() ?? 'Unknown uuid version';
    } on PlatformException {
      uuid = 'Failed to get uuid version.';
    }

    // convert uuid
    _platformVersion = uuid.substring(0, 25);

    // check box
    if (dataBox.isEmpty) {
      addUuidToDb(_platformVersion, '');
    }

    // generate sn and cek validation
    idToSn = generateSn(_platformVersion);
    getData(idToSn);

    // encrype serial number
    enkripsi = md5.convert(utf8.encode(_platformVersion)).toString();
    cMac.text = _platformVersion;
  }

  void addUuidToDb(String idDevices, String sn) async {
    dataBox = await Hive.openBox<License>(dataBoxName);
    dataBox.add(License(idDevices, sn));
  }

  void getData(String sn) async {
    dataBox = await Hive.openBox<License>(dataBoxName);
    if (dataBox.getAt(0)!.serialNumber == sn) {
      isValidSn = true;
      cSerialNum.text = dataBox.getAt(0)!.serialNumber;
    } else {
      isValidSn = false;
      cSerialNum.text = '';
    }
  }

  // logic generate sn
  String generateSn(String macAddress) {
    String enkrip = md5.convert(utf8.encode(macAddress)).toString();
    String a = enkrip.substring(7, 10);
    String b = enkrip.substring(12, 15).toUpperCase();
    String c = enkrip.substring(2, 5);
    String d = enkrip.substring(20, 23).toUpperCase();
    String enkripMac = a + b + c + d;
    return enkripMac;
  }

  // simpan serial number
  void addSn() async {
    dataBox = await Hive.openBox<License>(dataBoxName);
    if (cMac.text.isNotEmpty && cSerialNum.text.isNotEmpty) {
      if (idToSn == cSerialNum.text) {
        dataBox.putAt(0, License(cMac.text, cSerialNum.text));
        isValidSn = true;
      } else {
        isValidSn = false;
      }
    }
    notifyListeners();
  }
}
