// Die Seite für die Fächerliste

import 'package:flutter/cupertino.dart';
import 'package:suppaapp/FaecherEinstellungen/hinzufuegen.dart';
import 'package:suppaapp/FaecherEinstellungen/bearbeiten.dart';
import 'package:suppaapp/Faecher/hauptseite.dart';
import 'package:suppaapp/Faecher/management.dart';
import 'package:suppaapp/globals.dart';
import 'dart:collection';

class Faecherliste extends StatefulWidget {
  const Faecherliste({super.key});

  @override
  State<Faecherliste> createState() => _FaecherlisteState();
}

class _FaecherlisteState extends State<Faecherliste> {
  String _getSubtitle(Fach myFach) {
    String mySubtitle = '';
    int counter =
        0; // Damit die Kommata richtig zwischen den Wochentagen gesetzt werden
    for (int w = 0; w < wochentage.length; w++) {
      // Geht die Wochentage durch
      Set<int>? myZeiten = myFach.zeiten[w];
      if (myZeiten != null) {
        if (counter != 0) {
          mySubtitle += ', ';
        }
        int counter2 =
            0; // Damit die Kommata richtig zwischen den Stunden gesetzt werden
        counter++;
        mySubtitle += '${wochentage[w]} (';
        for (int s in myZeiten) {
          if (counter2 != 0) {
            mySubtitle += ', ';
          }
          counter2++;
          mySubtitle += stunden[s];
        }
        mySubtitle += ')';
      }
    }
    return mySubtitle;
  }

  Future<void> _fachHinzufuegen() async {
    (String, SplayTreeMap<int, SplayTreeSet<int>>)? result =
        await Navigator.of(context).push(
            CupertinoPageRoute(builder: (context) => const FachHinzufuegen()));
    if (result != null) {
      faecher.addFach(
        name: result.$1,
        zeiten: result.$2,
      );
    }
  }

  Future<void> _fachBearbeiten(int index) async {
    (String, SplayTreeMap<int, SplayTreeSet<int>>)? result =
        await Navigator.of(context).push(CupertinoPageRoute(
            builder: (context) => FachBearbeiten(faecher.faecher[index])));
    if (result != null) {
      faecher.updateFach(
        index: index,
        name: result.$1,
        zeiten: result.$2,
      );
    }
  }

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
      child: SingleChildScrollView(
        child: Column(
          children: [
            CupertinoNavigationBar(
              middle: const Text('Fächerliste'),
              trailing: CupertinoButton(
                padding: EdgeInsets.zero,
                child: const Icon(CupertinoIcons.add),
                onPressed: () {
                  _fachHinzufuegen();
                },
              ),
            ),
            faecher.faecher.isEmpty
                ? const Center(
                    child: Text('Füge Fächer hinzu, damit sie hier erscheinen'))
                : CupertinoListSection(
                    children:
                        List<Widget>.generate(faecher.faecher.length, (index) {
                      return CupertinoListTile(
                        title: Text(faecher.faecher[index].name),
                        subtitle: Text(_getSubtitle(faecher.faecher[index])),
                        trailing: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              CupertinoButton(
                                padding: EdgeInsets.zero,
                                child: const Icon(CupertinoIcons.settings),
                                onPressed: () => _fachBearbeiten(index),
                              ),
                              CupertinoButton(
                                padding: EdgeInsets.zero,
                                child: const Icon(CupertinoIcons.minus),
                                onPressed: () => faecher.removeFach(index),
                              ),
                            ]),
                        onTap: () {
                          Navigator.of(context).push(
                            CupertinoPageRoute(
                                builder: (context) => faecher.faecher[index]),
                          );
                        },
                      );
                    }),
                  ),
          ],
        ),
      ),
    );
  }
}
