import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

class StockProvider with ChangeNotifier {
  final TextEditingController cCode = TextEditingController();
  final TextEditingController cQty = TextEditingController();
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
    file.writeAsString('test to append'); // 2
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
        await file.writeAsString('12345678,1');
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
}
