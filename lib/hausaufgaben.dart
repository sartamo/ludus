// Das Management der einzelnen Fächer

import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:suppaapp/faecher.dart';

class Hausaufgabe extends StatefulWidget {
  final String name;
  final DateTime datum;
  final Fach fach; 

  const Hausaufgabe(this.fach, this.name,this.datum, {super.key});

  @override
  State<Hausaufgabe> createState() => _HausaufgabeState();
}

class _HausaufgabeState extends State<Hausaufgabe> {
  late List<Text> _display;
  late String _name;
  Hausaufgabe hausi =  Hausaufgabe(Fach('',SplayTreeMap<int, SplayTreeSet<int>>()), '', DateTime.now());

  List<Text> _getDisplay() {
    // Gibt den anzuzeigenden Text an _HausaufgabeState
    List<Text> display = [  
      Text('Hausaufgabe ${widget.name}'),
      const Text('Abgabe:'),
    ];
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

class HausaufgabenList extends ChangeNotifier {
  final List<Hausaufgabe> _hausaufgaben = [];
  Hausaufgabe hausi =  Hausaufgabe(Fach('',SplayTreeMap<int, SplayTreeSet<int>>()), '', DateTime.now());

  HausaufgabenList() {
    Future<void> result = _loadHausaufgaben();
    result.whenComplete(() => notifyListeners());
  }

Future<void> _loadHausaufgaben() async {
  final SharedPreferences preferences = await SharedPreferences.getInstance();
  Map<String, dynamic> fromSave = jsonDecode(preferences.getString('faecher') ?? '');
  fromSave.forEach((hausaufgabe, hausaufgabenEncoded) { 
    if (hausaufgabenEncoded is String){
      Map<String, dynamic> hausaufgabenModified = jsonDecode(hausaufgabenEncoded);
      Hausaufgabe newHausi = Hausaufgabe(
        jsonDecode(hausaufgabenModified['fach']), 
        jsonDecode(hausaufgabenModified['name']), 
        jsonDecode(hausaufgabenModified['datum'])
        ); 
      hausaufgaben.add(newHausi);   
    }
  });
}


Future<void> _saveHausaufgaben() async {
  final SharedPreferences preferences = await SharedPreferences.getInstance();
  Map<String, String> toSave = {}; 
  for (Hausaufgabe hausaufgabe in _hausaufgaben) {
    Map<String, dynamic> hausaufgabenMap = {
      'name': hausaufgabe.name,
      'datum': hausaufgabe.datum,
      'fach': hausaufgabe.fach
    };
    toSave[hausaufgabe.name] = jsonEncode(hausaufgabenMap);
  }
  preferences.setString('hausaufgaben', jsonEncode(toSave));
}

List<Hausaufgabe> get hausaufgaben => _hausaufgaben;

  void addHausi(Hausaufgabe hausaufgabe) {
    _hausaufgaben.add(hausaufgabe);
    Future<void> result = _saveHausaufgaben();
    result.whenComplete(() => notifyListeners());
  }

  void removeHausi(int index) {
    _hausaufgaben.remove(_hausaufgaben[index]);
    Future<void> result = _saveHausaufgaben();
    result.whenComplete(() => notifyListeners());
  }

  void updateHausaufgabe(int index, Hausaufgabe newHausaufgabe) {
    _hausaufgaben[index] = newHausaufgabe;
    _saveHausaufgaben();
    notifyListeners();
  }
}

final hausaufgabenList = HausaufgabenList();
