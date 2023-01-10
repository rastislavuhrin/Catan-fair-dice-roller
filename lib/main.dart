import 'package:flutter/material.dart';
import 'dart:math';

const Color darkBlue = Color.fromARGB(255, 18, 32, 47);

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: darkBlue,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.green,
            title: Text("Catan fair dice roller")),
        body: Center(
          child: MyWidget(),
        ),
      ),
    );
  }
}

class MyWidget extends StatefulWidget {
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  int randomValue = 0;
  int mainIndex = 0;
  int seven = 0;
  var order = [1, 2, 3, 1, 2, 4, 1, 3, 5, 1, 2, 4, 1, 2, 3];
  var history = [];
  var rng = Random();

  void daco(int first, int second) {
    var tempRandomValue = 0;
    var countOfFirst = history.where((x) => x == first).length;
    var countOfSecond = history.where((x) => x == second).length;
    if (countOfFirst == countOfSecond) {
      tempRandomValue = rng.nextBool() ? first : second;
    }
    if (countOfFirst > countOfSecond) {
      tempRandomValue = second;
    } else {
      tempRandomValue = first;
    }
    setState(() {
      history.add(tempRandomValue);
      randomValue = tempRandomValue;
      mainIndex++;
      if (mainIndex == 15) mainIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'randomValue : $randomValue + history: $history',
            style: TextStyle(fontSize: 25),
          ),
          SizedBox(height: 15),
          ElevatedButton(
            onPressed: () {
              switch (order[mainIndex]) {
                case 1:
                  daco(6, 8);
                  break;
                case 2:
                  daco(5, 9);
                  break;
                case 3:
                  daco(4, 10);
                  break;
                case 4:
                  daco(3, 11);
                  break;
                case 5:
                  daco(2, 12);
                  break;
                default:
                  print("CHYBA");
              }
            },
            style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(color: Colors.white)),
            child: const Text('Hod kockou'),
          ),
          ElevatedButton(
              onPressed: () => {
                    setState(() {
                      history.clear();
                      mainIndex = 0;
                    }),
                  },
              child: Text('Delete history'))
        ],
      ),
    );
  }
}
