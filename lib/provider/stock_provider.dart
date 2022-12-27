import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import '../model/stock.dart';

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

  final String dataBoxName = "stockDb";
  late Box<Stock> dataBox;

  List masterData = [];

  // singleton
  StockProvider._privateConst();
  static final StockProvider instance = StockProvider._privateConst();

  factory StockProvider() {
    return instance;
  }

  // CLEAR TEXT
  void clsText() {
    cCode.clear();
    cQty.clear();
    focusCode.requestFocus();
  }

  // CLEAR DATA
  void clsData() {
    dataBox.clear();
    cOperator.clear();
    cLocation.clear();
    notifyListeners();
  }

  // VALIDATE TEXTFIELD SETTING SCREEN
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

  // ADD DATA TO DATABASE HIVE
  Future<bool> addData() async {
    dataBox = await Hive.openBox<Stock>(dataBoxName);
    dataBox.add(Stock(cCode.value.text, int.parse(cQty.value.text)));
    notifyListeners();
    return false;
  }

  // ADD DATA TO TEMP VARIABLE
  // Future<bool> addData() async {
  //   masterData.add({
  //     'code': cCode.value.text,
  //     'qty': cQty.value.text,
  //   });
  //   notifyListeners();
  //   return false;
  // }

  // EXPORT FILE TO TXT LOCATION FOLDER AT INTERNAL ANDROID
  Future<bool> exportData(String operatorName, String location) async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('ddMMyyyy-HH:mm').format(now);
    dataBox = await Hive.openBox<Stock>(dataBoxName);

    try {
      if (await _reqPermission(Permission.storage)) {
        // Directory? directory = await getExternalStorageDirectory();
        Directory? directory = Directory('/storage/emulated/0/Download');
        if (await directory.exists()) {
          String dirPath = directory.path;
          String filePath =
              '$dirPath/${operatorName}_${location}_$formattedDate.txt';
          File file = File(filePath);
          for (var i = 0; i < dataBox.length; i++) {
            await file.writeAsString(
                '${dataBox.getAt(i)?.code},${dataBox.getAt(i)?.qty.toString()}\n',
                mode: FileMode.writeOnlyAppend);
          }
          dateNow = '${operatorName}_${location}_$formattedDate.txt';
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    notifyListeners();
    return false;
  }

  // PERMISSION ACCESS ANDROID DEVICES
  Future<bool> _reqPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result.isGranted) {
        return true;
      }
    }
    return false;
  }

  // SCAN BARCODE FROM CAMERA
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
