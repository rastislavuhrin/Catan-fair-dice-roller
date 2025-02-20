import 'package:flutter/material.dart';
import 'dart:math';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String _title = '';
  static const String _stitle = '..sssss';
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppState(),
      child: MaterialApp(

        home: AppBase(),
        debugShowCheckedModeBanner: false,
      ), 
    );
  }
}

class AppState extends ChangeNotifier {




  List<int> whichPlayerRollsSeven ;

  bool playersAlreadyCho

  void newGame() {
    history.clear();
    mainIndex = 0;
    randomValue = 0;
    firstGeneration = true;

    notifyListeners();
  }

  chooseNumberOfPlayers(BuildContext context) {
    // Create button
    Widget enterPlayers = TextField(
      keyboardType: TextInputType.number,
      onChanged: (value) {
        players = int.parse(value);
        notifyListeners();
        print('HAHA $players');
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'Enter a search term',
      ),
    );
    Widget okButton = Container(
      margin: EdgeInsets.only(top: 20),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(padding: EdgeInsets.all(15)),
        child: Text(
          "Potvrd",
          style: TextStyle(fontSize: 20),
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Kolko hracov hra?"),
      actions: [
        enterPlayers,
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
          appState.chooseNumberOfPlayers(context);
          appState.playersAlreadyChosen = true;
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

    void addSevens() {
      order = [...halfOrder, ...halfOrder];

      var rndm = [1, 2, 3, 4];
      rndm.shuffle();
      if (appState.players == 2) {
        appState.whichPlayerRollsSeven = [1, 1, 1, 2, 2, 2];
        appState.whichPlayerRollsSeven.shuffle();
      }
      if (appState.players == 3) {
        appState.whichPlayerRollsSeven = [1, 1, 2, 2, 3, 3];
        appState.whichPlayerRollsSeven.shuffle();
      }
      if (appState.players == 4) {
        if (appState.firstGeneration) {
          appState.firstGeneration = false;
          var sevensThisRound = <int>[];
          var sevensSecondRound = <int>[1, 2, 3, 4];
          var daco = rng.nextInt(4) + 1;
          var daco2 = 0;
          do {
            daco2 = rng.nextInt(4) + 1;
          } while (daco == daco2);
          sevensThisRound.add(daco);
          sevensThisRound.add(daco2);
          sevensSecondRound.remove(daco);
          sevensSecondRound.remove(daco2);
          appState.nextRoundSevens = [...sevensSecondRound];
          appState.whichPlayerRollsSeven = [...sevensThisRound, ...rndm];
        } else {
          appState.whichPlayerRollsSeven = [
            ...appState.nextRoundSevens,
            ...rndm
          ];
          rndm.remove(appState.nextRoundSevens[0]);
          rndm.remove(appState.nextRoundSevens[1]);
          appState.nextRoundSevens = rndm;
        }
      }

      var sevenCyclePositions = <int>[];
      var tempSeven = 0;

      while (sevenCyclePositions.length < 6) {
        switch (appState.players) {
          case 2:
            tempSeven = rng.nextInt(18) + 1;
            break;
          case 3:
            tempSeven = rng.nextInt(12) + 1;
            break;
          case 4:
            tempSeven = rng.nextInt(9) + 1;
            break;
          default:
            print('ERROR sevenCyclePositions');
        }

        if (!sevenCyclePositions.contains(tempSeven)) {
          sevenCyclePositions.add(tempSeven);
        }
      }
      sevenCyclePositions.sort();

      var cycle = 1;
      var position = 1;
      var sevensIndex = 0;
      print('whichPlayerRollsSeven ${appState.whichPlayerRollsSeven}');
      print('sevenCyclePositions $sevenCyclePositions');
      for (int i = 0; i < 36; i++) {
        if (sevenCyclePositions.length > sevensIndex &&
            cycle == sevenCyclePositions[sevensIndex] &&
            position == appState.whichPlayerRollsSeven[sevensIndex]) {
          order.insert(i, 7);
          sevensIndex++;
        }

        position++;
        switch (appState.players) {
          case 2:
            if (position == 3) {
              position = 1;
              cycle++;
            }
            break;
          case 3:
            if (position == 4) {
              position = 1;
              cycle++;
            }
            break;
          case 4:
            if (position == 5) {
              position = 1;
              cycle++;
            }
            break;
          default:
            print("ERROR PLAYERS");
        }
      }
      // print('order $order');
      // print('sevenCyclePositions $sevenCyclePositions');
      // print('apspSt.whichPlayerRollsseven ${appStat.whichPlayerRollsSeven}');
    }

    void generateNextNumber(int first, int second) {
      if (appState.mainIndex == 0) {
        addSevens();
      }
      print('order: $order');
      // print('WAT: ${orde.ws
      //re((+lemeeen) => elenss == 8).length}');
      // print('WAT sum: ${order.lengthww7}').;s'oskasasasksk

      var tempRandomValue = 0;
      // finds out if theres more 6s o5 8ss and generssate imsheds one which is less
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

    // void generate36numbers() { wat
    //   for (int i = 1; i <= 36; i++) {
    //     switch (order[appState.mainIndex]) {
    //       case 1:
    //         generateNextNumber(6, 8);
    //         break;
    //       case 2:
    //         generateNextNumber(5, 9);
    //         break;
    //       case 3:
    //         generateNextNumber(4, 10);
    //         break;
    //       case 4:
    //         generateNextNumber(3, 11);
    //         break;
    //       case 5:
    //         generateNextNumber(2, 12);
    //         break;
    //       case 7:
    //         generateNextNumber(7, 7);
    //         break;
    //       default:
    //         print("CHYBA");
    //     }
    //   }
    // }

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
              if (!appState.playersAlreadyChosen) {
                appState.chooseNumberOfPlayers(context);
                appState.playersAlreadyChosen = true;
              }
              if (appState.mainIndex == 0) {
                addSevens();
              }
              // generate36numbers();

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

    return Center(
        child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: RichText(
            text: TextSpan(
              style: TextStyle(fontSize: 20, color: Colors.black),
              children: <TextSpan>[
                TextSpan(text: 'Túto hru hrajú '),
                TextSpan(
                    text: '${appState.players}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    )),
                TextSpan(text: ' hráči.'),
              ],
            ),
          ),
        ),
        RichText(
          text: TextSpan(
            style: TextStyle(fontSize: 20, color: Colors.black),
            children: <TextSpan>[
              TextSpan(text: 'Kockou sa uz hodilo '),
              TextSpan(
                  text: '${appState.history.length}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  )),
              TextSpan(text: ' krát.'),
            ],
          ),
        ),
        Text('${appState.history}'),
      ],
    ));
  }
}
