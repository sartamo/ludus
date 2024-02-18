// Die "Startseite" für die einzelnen Fächer

import 'package:flutter/cupertino.dart';
import 'dart:collection';
import 'package:suppaapp/FaecherEinstellungen/bearbeiten.dart';
import 'package:suppaapp/Faecher/management.dart';
import 'package:suppaapp/Faecher/unterrichtszeiten.dart';
import 'package:suppaapp/Faecher/notizen.dart';

class FachData {
  // Speichert die Daten von einem Fach, siehe Klasse Fach
  String name;
  SplayTreeMap<int, SplayTreeSet<int>> zeiten;
  Color farbe;
  List<(String, String)> notizen; // (titel, inhalt)

  FachData({required this.name, 
      required this.zeiten, 
      required this.farbe,
      this.notizen = const []
  });
}

class Fach extends StatefulWidget {
  // Aufruf normalerweise über faecherList.addFach
  // Hier: Fach(FachData(name: name, zeiten: zeiten))
  final FachData data;
  const Fach(this.data, {super.key});

  String get name =>
      data.name; // Stateful Widget ist immutable, deswegen extra Klasse
  SplayTreeMap<int, SplayTreeSet<int>> get zeiten => data.zeiten;
  Color get farbe => data.farbe;
  List<(String, String)> get notizen => data.notizen;

  set name(String newName) => data.name = newName;
  set zeiten(SplayTreeMap<int, SplayTreeSet<int>> newZeiten) =>
      data.zeiten = newZeiten;
  set farbe(Color newFarbe) => data.farbe = newFarbe;
  set notizen(List<(String, String)> newNotizen) => data.notizen = newNotizen;

  @override
  State<Fach> createState() => _FachState();
}

class _FachState extends State<Fach> {
  @override
  void initState() {
    super.initState();
    faecher.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        child: Column(
      children: <Widget>[
        CupertinoNavigationBar(
          leading: CupertinoNavigationBarBackButton(
            onPressed: () => Navigator.pop(context),
          ),
          middle: Text(widget.name),
          trailing: CupertinoButton(
            padding: EdgeInsets.zero,
            child: const Icon(CupertinoIcons.settings),
            onPressed: () async {
              (String, SplayTreeMap<int, SplayTreeSet<int>>) result =
                  await Navigator.of(context).push(CupertinoPageRoute(
                      builder: ((context) => FachBearbeiten(widget))));
              faecher.updateFach(
                  index: faecher.faecher.indexOf(widget),
                  name: result.$1,
                  zeiten: result.$2,
                );
            },
          ),
        ),
        CupertinoListSection(
          children: <Widget>[
            CupertinoListTile(
                title: const Text('Unterrichtszeiten'),
                onTap: () => Navigator.of(context).push(CupertinoPageRoute(
                    builder: (context) => Unterrichtszeiten(widget)))),
            CupertinoListTile(
                title: const Text('Notizen'),
                onTap: () => Navigator.of(context).push(CupertinoPageRoute(
                  builder: (context) => Notizen(widget)))),
            const CupertinoListTile(
                title: Text('Hausaufgaben'),
            ),
          ],
        ),
      ],
    ));
  }
}
