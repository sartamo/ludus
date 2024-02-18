// Seite für den Stundenplan

//import 'dart:js_interop';
//import 'dart:async';
import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:suppaapp/FaecherEinstellungen/hinzufuegen.dart';
//import 'package:suppaapp/faecherliste.dart';
import 'package:suppaapp/globals.dart';
import 'package:suppaapp/Faecher/management.dart';
import 'package:suppaapp/Faecher/faecher.dart';

class Stundenplan extends StatefulWidget {
  const Stundenplan({super.key});

  @override
  State<Stundenplan> createState() => _StundenplanState();
}

class _StundenplanState extends State<Stundenplan> {
  final double _hoehe = 100; //höhe der Reihen
  final Color _firstColumnColor =
      CupertinoColors.systemGrey; //Farbe der ersten Spalte und Zeile
  /*final Color _hourColor =
      CupertinoColors.activeOrange; //Farbe der belegten Stunden*/
  final Color _freeColor =
      CupertinoColors.systemGrey2; //Farbe der freien Stunden
  int _changingFach =
      -1; //index des Fachs, von dem grade die Stunden geändert werden wenn -1 kein Fach wird geändert

  List<List<List<String>>> _stundenplanA = List.generate(
      //Äußere Liste: Wochentag, mittlere Liste: Stunde, innere Liste: Nammen der Fächer
      wochentage.length,
      (_) => List.generate(stunden.length, (_) => []));

  void _aktualisiereStundenplan() {
    //aktualisiert _stundenplanA an Hand von facher
    _stundenplanA = List.generate(
        wochentage.length, (_) => List.generate(stunden.length, (_) => []));
    for (int f = 0; f < faecher.faecher.length; f++) {
      Fach myFach = faecher.faecher[f];
      for (int w = 0; w < wochentage.length; w++) {
        SplayTreeSet<int>? myZeiten = myFach.zeiten[w];
        if (myZeiten != null) {
          for (int s in myZeiten) {
            _stundenplanA[w][s].add(myFach.name);
          }
        }
      }
    }
  }

