import 'dart:math';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class StockProvider with ChangeNotifier {
  final TextEditingController cCode = TextEditingController();
  final TextEditingController cQty = TextEditingController();
  final TextEditingController cOperator = TextEditingController();
  final TextEditingController cLocation = TextEditingController();
  FocusNode myFocusNode = FocusNode();

  List masterData = [];

  void clsText() {
    cCode.clear();
    cQty.clear();
  }

  Future<String> getFilePath() async {
    Directory appDocumentsDirectory =
        await getApplicationDocumentsDirectory(); // 1
    String appDocumentsPath = appDocumentsDirectory.path; // 2
    String filePath = '$appDocumentsPath/demoTextFile.txt'; // 3
    return filePath;
  }

  void saveFile() async {
    File file = File(await getFilePath()); // 1
    for (var i = 0; i < masterData.length; i++) {}
    file.writeAsString('test to append\n', mode: FileMode.writeOnlyAppend); // 2
  }

  void readFile() async {
    File file = File(await getFilePath()); // 1
    String fileContent = await file.readAsString(); // 2

    print('File Content: $fileContent');
  }

  Future<bool> addData() async {
    masterData.add({
      'code': cCode.value.text,
      'qty': cQty.value.text,
    });
    debugPrint(masterData.length.toString());
    notifyListeners();
    return false;
  }

  Future<bool> exportData() async {
    Directory? directory;
    try {
      if (await _reqPermission(Permission.storage)) {
        directory = await getExternalStorageDirectory();
        String dirPath = directory!.path;
        String filePath = '$dirPath/abcd.txt';
        File file = File(filePath);
        for (var i = 0; i < masterData.length; i++) {
          await file.writeAsString(
              '${masterData[i]['code']},${masterData[i]['qty']}\n',
              mode: FileMode.writeOnlyAppend);
        }
        debugPrint(file.readAsStringSync());
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }

  Future<bool> _reqPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }

  Future<void> scanBarcodeCam() async {
    try {
      String barScan = await FlutterBarcodeScanner.scanBarcode(
          '#ff1a1a', 'Cancel', false, ScanMode.BARCODE);
      if (barScan != '-1') {
        cCode.text = barScan;
      }
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }
}
