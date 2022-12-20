import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stockopname/provider/license_provider.dart';

class LicenseScreen extends StatelessWidget {
  const LicenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('License')),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Consumer<LicenseProvider>(
          builder: (context, license, child) {
            return Column(
              children: [
                TextField(
                  controller: license.cMac,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'ID Device',
                  ),
                ),
                TextField(
                  controller: license.cSerialNum,
                  readOnly: license.isValidSn,
                  decoration: InputDecoration(
                    labelText: 'Serial Number',
                    errorText: license.isValidSn
                        ? 'Serial Number is Valid'
                        : 'serial number is Not valid',
                    suffixIcon: license.isValidSn
                        ? const Icon(
                            Icons.check_box,
                            color: Colors.green,
                          )
                        : const Icon(
                            Icons.cancel,
                            color: Colors.red,
                          ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    onPressed: () {
                      license.addSn();
                    },
                    child: const Text('Save'))
              ],
            );
          },
        ),
      ),
    );
  }
}
