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
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: _title,
        home: MyStatefulWidget(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
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

class MyStatefulWidget extends StatefulWidget {
  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;
  List<Widget> _widgetOptions = <Widget>[
    MyWidget(),
    HistoryPage(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

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

class MyWidget extends StatefulWidget {
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  var order = [1, 2, 3, 1, 2, 4, 1, 3, 5, 1, 2, 4, 1, 2, 3];

  var rng = Random();

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var sevens = [];
    var players = 4;

    void generateNextNumber(int first, int second) {
      if (appState.mainIndex == 0) {
        sevens = [];
        if (players == 3) {
          print('nextRoundSevens 1 -  ${appState.nextRoundSevens}');
          sevens = [...appState.nextRoundSevens];
          print('sevens $sevens');
          var pool = [1, 2, 3];
          var randomN = rng.nextInt(pool.length);
          sevens.add(pool[randomN]);
          pool.removeAt(randomN);

          randomN = rng.nextInt(pool.length);
          sevens.add(pool[randomN]);
          pool.removeAt(randomN);

          sevens.add(pool[0]);

          if (sevens.length < 5) {
            pool = [1, 2, 3];
            randomN = rng.nextInt(pool.length);
            sevens.add(pool[randomN]);
            pool.removeAt(randomN);
            if (sevens.length == 4) {
              randomN = rng.nextInt(pool.length);
              sevens.add(pool[randomN]);
              pool.removeAt(randomN);
            }
          }

          appState.nextRoundSevens = [...pool];
          print('appState.nextRoundSevens ${appState.nextRoundSevens}');

          pool = [1, 2, 3];
        }
        if (players == 4) {
          // pri hre styroch
          var pool = [1, 2, 3, 4];
          if (appState.nextRoundSevens.isEmpty) {
            sevens = [...pool];
            sevens.shuffle();
          } else {
            if (appState.nextRoundSevens.length == 1) {
              sevens = [...appState.nextRoundSevens, ...pool];
            } else {
              sevens = [...appState.nextRoundSevens];
            }
            sevens.shuffle();
          }
          print("waaat sevens $sevens");

          var randomN = 0;
          for (var i = 1; i <= 3; i++) {
            if (sevens.length == 5) break;
            randomN = rng.nextInt(pool.length);
            sevens.add(pool[randomN]);
            pool.removeAt(randomN);
          }
          // if (sevens.length < 5) {
          //   randomN = rng.nextInt(pool.length);
          //   sevens.add(pool[randomN]);
          //   pool.removeAt(randomN);
          //   if (sevens.length < 5) {
          //     randomN = rng.nextInt(pool.length);
          //     sevens.add(pool[randomN]);
          //     pool.removeAt(randomN);
          //   }
          //   if (sevens.length < 5) {
          //     randomN = rng.nextInt(pool.length);
          //     sevens.add(pool[randomN]);
          //     pool.removeAt(randomN);
          //   }
          // }

          // randomN = rng.nextInt(pool.length);
          // sevens.add(pool[randomN]);
          // pool.removeAt(randomN);

          // randomN = rng.nextInt(pool.length);
          // sevens.add(pool[randomN]);
          // pool.removeAt(randomN);

          // sevens.add(pool[0]);

          // pool = [1, 2, 3, 4];
          // randomN = rng.nextInt(pool.length);
          // sevens.add(pool[randomN]);
          appState.nextRoundSevens = [...pool];
        }
        order = [1, 2, 3, 1, 2, 4, 1, 3, 5, 1, 2, 4, 1, 2, 3];

        print("waaat sevens $sevens");
        order.insert(sevens[0] - 1, 7);
        order.insert(sevens[1] + 3, 7);
        order.insert(sevens[2] + 7, 7);
        order.insert(sevens[3] + 11, 7);
        order.insert(sevens[4] + 15, 7);

        print('WOW $order');
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
        if (appState.mainIndex == 20) appState.mainIndex = 0;
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
    var appState = context.watch<MyAppState>();
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
            child: Text('Kockou sa uz hodilo ${appState.history.length}x:'),
          ),
          Text('${appState.history}'),
        ],
      ),
    );
  }
}
