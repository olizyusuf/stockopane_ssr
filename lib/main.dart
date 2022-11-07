import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stockopname/provider/stock_provider.dart';
import 'package:stockopname/screen/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => StockProvider(),
        )
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Stock Opname',
        home: HomeScreen(),
      ),
    );
  }
}
