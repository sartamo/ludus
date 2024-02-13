// Das Management der einzelnen Fächer

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:collection';
import 'package:suppaapp/globals.dart';

class Fach extends StatefulWidget {
  final String name;
  final SplayTreeMap<int, SplayTreeSet<int>>
      zeiten; // Die Zeiten des Fachs: Wochentag wird Stunde(n) zugeordnet

  const Fach(this.name, this.zeiten, {super.key});

  @override
  State<Fach> createState() => _FachState();
}

class _FachState extends State<Fach> {
  late List<Text> _display;
  late String _name;

  List<Text> _getDisplay() {
    // Gibt den anzuzeigenden Text an _FachState
    List<Text> display = [
      Text('Willkommen im Fach ${widget.name}'),
      const Text('Unterrichtszeiten:'),
    ];

    for (int w = 0; w < wochentage.length; w++) {
      Set<int>? st = widget.zeiten[w];
      if (st != null) {
        for (int s in st) {
          display.add(Text(
              '${wochentage[w]}, ${stunden[s]}')); // Zeigt für jeden Wochentag w die dazugehörige Uhrzeit an.
        }
      }
    }
    return display;
  }

  @override
  void initState() {
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
  final List<Fach> _faecher = [];

  FaecherList() {
    Future<void> result = _loadFaecher();
    result.whenComplete(() => notifyListeners());
  }

  Future<void> _loadFaecher() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    Map<String, dynamic> fromSave =
        jsonDecode(preferences.getString('faecher') ?? '');
    fromSave.forEach((fach, zeitenEncoded) {
      if (zeitenEncoded is String) {
        Map<String, dynamic> zeitenModified = jsonDecode(zeitenEncoded);
        SplayTreeMap<int, SplayTreeSet<int>> zeiten = SplayTreeMap();
        zeitenModified.forEach((key, value) {
          if (value is List) {
            zeiten[int.parse(key)] = SplayTreeSet.of(List.generate(value.length,
                (index) => value[index] is int ? value[index] : 0));
          } else {
            zeiten[int.parse(key)] = SplayTreeSet();
          }
        });
        _faecher.add(Fach(fach, zeiten));
      } else {
        _faecher.add(Fach(fach, SplayTreeMap()));
      }
    });
  }

  Future<void> _saveFaecher() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    Map<String, String> toSave =
        {}; // Namen werden json encodeten Zeiten zugeordnet
    for (Fach fach in _faecher) {
      Map<String, List<int>> zeitenModified =
          {}; // jsonEncode funktioniert nur, wenn die Keys Strings und die Values Listen sind
      fach.zeiten.forEach(
          (key, value) => zeitenModified[key.toString()] = value.toList());
      toSave[fach.name] = jsonEncode(zeitenModified);
    }
    preferences.setString(
        'faecher',
        jsonEncode(
            toSave)); // SharedPreferences nimmt nur Strings an, deswegen müssen wir zu json konvertieren
  }

  /* final List<Fach> _faecher = [
    const Fach('Mathematik', {0 : {3}, 2 : {0}, 4 : {5}}),
    const Fach('Deutsch', {1 : {4, 5}, 4 : {0}}),
    const Fach('Englisch', {2 : {3}, 3 : {5}, 4 : {3, 4}})
  ]; */

  List<Fach> get faecher => _faecher;

  void addFach(Fach fach) {
    _faecher.add(fach);
    Future<void> result = _saveFaecher();
    result.whenComplete(() => notifyListeners());
  }

  void removeFach(int index) {
    _faecher.remove(_faecher[index]);
    Future<void> result = _saveFaecher();
    result.whenComplete(() => notifyListeners());
  }

  void updateFach(int index, Fach newFach) {
    _faecher[index] = newFach;
    _saveFaecher();
    notifyListeners();
  }
}

final faecherList = FaecherList();
