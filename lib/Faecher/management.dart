// Das Management der einzelnen Fächer

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:collection';
import 'package:suppaapp/Faecher/faecher.dart';

class FaecherList extends ChangeNotifier {
  List<Fach> _faecher = [];

  FaecherList() {
    Future<void> result = _loadFaecher();
    result.whenComplete(() => notifyListeners());
  }

  Future<void> _loadFaecher() async {
    _faecher = [];

    final SharedPreferences preferences = await SharedPreferences.getInstance();
    List<String> fromSaveNamen = preferences.getStringList('namen') ?? [];
    List<String> fromSaveZeiten = preferences.getStringList('zeiten') ?? List.generate(fromSaveNamen.length, (index) => '{}'); // Wenn der Key nicht eingetragen ist,
    List<String> fromSaveNotizen = preferences.getStringList('notizen') ?? List.generate(fromSaveNamen.length, (index) => '[]');  // erstelle eine Liste mit leeren Strings
    List<String> fromSaveHausaufgaben = preferences.getStringList('hausaufgaben') ?? List.generate(fromSaveNamen.length, (index) => '[]'); // der Länge der Liste der Namen
    List<String> fromSaveFarben = preferences.getStringList('farben') ?? List.generate(fromSaveNamen.length, (index) => '[]');

    // Weil die Listen gleich lang sein müssen, fügen wir bei Bedarf leere Listen hinzu (nur nötig, wenn der Save manipuliert wurde)

    while (fromSaveZeiten.length < fromSaveNamen.length) {
      fromSaveZeiten.add('{}');
    }

    while (fromSaveNotizen.length < fromSaveNamen.length) {
      fromSaveNotizen.add('[]');
    }

    while (fromSaveHausaufgaben.length < fromSaveNamen.length) {
      fromSaveHausaufgaben.add('[]');
    }

    while (fromSaveFarben.length < fromSaveNamen.length) {
      fromSaveFarben.add('[]');
    }

    for (int i = 0; i < fromSaveNamen.length; i++) { // Decoden der Zeiten
      Map zeitenDecoded = jsonDecode(fromSaveZeiten[i]);
      SplayTreeMap<int, SplayTreeSet<int>> myZeiten = SplayTreeMap();
      zeitenDecoded.forEach((key, value) {
        if (key is String && value is List) {
          myZeiten[int.tryParse(key) ?? 0] = SplayTreeSet.of(List.generate(value.length, 
            (index) => value[index] is int ? value[index] : 0)
          );
        }
      });

      List<(String, String)> myNotizen = []; // Decoden der Notizen
      List notizenDecoded = jsonDecode(fromSaveNotizen[i]);
      for (dynamic element in notizenDecoded) {
        if (element is List && element.length == 2 && element[0] is String && element[1] is String) { // Überprüfen, ob alles seine Richtigkeit hat, sonst wird nichts gemacht
          myNotizen.add((element[0], element[1]));
        }
      }

      List hausaufgabenDecoded = jsonDecode(fromSaveHausaufgaben[i]);
      List<(String, DateTime)> myHausaufgaben = [];
      for (dynamic element in hausaufgabenDecoded) {
        if (element is List && element.length == 2 && element[0] is String && element[1] is String) {
          myHausaufgaben.add((element[0], DateTime.parse(element[1])));
        }
      }

      List farbenDecoded = jsonDecode(fromSaveFarben[i]); // Decoden der Farben
      Color myFarbe = CupertinoColors.activeOrange;
      if (farbenDecoded.length == 4 && farbenDecoded[0] is int && farbenDecoded[1] is int && farbenDecoded[2] is int && farbenDecoded[3] is int) {
        myFarbe = Color.fromARGB(farbenDecoded[0], farbenDecoded[1], farbenDecoded[2], farbenDecoded[3]);
      }
      addFach( // Hinzufügen des finalen Fachs
        name: fromSaveNamen[i],
        zeiten: myZeiten,
        notizen: myNotizen,
        farbe: myFarbe,
        hausaufgaben: myHausaufgaben,
      );
    }
  }

  Future<void> _saveFaecher() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    
    List<String> toSaveNamen = []; // Auflistung aller Namen
    List<String> toSaveZeiten = [];
    List<String> toSaveNotizen = [];
    List<String> toSaveHausaufgaben = [];
    List<String> toSaveFarben = [];

    for (Fach fach in _faecher) {
      toSaveNamen.add(fach.name);
      Map<String, List<int>> zeitenModified = {};
      fach.zeiten.forEach((key, value) {
        zeitenModified[key.toString()] = value.toList();
      });
      toSaveZeiten.add(jsonEncode(zeitenModified));
      toSaveNotizen.add(jsonEncode(List<List<String>>.generate(
        fach.notizen.length, 
        (index) => [fach.notizen[index].$1, fach.notizen[index].$2],
      )));
      toSaveHausaufgaben.add(jsonEncode(List<List<String>>.generate(
        fach.hausaufgaben.length, 
        (index) => [fach.hausaufgaben[index].$1, fach.hausaufgaben[index].$2.toString()]
      )));
      toSaveFarben.add(jsonEncode(
        [fach.farbe.alpha, fach.farbe.red, fach.farbe.green, fach.farbe.blue]
      ));
    }

    preferences.setStringList('namen', toSaveNamen);
    preferences.setStringList('zeiten', toSaveZeiten);
    preferences.setStringList('notizen', toSaveNotizen);
    preferences.setStringList('hausaufgaben', toSaveHausaufgaben);
    preferences.setStringList('farben', toSaveFarben);
  }

  List<Fach> get faecher => _faecher;

  void addFach(
    // Aufruf: faecherList.addFach(name: name, zeiten: zeiten, notizen: notizen, farbe: farbe, hausaufgaben: hausaufgaben)
    {required String name,
    required SplayTreeMap<int, SplayTreeSet<int>> zeiten,
    Color farbe = CupertinoColors.activeOrange,
    List<(String, String)> notizen = const [],
    List<(String, DateTime)> hausaufgaben = const []}) {
      try{
        hausaufgaben.sort((a, b) => a.$2.compareTo(b.$2)); // Sortieren der Hausaufgaben nach Datum
      }
      catch(e) {
        hausaufgaben = [];
      }
      Fach myFach = Fach(FachData(name: name, zeiten: zeiten, farbe: farbe, notizen: notizen, hausaufgaben: hausaufgaben));
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
      // Aufruf: faecherList.updateFach(index: index, name: name, zeiten: zeiten, notizen: notizen, farbe: farbe, hausaufgaben: hausaufgaben)
      {required int index,
      String? name,
      SplayTreeMap<int, SplayTreeSet<int>>? zeiten,
      Color? farbe,
      List<(String, String)>? notizen,
      List<(String, DateTime)>? hausaufgaben}) {
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
    if (hausaufgaben != null) {
      hausaufgaben.sort((a, b) => a.$2.compareTo(b.$2)); // Sortieren der Hausaufgaben nach Datum
      _faecher[index].hausaufgaben = hausaufgaben;
    }
    _saveFaecher();
    notifyListeners();
  }
}

final faecher = FaecherList();
