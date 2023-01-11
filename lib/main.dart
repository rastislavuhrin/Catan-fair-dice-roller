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
      Widget cancelButton = OutlinedButton(
        child: Text("nie"),
        onPressed: () {
          Navigator.of(context).pop();
        },
      );
      Widget okButton = OutlinedButton(
        child: Text("ano"),
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
  var order = [7, 1, 2, 3, 1, 7, 2, 4, 1, 7, 3, 5, 7, 1, 2, 7, 4, 1, 7, 2, 3];

  var rng = Random();

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    print(appState.randomValue);
    print(appState.mainIndex);

    void daco(int first, int second) {
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
        if (appState.mainIndex == 15) appState.mainIndex = 0;
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
                case 7:
                  daco(7, 7);
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
