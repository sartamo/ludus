// Die "Startseite" für die einzelnen Fächer

import 'package:flutter/cupertino.dart';
import 'dart:collection';
import 'package:suppaapp/FaecherEinstellungen/bearbeiten.dart';
import 'package:suppaapp/Faecher/management.dart';
import 'package:suppaapp/Notizen/hinzufuegen.dart';
import 'package:suppaapp/Notizen/bearbeiten.dart';
import 'package:suppaapp/Hausaufgaben/hinzufuegen.dart';
import 'package:suppaapp/Hausaufgaben/bearbeiten.dart';
import 'package:suppaapp/globals.dart';

enum Pages {unterrichtszeiten, notizen, hausaufgaben}

class FachData {
  // Speichert die Daten von einem Fach, siehe Klasse Fach
  String name;
  SplayTreeMap<int, SplayTreeSet<int>> zeiten;
  Color farbe;
  List<(String, String)> notizen; // (titel, inhalt)
  List<(String, DateTime)> hausaufgaben; // (inhalt, datum)

  FachData({required this.name, 
      required this.zeiten, 
      required this.farbe,
      required this.notizen,
      required this.hausaufgaben,
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
  List<(String, DateTime)> get hausaufgaben => data.hausaufgaben;

  set name(String newName) => data.name = newName;
  set zeiten(SplayTreeMap<int, SplayTreeSet<int>> newZeiten) =>
      data.zeiten = newZeiten;
  set farbe(Color newFarbe) => data.farbe = newFarbe;
  set notizen(List<(String, String)> newNotizen) => data.notizen = newNotizen;
  set hausaufgaben(List<(String, DateTime)> newHausaufgaben) => data.hausaufgaben = newHausaufgaben;

  @override
  State<Fach> createState() => _FachState();
}

class _FachState extends State<Fach> {
  late SplayTreeMap<DateTime, List<(int, String)>> _hausaufgabenMap;
  Pages _selectedPage = Pages.unterrichtszeiten;
  String _getSubtitleZeiten(int index) {
    SplayTreeSet<int> value = widget.zeiten.values.toList()[index];
    String subtitle = '';
    int counter = 0;
    for (int i in value) {
      if (counter != 0) {
        subtitle += ', ';
      }
      counter++;
      subtitle += stunden[i];
    }
    return subtitle;
  }

  SplayTreeMap<DateTime, List<(int, String)>> _getHausaufgabenMap() { // Gibt die Hausaufgaben umgeschrieben als Map zurück
    SplayTreeMap<DateTime, List<(int, String)>> map = SplayTreeMap(); // Format: datum
    for (int i = 0; i < widget.hausaufgaben.length; i++) {
      (String, DateTime) element = widget.hausaufgaben[i];
      List<(int, String)>? entry = map[element.$2];
      if (entry == null) {
        map[element.$2] = [(i, element.$1)];
      }
      else {
        map[element.$2] = entry..add((i, element.$1));
      }
    }
    return map;
  }

  @override
  void initState() {
    _hausaufgabenMap = _getHausaufgabenMap();
    super.initState();
    faecher.addListener(() {
      if (mounted) { // Ruft setState nur auf, wenn das Widget angezeigt wird
        setState(() {_hausaufgabenMap = _getHausaufgabenMap();});
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    faecher.removeListener(() {});
  }

  @override
  Widget build(BuildContext context) {
    _hausaufgabenMap = _getHausaufgabenMap();
    return CupertinoPageScaffold(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            CupertinoNavigationBar(
              leading: CupertinoNavigationBarBackButton(
                onPressed: () => Navigator.pop(context),
              ),
              middle: CupertinoSlidingSegmentedControl<Pages>(
                groupValue: _selectedPage,
                onValueChanged: (Pages? value) {
                  if (value != null) {
                    setState(() => _selectedPage = value);
                  }
                },
                children: <Pages, Widget> {
                  Pages.unterrichtszeiten: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ((MediaQuery.of(context).size.width) > 632 ? const Text('Unterrichtszeiten') : const Icon(CupertinoIcons.table)),
                    ),
                  Pages.notizen: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ((MediaQuery.of(context).size.width) > 632 ? const Text('Notizen') : const Icon(CupertinoIcons.pencil)),
                  ),
                  Pages.hausaufgaben: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ((MediaQuery.of(context).size.width) > 632 ? const Text('Hausaufgaben') : const Icon(CupertinoIcons.book)),
                  ),
                },
              ),
              trailing: _selectedPage == Pages.unterrichtszeiten 
                ? CupertinoButton( // Der Button für die Unterrichtszeiten
                  padding: EdgeInsets.zero,
                  child: const Icon(CupertinoIcons.settings),
                  onPressed: () async {
                    (String, SplayTreeMap<int, SplayTreeSet<int>>)? result =
                      await Navigator.of(context).push(CupertinoPageRoute(
                        builder: ((context) => FachBearbeiten(widget))));
                    if (result != null) {
                      faecher.updateFach(
                        index: faecher.faecher.indexOf(widget),
                        name: result.$1,
                        zeiten: result.$2,
                      );
                    }
                  },
                )
                : _selectedPage == Pages.notizen 
                  ? CupertinoButton( // Der Button für die Notizen
                    padding: EdgeInsets.zero,
                    child: const Icon(CupertinoIcons.add),
                    onPressed: () async {
                      (String, String)? result = await Navigator.of(context).push(CupertinoPageRoute(
                        builder: ((context) => const NotizHinzufuegen())
                      ));
                      if (result != null) {
                        faecher.updateFach(
                          index: faecher.faecher.indexOf(widget),
                          notizen: widget.notizen + [result],
                        );
                      }
                    },
                  )
                  : CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: const Icon(CupertinoIcons.add),
                    onPressed: () async {
                      (String, DateTime)? result = await Navigator.of(context).push(CupertinoPageRoute(
                        builder: ((context) => const HausaufgabeHinzufuegen())
                      ));
                      if (result != null) {
                        faecher.updateFach(
                          index: faecher.faecher.indexOf(widget),
                          hausaufgaben: widget.hausaufgaben + [result],
                        );
                      }
                    },
                  ),
            ),
            _selectedPage == Pages.unterrichtszeiten
              ? widget.zeiten.isEmpty
                ? Column(
                  children: [
                    const SizedBox(
                        height: 20,
                      ),
                    Text('Unterrichtszeiten vom Fach ${widget.name} leer')
                  ]
                )
                : CupertinoListSection( // Der Inhalt für die Unterrichtszeiten
                  header: Text(widget.name), 
                  children: List<Widget>.generate(
                    widget.zeiten.length,
                    (index) => CupertinoListTile(
                      title: Text(wochentage[widget.zeiten.keys.toList()[index]]),
                      subtitle: Text(_getSubtitleZeiten(index)),
                    ),
                  ),
                )
              : _selectedPage == Pages.notizen
                ? widget.notizen.isEmpty // Der Inhalt für die Notizen
                  ? Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Text('Notizen vom Fach ${widget.name} leer'),
                    ])
                  : CupertinoListSection(
                    header: Text(widget.name),
                    children: List<Widget>.generate(
                      widget.notizen.length,
                      (index) => CupertinoListTile(
                        title: Text(widget.notizen[index].$1), // Titel der Notiz
                        subtitle: Text(widget.notizen[index].$2), // Inhalt der Notiz
                        trailing: CupertinoButton(
                          padding: EdgeInsets.zero,
                          child: const Icon(CupertinoIcons.minus),
                          onPressed: () => faecher.updateFach(
                            index: faecher.faecher.indexOf(widget),
                            notizen: widget.notizen..removeAt(index)
                          ),
                        ),
                        onTap: () async {
                          (String, String)? result = await Navigator.of(context).push(CupertinoPageRoute(
                            builder: ((context) => NotizBearbeiten(widget.notizen[index]))
                          ));
                          if (result != null) {
                            widget.notizen[index] = result;
                            faecher.updateFach(
                              index: faecher.faecher.indexOf(widget),
                            ); // Kein Argument, aber weil wir das Fach ändern, soll trotzdem alles geupdatet werden
                          }
                        },
                      ),
                    ),
                  )
                : widget.hausaufgaben.isEmpty
                  ? Column(
                    children: [
                      const SizedBox(
                          height: 20,
                        ),
                      Text('Hausaufgaben vom Fach ${widget.name} leer'),
                    ])
                  : Column( // Für jedes unterschiedliche Datum erstellen wir eine CupertinoListSection
                    children: List<CupertinoListSection>.generate(
                      _hausaufgabenMap.length, 
                      (i) => CupertinoListSection(
                        header: Text("${wochentage[_hausaufgabenMap.keys.elementAt(i).weekday - 1]}, ${_hausaufgabenMap.keys.elementAt(i).day}.${_hausaufgabenMap.keys.elementAt(i).month}.${_hausaufgabenMap.keys.elementAt(i).year}"),
                        children: List<Widget>.generate(
                          _hausaufgabenMap.values.elementAt(i).length, 
                          (j) => CupertinoListTile(
                            title: Text(_hausaufgabenMap.values.elementAt(i)[j].$2),
                            trailing: CupertinoButton(
                              padding: EdgeInsets.zero,
                              child: const Icon(CupertinoIcons.minus),
                              onPressed: () => faecher.updateFach(
                                index: faecher.faecher.indexOf(widget),
                                hausaufgaben: widget.hausaufgaben..removeAt(_hausaufgabenMap.values.elementAt(i)[j].$1)
                              ),
                            ),
                            onTap: () async {
                              (String, DateTime)? result = await Navigator.of(context).push(CupertinoPageRoute(
                                builder: (context) => HausaufgabeBearbeiten((_hausaufgabenMap.values.elementAt(i)[j].$2, _hausaufgabenMap.keys.elementAt(i)))
                              ));
                              if (result != null) {
                                widget.hausaufgaben[_hausaufgabenMap.values.elementAt(i)[j].$1] = result;
                                faecher.updateFach(
                                  index: faecher.faecher.indexOf(widget),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
            ],
        ),
      ),
    );
  }
}
