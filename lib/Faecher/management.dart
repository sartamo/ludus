// Das Management der einzelnen Fächer

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:collection';
import 'package:suppaapp/Faecher/faecher.dart';
import 'package:suppaapp/hausaufgaben.dart';

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
    List<String> fromSaveFarben = preferences.getStringList('farben') ?? List.generate(fromSaveNamen.length, (index) => '[]'); // der Länge der Liste der Namen

    while (fromSaveZeiten.length < fromSaveNamen.length) {
      fromSaveZeiten.add('{}');
    }

    while (fromSaveNotizen.length < fromSaveNamen.length) {
      fromSaveNotizen.add('[]');
    }

    while (fromSaveFarben.length < fromSaveNamen.length) {
      fromSaveFarben.add('[]');
    }

    for (int i = 0; i < fromSaveNamen.length; i++) {
      Map zeitenDecoded = jsonDecode(fromSaveZeiten[i]);
      SplayTreeMap<int, SplayTreeSet<int>> myZeiten = SplayTreeMap();
      zeitenDecoded.forEach((key, value) {
        if (key is String && value is List) {
          myZeiten[int.tryParse(key) ?? 0] = SplayTreeSet.of(List.generate(value.length, 
            (index) => value[index] is int ? value[index] : 0)
          );
        }
      });
      List<(String, String)> myNotizen = [];
      List notizenDecoded = jsonDecode(fromSaveNotizen[i]);
      for (dynamic element in notizenDecoded) {
        if (element is List && element.length == 2 && element[0] is String && element[1] is String) {
          myNotizen.add((element[0], element[1]));
        }
      }
      List farbenDecoded = jsonDecode(fromSaveFarben[i]);
      Color myFarbe = CupertinoColors.activeOrange;
      if (farbenDecoded.length == 4 && farbenDecoded[0] is int && farbenDecoded[1] is int && farbenDecoded[2] is int && farbenDecoded[3] is int) {
        myFarbe = Color.fromARGB(farbenDecoded[0], farbenDecoded[1], farbenDecoded[2], farbenDecoded[3]);
      }
      addFach(
        name: fromSaveNamen[i],
        zeiten: myZeiten,
        notizen: myNotizen,
        farbe: myFarbe,
      );
    }

    /*
    Map<String, dynamic> fromSaveFaecher =
      jsonDecode(preferences.getString('faecher') ?? '');
    fromSaveFaecher.forEach((name, zeitenEncoded) {
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

    Map<String, dynamic> fromSaveNotizen =
      jsonDecode(preferences.getString('notizen') ?? '');
    fromSaveNotizen.forEach((name, notizen) {
      if (notizen is List<dynamic>) {
        updateFach(
          index: _faecher.indexWhere((element) => element.name == name),
          notizen: List.generate(notizen.length, (index) => 
            notizen[index] is List && notizen[index][0] is String && notizen[index][1] is String
            ? (notizen[index][0], notizen[index][1])
            : ('', '') // Safety Check: Wenn die Speicherdatei aus irgendeinem Grund nicht unser Format hat, übernehme leere Strings
            ));
      }
    });

    Map<String, dynamic> fromSaveColors =
      jsonDecode(preferences.getString('farben') ?? '');
    fromSaveColors.forEach((name, color) {
      if (color is List) {
        if (color.every((element) => element is int) && color.length == 4) {
          updateFach(
            index: _faecher.indexWhere((element) => element.name == name),
            farbe: Color.fromARGB(color[0], color[1], color[2], color[3]),
          );
        }
      }
      // print(_faecher.firstWhere((element) => element.name == name).farbe);
    });
    */
  }

  Future<void> _saveFaecher() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    
    List<String> toSaveNamen = []; // Auflistung aller Namen
    List<String> toSaveZeiten = [];
    List<String> toSaveNotizen = [];
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
      toSaveFarben.add(jsonEncode(
        [fach.farbe.alpha, fach.farbe.red, fach.farbe.green, fach.farbe.blue]
      ));
    }

    preferences.setStringList('namen', toSaveNamen);
    preferences.setStringList('zeiten', toSaveZeiten);
    preferences.setStringList('notizen', toSaveNotizen);
    preferences.setStringList('farben', toSaveFarben);
  }

  List<Fach> get faecher => _faecher;

  void addFach(
      // Aufruf: faecherList.addFach(name: name, zeiten: zeiten, notizen: notizen)
      {required String name,
      required SplayTreeMap<int, SplayTreeSet<int>> zeiten,
      Color farbe = CupertinoColors.activeOrange,
      List<(String, String)> notizen = const [],
      List<Hausaufgabe> hausaufgaben = const []}) {
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
      // Aufruf: faecherList.updateFach(index: index, name: name, zeiten: zeiten, notizen: notizen)
      // name und zeiten können weggelassen werden
      {required int index,
      String? name,
      SplayTreeMap<int, SplayTreeSet<int>>? zeiten,
      Color? farbe,
      List<(String, String)>? notizen,
      List<Hausaufgabe>? hausaufgaben}) {
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
      _faecher[index].hausaufgaben = hausaufgaben;
    }
    _saveFaecher();
    notifyListeners();
  }
}

final faecher = FaecherList();
