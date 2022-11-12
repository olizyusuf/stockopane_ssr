import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stockopname/provider/stock_provider.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    StockProvider stockProvider = Provider.of<StockProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Setting'),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Operator',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: stockProvider.cOperator,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter a operator name',
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Location',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: stockProvider.cLocation,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter you location',
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Reset! Careful'),
                            content: const Text(
                                'Are you sure to delete the data that has been taken?\nThis proses will delete all data.'),
                            actions: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context, true);
                                },
                                child: const Text('Yes'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context, false);
                                },
                                child: const Text(
                                  'No',
                                  style: TextStyle(color: Colors.red),
                                ),
                              )
                            ],
                          );
                        },
                      ).then((value) {
                        if (value) {
                          stockProvider.clsData();
                        }
                      });
                    },
                    child: const Text(
                      'Reset',
                      style: TextStyle(color: Colors.red),
                    )),
                ElevatedButton(
                    onPressed: () {
                      stockProvider.operatorName = stockProvider.cOperator.text;
                      stockProvider.locationName = stockProvider.cLocation.text;
                    },
                    child: const Text('Save')),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Export Data'),
                          content: const Text('are you sure export data?'),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context, true);
                              },
                              child: const Text('Export'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context, false);
                              },
                              child: const Text(
                                'No',
                                style: TextStyle(color: Colors.red),
                              ),
                            )
                          ],
                        );
                      },
                    ).then((value) {
                      if (value) {
                        if (stockProvider.cOperator.text.isNotEmpty &&
                            stockProvider.cLocation.text.isNotEmpty) {
                          stockProvider.exportData(stockProvider.operatorName,
                              stockProvider.locationName);
                        }
                      }
                    });
                  },
                  child: const Text('Export Data'),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Text('Last Export data at ${stockProvider.dateNow}'),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 50),
                alignment: Alignment.center,
                child: const Text(
                  'Developed by SabiruSky | github.com/olizyusuf',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
