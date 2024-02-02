// Das Management der einzelnen Fächer

import 'package:flutter/cupertino.dart';
import 'globals.dart';

class Fach extends StatefulWidget {

  final String name;
  final Map<int, List<int>> zeiten; // Die Zeiten des Fachs: Wochentag wird Stunde(n) zugeordnet

  const Fach(this.name, this.zeiten, {super.key});

  List<Text> getDisplay(){  // Gibt den anzuzeigenden Text an _FachState
    List<Text> display = [
      Text('Willkommen im Fach $name'),
      const Text('Unterrichtszeiten:'),
    ];

    for (int w in [0, 1, 2, 3, 4]) {
      List<int>? st = zeiten[w];
      if (st != null) {
        for (int s in st){
          display.add(Text('${wochentage[w]}, ${stunden[s]}')); // Zeigt für jeden Wochentag w die dazugehörige Uhrzeit an.
        }
      }
    }
    return display;
  }

  @override
  State<Fach> createState() => _FachState();

}

class _FachState extends State<Fach> {
  late List<Text> display;
  late String name;

  @override
  void initState(){
    display = widget.getDisplay();
    name = widget.name;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: CupertinoNavigationBarBackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        middle: Text(name),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: display,
        ),
      ),
    );
  }
}

List<Fach> faecher = [
  const Fach('Mathematik', {0 : [3], 2 : [0], 4 : [5]}),
  const Fach('Deutsch', {1 : [4, 5], 4 : [0]}),
  const Fach('Englisch', {2 : [3], 3 : [5], 4 : [3, 4]})
];