  CupertinoButton _getButton({
    //gibt einen Button zurück
    required int d,
    required int h,
    required int a,
  }) {
    if (_stundenplanA[d][h].isEmpty) {
      return CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: _changingFach == -1
            ? null
            : () => _clickButton(
                d: d,
                h: h,
                a: a), //if _changingFach == -1, onPressed is null, else onPressed is _clickButton
        color: _freeColor,
        disabledColor: _freeColor,
        pressedOpacity: 1.0,
        child: const Text('Frei'),
      );
    } else {
      return CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: () {
          _clickButton(d: d, h: h, a: a);
        },
        color: faecher.faecher[_getFachIndex(d: d, h: h, a: a)].farbe,
        //disabledColor: _hourColor,
        pressedOpacity: 1.0,
        child: Text(_stundenplanA[d][h][a]),
      );
    }
  }

  void _clickButton({
    required int d,
    required int h,
    required int a,
  }) {
    if (_changingFach == -1) {
      int index = _getFachIndex(d: d, h: h, a: a);
      if (index != -1) {
        Navigator.of(context).push(
          CupertinoPageRoute(builder: (context) => faecher.faecher[index]),
        );
      }
    } else {
      SplayTreeMap<int, SplayTreeSet<int>> zeiten =
          SplayTreeMap.from(faecher.faecher[_changingFach].zeiten);
      Fach currentFach = faecher.faecher[_changingFach];
      if (zeiten[d]?.contains(h) ?? false) {
        //Wenn das Fach bereits in der Stunde eingetragen ist, wird es entfernt
        SplayTreeSet<int> tempZeitenSet = SplayTreeSet.from(zeiten[d] ?? {});
        tempZeitenSet.remove(h);
        zeiten[d] = tempZeitenSet;
        faecher.updateFach(
            index: _changingFach, name: currentFach.name, zeiten: zeiten);
      } else {
        //Wenn das Fach noch nicht in der Stunde eingetragen ist, wird es hinzugefügt
        if (zeiten[d] == null) {
          zeiten[d] = SplayTreeSet.from({h});
          faecher.updateFach(
              index: _changingFach, name: currentFach.name, zeiten: zeiten);
        } else {
          SplayTreeSet<int> tempZeitenSet = SplayTreeSet.from(zeiten[d] ?? {});
          tempZeitenSet.add(h);
          zeiten[d] = tempZeitenSet;
          faecher.updateFach(
              index: _changingFach, name: currentFach.name, zeiten: zeiten);
        }
      }
    }
  }

  Tooltip _changeFachButton() {
    if (_changingFach == -1) {
      return Tooltip(
        message: 'Stundenplan ändern',
        child: CupertinoButton(
            padding: EdgeInsets.zero,
            child: const Icon(CupertinoIcons.table_badge_more),
            onPressed: () {
              showCupertinoModalPopup(
                  context: context,
                  builder: ((context) => CupertinoActionSheet(
                        title: const Text('Fach auswählen'),
                        message: const Text(
                            'Wähle ein Fach aus und dücke dann im Stundenplan auf die Stunden, an denen du das gewählte Fach hizufügen oder entfernen möchtest.'),
                        actions: List.generate(faecher.faecher.length, (f) {
                          return CupertinoActionSheetAction(
                            onPressed: () {
                              setState(() {
                                _changingFach = f;
                                Navigator.pop(context);
                              });
                            },
                            child: Text(faecher.faecher[f].name),
                          );
                        }),
                        cancelButton: CupertinoActionSheetAction(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Abbrechen'),
                        ),
                      )));
            }),
      );
    } else {
      return Tooltip(
        message: 'Speichern',
        child: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.checkmark),
          onPressed: () {
            setState(() {
              _changingFach = -1;
            });
          },
        ),
      );
    }
  }

  Widget _getTitle() {
    if (_changingFach == -1) {
      return const Text('Stundenplan');
    } else {
      TextPainter textPainter = TextPainter(
        text: TextSpan(
            text: faecher.faecher[_changingFach].name,
            style: DefaultTextStyle.of(context).style),
        maxLines: 1,
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();

      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Drücke auf alle Stunden, in denen du '),
          SizedBox(
            width: textPainter.width + 16,
            child: CupertinoTextField(
              placeholder: faecher.faecher[_changingFach].name,
              onChanged: (newName) => faecher.updateFach(
                  index: _changingFach,
                  name: newName,
                  zeiten: faecher.faecher[_changingFach].zeiten),
            ),
          ),
          const Text(' hast.')
        ],
      );
    }
  }

  int _getFachIndex({required int d, required int h, required int a}) {
    int o = -1;
    for (int f = 0; f < faecher.faecher.length; f++) {
      if (faecher.faecher[f].zeiten[d]?.contains(h) ?? false) {
        o++;
        if (a == o) {
          return f;
        }
      }
    }
    return -1;
  }

  @override
  void initState() {
    super.initState();
    faecher.addListener(() {
      _aktualisiereStundenplan();
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
    _aktualisiereStundenplan();

    final double breite = MediaQuery.of(context).size.width /
        (wochentage.length + 1); //breite der Spalten

    List<Widget> tage = List.generate((wochentage.length), (d) {
      //Liste von wochentage.length Collumns it den jewailigen Stunden als CupertinoButton
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: _hoehe,
            width: breite,
            child: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: null,
              color: _firstColumnColor,
              disabledColor: _firstColumnColor,
              pressedOpacity: 1.0,
              child: Text(wochentage[
                  d]), // d is the index of the day; h is the index of the hour; a is the index of the subject (if there are multiple subjects in one hour)
            ),
          ),
          ...List.generate(stunden.length, (h) {
            if (_stundenplanA[d][h].isEmpty) {
              return SizedBox(
                height: _hoehe,
                width: breite,
                child: _getButton(
                    d: d,
                    h: h,
                    a: 0), //a isn't used here, but is required, if !_stundenplanA[d][h].isEmpty
              );
            } else {
              return SizedBox(
                height: _hoehe,
                width: breite,
                child: Row(
                  children: List.generate(_stundenplanA[d][h].length, (a) {
                    return Expanded(
                      child: SizedBox(
                        height: _hoehe,
                        child: _getButton(d: d, h: h, a: a),
                      ),
                    );
                  }),
                ),
              );
            }
          })
        ],
      );
    }).toList();

    return Padding(
      //main Widget
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      child: SingleChildScrollView(
        child: Column(
          children: [
            CupertinoNavigationBar(
              middle: Stack(alignment: Alignment.center, children: [
                _getTitle(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _changeFachButton(),
                    Tooltip(
                      message: 'Fach hinzufügen',
                      child: CupertinoButton(
                          padding: EdgeInsets.zero,
                          child: const Icon(CupertinoIcons.add),
                          onPressed: () async {
                            (
                              String,
                              SplayTreeMap<int, SplayTreeSet<int>>
                            )? result = await Navigator.of(context).push(
                                CupertinoPageRoute(
                                    builder: (context) =>
                                        const FachHinzufuegen()));
                            if (result != null) {
                              faecher.addFach(
                                  name: result.$1,
                                  zeiten: result.$2,
                                  farbe: CupertinoColors.activeOrange);
                            }
                          }),
                    ),
                  ],
                ),
              ]),
            ),
            Row(
              //main Row
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  // First column (Side Bar)
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: _hoehe,
                      width: breite,
                      child: CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: null,
                        color: _firstColumnColor,
                        disabledColor: _firstColumnColor,
                        pressedOpacity: 1.0,
                        child: const Text(''),
                      ),
                    ),
                    ...stunden.map((stunde) {
                      return SizedBox(
                        height: _hoehe,
                        width: breite,
                        child: CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: null,
                          color: _firstColumnColor,
                          disabledColor: _firstColumnColor,
                          pressedOpacity: 1.0,
                          child: Text(stunde),
                        ),
                      );
                    })
                  ],
                ),
                ...tage
              ],
            ),
          ],
        ),
      ),
    );
  }
}
