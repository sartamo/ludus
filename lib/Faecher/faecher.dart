// Die "Startseite" für die einzelnen Fächer

import 'package:flutter/cupertino.dart';
import 'dart:collection';
import 'package:suppaapp/FaecherEinstellungen/bearbeiten.dart';
import 'package:suppaapp/Faecher/management.dart';
import 'package:suppaapp/Notizen/hinzufuegen.dart';
import 'package:suppaapp/Notizen/bearbeiten.dart';
import 'package:suppaapp/globals.dart';

enum Pages {unterrichtszeiten, notizen, hausaufgaben}

class FachData {
  // Speichert die Daten von einem Fach, siehe Klasse Fach
  String name;
  SplayTreeMap<int, SplayTreeSet<int>> zeiten;
  Color farbe;
  List<(String, String)> notizen; // (titel, inhalt)

  FachData({required this.name, 
      required this.zeiten, 
      required this.farbe,
      required this.notizen
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

  @override
  void initState() {
    super.initState();
    faecher.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    faecher.removeListener(() {});
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
          middle: CupertinoSlidingSegmentedControl<Pages>(
            groupValue: _selectedPage,
            onValueChanged: (Pages? value) {
              if (value != null) {
                setState(() => _selectedPage = value);
              }
            },
            children: const <Pages, Widget> {
              Pages.unterrichtszeiten: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text('Unterrichtszeiten'),
              ),
              Pages.notizen: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text('Notizen'),
              ),
              Pages.hausaufgaben: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text('Hausaufgaben'),
              ),
            },
          ),
          trailing: _selectedPage == Pages.unterrichtszeiten 
            ? CupertinoButton( // Der Button für die Unterrichtszeiten
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
                onPressed: () {},
              ),
        ),
        _selectedPage == Pages.unterrichtszeiten
          ? CupertinoListSection( // Der Inhalt für die Unterrichtszeiten
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
              ? const Center(
                child: Text('Füge Notizen hinzu, damit sie hier erscheinen'))
              : CupertinoListSection(
                header: Text(widget.name),
                children: List<Widget>.generate(
                  widget.notizen.length,
                  (index) => CupertinoListTile(
                    title: Text(widget.notizen[index].$1), // Titel der Notiz
                    subtitle: Text(widget.notizen[index].$2), // Inhalt der Notiz
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
            : const Text('Hier stehen mal die Hausaufgaben'),
      ],
    ));
  }
}
