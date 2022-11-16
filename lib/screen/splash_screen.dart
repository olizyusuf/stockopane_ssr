import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final String _version = 'v.0.0.1';
  final String _appName = 'github.com/olizyusuf';
  final int _splashDelay = 5;

  @override
  void initState() {
    super.initState();

    _loadWidget();
  }

  _loadWidget() async {
    var duration = Duration(seconds: _splashDelay);
    return Timer(duration, navigationPage);
  }

  void navigationPage() {
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InkWell(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Column(
              children: [
                Expanded(
                  flex: 7,
                  child: Container(
                      padding: const EdgeInsets.all(5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            width: 200,
                            height: 200,
                            child: Lottie.asset('assets/images/box-inven.json'),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 10.0),
                          ),
                          const Text(
                            'Stock Opname App',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          )
                        ],
                      )),
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      const CircularProgressIndicator(
                        color: Colors.blue,
                      ),
                      Container(
                        height: 10,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            const Spacer(),
                            Text(_version),
                            const Spacer(
                              flex: 4,
                            ),
                            Text(_appName),
                            const Spacer(),
                          ])
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
