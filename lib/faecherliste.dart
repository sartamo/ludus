// Die Seite für die Fächerliste

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
//import 'package:flutter/rendering.dart';
//import 'package:flutter/widgets.dart';
import 'package:suppaapp/FaecherEinstellungen/hinzufuegen.dart';
import 'package:suppaapp/FaecherEinstellungen/bearbeiten.dart';
import 'package:suppaapp/Faecher/faecher.dart';
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
    (String, SplayTreeMap<int, SplayTreeSet<int>>, Color)? result =
        await Navigator.of(context).push(
            CupertinoPageRoute(builder: (context) => const FachHinzufuegen()));
    if (result != null) {
      faecher.addFach(
        name: result.$1,
        zeiten: result.$2,
        farbe: result.$3,
      );
    }
  }

  Future<void> _fachBearbeiten(int index) async {
    (String, SplayTreeMap<int, SplayTreeSet<int>>, Color)? result =
        await Navigator.of(context).push(CupertinoPageRoute(
            builder: (context) => FachBearbeiten(faecher.faecher[index])));
    if (result != null) {
      faecher.updateFach(
        index: index,
        name: result.$1,
        zeiten: result.$2,
        farbe: result.$3,
      );
    }
  }

  @override
  void initState() {
    super.initState();

    faecher.addListener(() {
      if (mounted) {
        // Ruft setState nur auf, wenn das Widget angezeigt wird
        setState(() {});
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
                ? const Column(
                    children: <Widget>[
                      SizedBox(
                        height: 20,
                      ),
                      Text('Füge Fächer hinzu, damit sie hier erscheinen'),
                    ],
                  )
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
                                  onPressed: () {
                                    showCupertinoDialog(
                                      context: context,
                                      builder: (context) =>
                                          CupertinoAlertDialog(
                                        title: Text(
                                            '${faecher.faecher[index].name} löschen?'),
                                        content: Text(
                                            'Sind Sie sicher, dass Sie das Fach ${faecher.faecher[index].name} löschen möchten?'),
                                        actions: [
                                          CupertinoDialogAction(
                                            isDefaultAction: true,
                                            child: const Text('Abbrechen'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          CupertinoDialogAction(
                                            isDestructiveAction: true,
                                            child: const Text('Löschen'),
                                            onPressed: () {
                                              faecher.removeFach(index);
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
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
