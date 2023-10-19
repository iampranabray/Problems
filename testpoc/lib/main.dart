import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Stocks',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Stocks'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final filename = 'assets/data.txt';

  List<Map<String, int>> value = [];
  Map<String, List<int>> stockSum = {};

  void getStatus() async {
    stockSum = {};
    value = [];
    await readFile();
    for (Map<String, int> entry in value) {
      for (var symbol in entry.keys) {
        if (stockSum.containsKey(symbol)) {
          stockSum[symbol] = [
            ((stockSum[symbol]?[0] ?? 0) + (entry[symbol] ?? 0)),
            (stockSum[symbol]?[1] ?? 0) + 1
          ];
        } else {
          stockSum[symbol] = [entry[symbol] ?? 0, 1];
        }
      }
    }
    setState(() {});
  }

  readFile() async {
    final file = await rootBundle.loadString(filename);
    final lines = file.split('\n');
    for (var line in lines) {
      final parts = line.split(',');
      value.add({parts[0]: int.tryParse(parts[1]) ?? 0});
    }
    //input file after reading
    // {"MSFT": 12},
    // {"GOOG": 1},
    // {"MSFT": 5},
    // {"MSFT": 8},
    // {"GOOG": 2345}
    debugPrint("$value");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have Stocks are Press Button:',
            ),
            for (var entry in stockSum.entries) ...[
              Text(
                "${entry.key},${entry.value[0]},${entry.value[1]}",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ]
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getStatus,
        tooltip: 'GetStocks',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
