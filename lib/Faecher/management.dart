// Das Management der einzelnen Fächer

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:collection';
import 'package:suppaapp/Faecher/faecher.dart';

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
        addFach(name: name, zeiten: zeiten, farbe: CupertinoColors.activeOrange);
      } else {
        addFach(name: name, zeiten: SplayTreeMap(), farbe: CupertinoColors.activeOrange);
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
      // Aufruf: faecherList.addFach(name: name, zeiten: zeiten, notizen: notizen)
      {required String name,
      required SplayTreeMap<int, SplayTreeSet<int>> zeiten,
      required Color farbe,
      List<(String, String)> notizen = const []}) {
    Fach myFach = Fach(FachData(name: name, zeiten: zeiten, farbe: farbe, notizen: notizen));
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
      // Aufruf: faecherList.updateFach(index: index, name: name, zeiten: zeiten, notizen: notizen)
      // name und zeiten können weggelassen werden
      {required int index,
      String? name,
      SplayTreeMap<int, SplayTreeSet<int>>? zeiten,
      Color? farbe,
      List<(String, String)>? notizen}) {
    if (zeiten != null) {
      _faecher[index].zeiten = zeiten;
    }
    if (name != null) {
      _faecher[index].name = name;
    }
    if (farbe != null) {
      _faecher[index].farbe = farbe;
    }
    if (notizen != null) {
      _faecher[index].notizen = notizen;
    }
    _saveFaecher();
    notifyListeners();
  }
}

final faecher = FaecherList();
