// Das Management der einzelnen Fächer

import 'package:flutter/cupertino.dart';
import 'package:suppaapp/globals.dart';

class Fach extends StatefulWidget {

  final String name;
  final Map<int, Set<int>> zeiten; // Die Zeiten des Fachs: Wochentag wird Stunde(n) zugeordnet

  const Fach(this.name, this.zeiten, {super.key});

  @override
  State<Fach> createState() => _FachState();

}

class _FachState extends State<Fach> {
  late List<Text> _display;
  late String _name;

  List<Text> _getDisplay(){  // Gibt den anzuzeigenden Text an _FachState
    List<Text> display = [
      Text('Willkommen im Fach ${widget.name}'),
      const Text('Unterrichtszeiten:'),
    ];

    for (int w in [0, 1, 2, 3, 4]) {
      Set<int>? st = widget.zeiten[w];
      if (st != null) {
        for (int s in st){
          display.add(Text('${wochentage[w]}, ${stunden[s]}')); // Zeigt für jeden Wochentag w die dazugehörige Uhrzeit an.
        }
      }
    }
    return display;
  }

  @override
  void initState(){
    _display = _getDisplay();
    _name = widget.name;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: CupertinoNavigationBarBackButton(
          onPressed: () => Navigator.pop(context),
        ),
        middle: Text(_name),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _display,
        ),
      ),
    );
  }
}

class FaecherList extends ChangeNotifier {
  final List<Fach> _faecher = [
    const Fach('Mathematik', {0 : {3}, 2 : {0}, 4 : {5}}),
    const Fach('Deutsch', {1 : {4, 5}, 4 : {0}}),
    const Fach('Englisch', {2 : {3}, 3 : {5}, 4 : {3, 4}})
  ];

  List<Fach> get faecher => _faecher;

  void addFach(Fach fach) {
    _faecher.add(fach);
    notifyListeners();
  }

  void removeFach(int index) {
    _faecher.remove(_faecher[index]);
    notifyListeners();
  }

  void updateFach(int index, Fach newFach) {
    _faecher[index] = newFach;
    notifyListeners();
  }
}

final faecherList = FaecherList();