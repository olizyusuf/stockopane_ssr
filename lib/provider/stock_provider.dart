import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class StockProvider with ChangeNotifier {
  final TextEditingController cCode = TextEditingController();
  final TextEditingController cQty = TextEditingController();
  final TextEditingController cOperator = TextEditingController();
  final TextEditingController cLocation = TextEditingController();

  late String operatorName;
  late String locationName;
  bool isLoading = false;
  bool validateFill = false;
  String dateNow = ' ';

  FocusNode focusCode = FocusNode();
  FocusNode focusQty = FocusNode();

  List masterData = [];

  void clsText() {
    cCode.clear();
    cQty.clear();
    focusCode.requestFocus();
  }

  void clsData() {
    masterData.clear();
    cOperator.clear();
    cLocation.clear();
    notifyListeners();
  }

  void validate(bool validateText) {
    validateFill = validateText;
    notifyListeners();
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

  // void readFile() async {
  //   File file = File(await getFilePath()); // 1
  //   String fileContent = await file.readAsString(); // 2

  //   print('File Content: $fileContent');
  // }

  Future<bool> addData() async {
    masterData.add({
      'code': cCode.value.text,
      'qty': cQty.value.text,
    });
    notifyListeners();
    return false;
  }

  Future<bool> exportData(String operatorName, String location) async {
    Directory? directory;
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('ddMMyyyy-HH:mm').format(now);

    try {
      if (await _reqPermission(Permission.storage)) {
        directory = await getExternalStorageDirectory();
        String dirPath = directory!.path;
        String filePath =
            '$dirPath/${operatorName}_${location}_$formattedDate.txt';
        File file = File(filePath);
        for (var i = 0; i < masterData.length; i++) {
          await file.writeAsString(
              '${masterData[i]['code']},${masterData[i]['qty']}\n',
              mode: FileMode.writeOnlyAppend);
        }
        dateNow = '${operatorName}_${location}_$formattedDate.txt';
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    notifyListeners();
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
          '#ff1a1a', 'Cancel', true, ScanMode.BARCODE);
      if (barScan != '-1') {
        cCode.text = barScan;
        focusQty.requestFocus();
      }
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }
}
