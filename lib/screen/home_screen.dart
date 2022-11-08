import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stockopname/provider/stock_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    StockProvider stockProvider = Provider.of<StockProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Stock Opname')),
      body: Container(
        padding: const EdgeInsets.only(right: 10, left: 10),
        child: Column(children: [
          Container(
            height: 200,
            padding: const EdgeInsets.all(10),
            child: Column(children: [
              TextField(
                controller: stockProvider.cCode,
                decoration: InputDecoration(
                    labelText: 'Code',
                    hintText: 'type code here or use scan cam',
                    suffixIcon: IconButton(
                      onPressed: () {
                        stockProvider.scanBarcodeCam();
                      },
                      icon: const Icon(Icons.qr_code_scanner),
                    )),
                textInputAction: TextInputAction.next,
                focusNode: stockProvider.myFocusNode,
              ),
              TextField(
                controller: stockProvider.cQty,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Qty'),
                textInputAction: TextInputAction.go,
                onSubmitted: (value) {
                  if (stockProvider.cCode.text.isNotEmpty &&
                      stockProvider.cQty.text.isNotEmpty) {
                    stockProvider.addData();
                    stockProvider.clsText();
                    stockProvider.myFocusNode.requestFocus();
                  } else {
                    debugPrint('tidak boleh kosong');
                  }
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        stockProvider.clsText();
                      },
                      child: Text('Clear')),
                  ElevatedButton(
                      onPressed: () {
                        if (stockProvider.cCode.text.isNotEmpty &&
                            stockProvider.cQty.text.isNotEmpty) {
                          stockProvider.addData();
                          stockProvider.clsText();
                          stockProvider.myFocusNode.requestFocus();
                        } else {
                          debugPrint('tidak boleh kosong');
                        }
                      },
                      child: Text('Simpan Data')),
                ],
              ),
            ]),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: stockProvider.masterData.length,
              itemBuilder: (context, index) {
                var data = stockProvider.masterData[index];
                return SizedBox(
                  height: 25,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(data['code']),
                        Text('Qty:     ${data['qty']}'),
                      ]),
                );
              },
            ),
          ),
        ]),
      ),
    );
  }
}
