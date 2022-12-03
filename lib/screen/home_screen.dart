import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:stockopname/provider/stock_provider.dart';

import '../model/stock.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    StockProvider stockProvider = Provider.of<StockProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Stock Opname'), actions: [
        IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/setting');
            },
            icon: const Icon(Icons.settings))
      ]),
      body: Container(
        padding: const EdgeInsets.only(right: 10, left: 10),
        child: Column(children: [
          WillPopScope(
            onWillPop: () async {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Are you sure you want to quit!?'),
                    content: const Text('please export or reset if finish'),
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
              ).then(
                (value) {
                  if (value) {
                    Future.delayed(
                      const Duration(milliseconds: 500),
                      () {
                        SystemNavigator.pop();
                      },
                    );
                  }
                },
              );
              return false;
            },
            child: Container(
              height: 190,
              padding: const EdgeInsets.only(left: 5, right: 5),
              child: Column(children: [
                TextField(
                  controller: stockProvider.cCode,
                  decoration: const InputDecoration(
                    labelText: 'Code',
                    hintText: 'type code here or use scan cam',
                  ),
                  textInputAction: TextInputAction.next,
                  focusNode: stockProvider.focusCode,
                  autofocus: true,
                ),
                TextField(
                  controller: stockProvider.cQty,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Qty'),
                  textInputAction: TextInputAction.go,
                  focusNode: stockProvider.focusQty,
                  autofocus: true,
                  onSubmitted: (value) async {
                    if (stockProvider.cCode.text.isNotEmpty &&
                        stockProvider.cQty.text.isNotEmpty) {
                      await stockProvider.addData();
                      stockProvider.clsText();
                      stockProvider.focusCode.requestFocus();
                    } else {
                      sDialog(context);
                    }
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          stockProvider.clsText();
                        },
                        child: const Text('Clear')),
                    IconButton(
                        onPressed: () {
                          stockProvider.scanBarcodeCam();
                        },
                        icon: const Icon(Icons.qr_code_scanner)),
                    ElevatedButton(
                        onPressed: () async {
                          if (stockProvider.cCode.text.isNotEmpty &&
                              stockProvider.cQty.text.isNotEmpty) {
                            await stockProvider.addData();
                            stockProvider.clsText();
                            stockProvider.focusCode.requestFocus();
                          } else {
                            sDialog(context);
                          }
                        },
                        child: const Text('Save Data')),
                  ],
                ),
              ]),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Barcode',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Text(
                'Qty',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          ),
          const Divider(
            thickness: 5,
          ),
          Expanded(
              child: FutureBuilder(
            future: Hive.openBox<Stock>(stockProvider.dataBoxName),
            builder: (context, AsyncSnapshot snapshot) {
              final getData = snapshot.data;
              if (snapshot.connectionState == ConnectionState.done &&
                  getData.length != 0) {
                return ListView.builder(
                  itemCount: getData.length,
                  itemBuilder: (context, index) {
                    var data = getData.getAt(index);
                    return SizedBox(
                      height: 25,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(data.code),
                            Text(data.qty.toString()),
                          ]),
                    );
                  },
                );
              } else {
                return const Center(
                  child: Text('data is empty'),
                );
              }
            },
          )),
          // Expanded(
          //   child: ListView.builder(
          //     itemCount: stockProvider.masterData.length,
          //     itemBuilder: (context, index) {
          //       var data = stockProvider.masterData[index];
          //       return SizedBox(
          //         height: 25,
          //         child: Row(
          //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //             children: [
          //               Text(data['code']),
          //               Text(data['qty']),
          //             ]),
          //       );
          //     },
          //   ),
          // ),
        ]),
      ),
    );
  }

  Future<dynamic> sDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return const SimpleDialog(
          contentPadding: EdgeInsets.all(10),
          alignment: Alignment.center,
          children: [Text('Code atau Qty masih kosong!')],
        );
      },
    );
  }
}
