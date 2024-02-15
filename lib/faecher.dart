// Das Management der einzelnen Fächer

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:collection';
import 'package:suppaapp/globals.dart';

class FachData {
  // Speichert die Daten von einem Fach, siehe Klasse Fach
  String name;
  SplayTreeMap<int, SplayTreeSet<int>> zeiten;

  FachData({required this.name, required this.zeiten});
}

class Fach extends StatefulWidget {
  // Aufruf normalerweise über faecherList.addFach
  // Hier: Fach(FachData(name: name, zeiten: zeiten))
  final FachData data;
  const Fach(this.data, {super.key});

  String get name =>
      data.name; // Stateful Widget ist immutable, deswegen extra Klasse
  SplayTreeMap<int, SplayTreeSet<int>> get zeiten => data.zeiten;

  set name(String newName) => data.name = newName;
  set zeiten(SplayTreeMap<int, SplayTreeSet<int>> newZeiten) =>
      data.zeiten = newZeiten;

  @override
  State<Fach> createState() => _FachState();
}

class _FachState extends State<Fach> {
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
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: CupertinoNavigationBarBackButton(
          onPressed: () => Navigator.pop(context),
        ),
        middle: Text(widget.name),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _getDisplay(),
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
    fromSave.forEach((name, zeitenEncoded) {
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
        addFach(name: name, zeiten: zeiten);
      } else {
        addFach(name: name, zeiten: SplayTreeMap());
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

  List<Fach> get faecher => _faecher;

  void addFach(
      // Aufruf: faecherList.addFach(name: name, zeiten: zeiten)
      {required String name,
      required SplayTreeMap<int, SplayTreeSet<int>> zeiten}) {
    Fach myFach = Fach(FachData(name: name, zeiten: zeiten));
    _faecher.add(myFach);
    Future<void> result = _saveFaecher();
    result.whenComplete(() => notifyListeners());
  }

  void removeFach(int index) {
    // Aufruf: faecherList.removeFach(index)
    _faecher.remove(_faecher[index]);
    Future<void> result = _saveFaecher();
    result.whenComplete(() => notifyListeners());
  }

  void updateFach(
      // Aufruf: faecherList.updateFach(index: index, name: name, zeiten: zeiten)
      // name und zeiten können weggelassen werden
      {required int index,
      String? name,
      SplayTreeMap<int, SplayTreeSet<int>>? zeiten}) {
    if (zeiten != null) {
      _faecher[index].zeiten = zeiten;
    }
    if (name != null) {
      _faecher[index].name = name;
    }
    _saveFaecher();
    notifyListeners();
  }
}

final faecherList = FaecherList();
