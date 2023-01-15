import 'package:flutter/material.dart';
import 'dart:math';
import 'package:provider/provider.dart';

const Color darkBlue = Color.fromARGB(255, 18, 32, 47);

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppState(),
      child: MaterialApp(
        title: _title,
        home: AppBase(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class AppState extends ChangeNotifier {
  var history = [];
  int randomValue = 0;
  int mainIndex = 0;
  int seven = 0;
  List<int> nextRoundSevens = [];

  void newGame() {
    history.clear();
    mainIndex = 0;
    randomValue = 0;
    notifyListeners();
  }
}

class AppBase extends StatefulWidget {
  @override
  State<AppBase> createState() => AppBaseState();
}

class AppBaseState extends State<AppBase> {
  int _selectedIndex = 0;
  List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    HistoryPage(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    showAlertDialog(BuildContext context) {
      // Create button
      Widget cancelButton = TextButton(
        child: Text(
          "nie",
          style: TextStyle(color: Colors.red),
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      );
      Widget okButton = TextButton(
        child: Text(
          "ano",
          style: TextStyle(fontSize: 20),
        ),
        onPressed: () {
          appState.newGame();
          Navigator.of(context).pop();
        },
      );
      // Create AlertDialog
      AlertDialog alert = AlertDialog(
        title: Text("Naozaj chcete vymazat staru hru a spustit novu?"),
        actions: [
          cancelButton,
          okButton,
        ],
      );

      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }

    void handleClick(String value) {
      switch (value) {
        case 'Zvol pocet hracov':
          print("preslo1");
          break;
        case 'Nova hra':
          showAlertDialog(context);
          print("preslo222");
          break;
      }
    }

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.green,
          actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: handleClick,
              itemBuilder: (BuildContext context) {
                return {'Zvol pocet hracov', 'Nova hra'}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ],
          title: Text("Catan fair dice roller")),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var halfOrder = [1, 2, 3, 1, 2, 4, 1, 3, 5, 1, 2, 4, 1, 2, 3];
  var order = [];
  var newOrder = [];
  var rng = Random();
  _HomePageState() {
    order = [...halfOrder, ...halfOrder];
  }
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    // var sevens = [];
    // var players = 3;

    void generateNextNumber(int first, int second) {
      if (appState.mainIndex == 0) {
        order = [...halfOrder, ...halfOrder];
        var sevensPoolForThree = [1, 1, 2, 2, 3, 3];
        sevensPoolForThree.shuffle();
        print('sevensPoolForThree $sevensPoolForThree');

        // sevens = [];
        // var pool = [];
        var sevenCyclePositions = <int>[];
        var tempSeven = 0;

        while (sevenCyclePositions.length < 6) {
          tempSeven = rng.nextInt(12) + 1;

          if (!sevenCyclePositions.contains(tempSeven)) {
            sevenCyclePositions.add(tempSeven);
          }
        }
        sevenCyclePositions.sort();
        print('sevenCyclePositions $sevenCyclePositions');

        var cyklus = 1;
        var position = 1;
        var sevensIndex = 0;

        for (int i = 0; i < 36; i++) {
          print('order $order');
          // print('voslo ${sevenCyclePositions[sevensIndex]}');

          if (sevenCyclePositions.length > sevensIndex &&
              cyklus == sevenCyclePositions[sevensIndex] &&
              position == sevensPoolForThree[sevensIndex]) {
            print('VOSLO');

            order.insert(i, 7);
            sevensIndex++;
          }
          position++;

          if (position == 4) {
            position = 1;
            cyklus++;
          }
        }
        print('order: $order');
        print('WAT: ${order.where((element) => element == 7).length}');
        print('WAT sum: ${order.length}');

        // if (players == 3) pool = [1, 2, 3];
        // if (players == 4) pool = [1, 2, 3, 4];

        // if (appState.nextRoundSevens.isEmpty) {
        //   sevens = [...pool];
        //   sevens.shuffle();
        // } else {
        //   if (appState.nextRoundSevens.length == 1) {
        //     sevens = [...appState.nextRoundSevens, ...pool];
        //   } else {
        //     sevens = [...appState.nextRoundSevens];
        //   }
        //   sevens.shuffle();
        // }
        // print("waaat sevens $sevens");

        // var randomN = 0;
        // for (var i = 1; i <= 3; i++) {
        //   if (sevens.length == 5) break;
        //   randomN = rng.nextInt(pool.length);
        //   sevens.add(pool[randomN]);
        //   pool.removeAt(randomN);
        // }
        // appState.nextRoundSevens = [...pool];
        // order = [1, 2, 3, 1, 2, 4, 1, 3, 5, 1, 2, 4, 1, 2, 3];

        // print("waaat sevens $sevens");
        // order.insert(sevens[0] - 1, 7);
        // order.insert(sevens[1] + 3, 7);
        // order.insert(sevens[2] + 7, 7);
        // order.insert(sevens[3] + 11, 7);
        // order.insert(sevens[4] + 15, 7);

        // print('WOW $order');
      }

      var tempRandomValue = 0;
      var countOfFirst = appState.history.where((x) => x == first).length;
      var countOfSecond = appState.history.where((x) => x == second).length;
      if (countOfFirst == countOfSecond) {
        tempRandomValue = rng.nextBool() ? first : second;
      }
      if (countOfFirst > countOfSecond) {
        tempRandomValue = second;
      } else {
        tempRandomValue = first;
      }
      if (first == 7) tempRandomValue = 7;
      setState(() {
        appState.history.add(tempRandomValue);
        appState.randomValue = tempRandomValue;
        appState.mainIndex++;
        if (appState.mainIndex == 36) appState.mainIndex = 0;
      });
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${appState.randomValue}',
            style: TextStyle(fontSize: 90),
          ),
          SizedBox(height: 50),
          ElevatedButton(
            onPressed: () {
              switch (order[appState.mainIndex]) {
                case 1:
                  generateNextNumber(6, 8);
                  break;
                case 2:
                  generateNextNumber(5, 9);
                  break;
                case 3:
                  generateNextNumber(4, 10);
                  break;
                case 4:
                  generateNextNumber(3, 11);
                  break;
                case 5:
                  generateNextNumber(2, 12);
                  break;
                case 7:
                  generateNextNumber(7, 7);
                  break;
                default:
                  print("CHYBA");
              }
            },
            style: ElevatedButton.styleFrom(
              textStyle: const TextStyle(
                color: Colors.white,
                fontSize: 35,
              ),
              padding: EdgeInsets.all(20),
            ),
            child: const Text('Hod kockou'),
          ),
          ElevatedButton(
              onPressed: () => {
                    setState(() {
                      appState.history.clear();
                      appState.mainIndex = 0;
                      appState.randomValue = 0;
                    }),
                  },
              child: Text('Nova hra')),
          HistoryPage()
        ],
      ),
    );
  }
}

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    // int acc = 0;
    // var a = appState.history.asMap().entries.map((e) {
    //   var idx = e.key;
    //   print(idx);
    //   var val = e.value;
    //   return Text("${e.value}");
    // });
    // var b = [...a];
    // print(a);
    return Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text('Kockou sa uz hodilo ${appState.history.length} krat:'),
          ),
          Text('${appState.history}'),
        ],
      ),
    );
  }
}
