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
//import 'package:suppaapp/Faecher/faecher.dart';
import 'package:suppaapp/Stundenplan/stundenplan_Helper.dart';

class Stundenplan extends StatefulWidget {
  const Stundenplan({super.key});

  @override
  State<Stundenplan> createState() => _StundenplanState();
}

class _StundenplanState extends State<Stundenplan> {
  final double _hoehe = 100; //höhe der Reihen
  int _changingFach =
      -1; //index des Fachs, von dem grade die Stunden geändert werden wenn -1 kein Fach wird geändert

  List<Widget> getTage(double breite) {
    return List.generate((wochentage.length), (d) {
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
              color: stundenplanFirstColumnColor,
              disabledColor: stundenplanFirstColumnColor,
              pressedOpacity: 1.0,
              child: Text(wochentage[
                  d]), // d is the index of the day; h is the index of the hour; a is the index of the subject (if there are multiple subjects in one hour)
            ),
          ),
          ...List.generate(stunden.length, (h) {
            if (stundenplanA[d][h].isEmpty) {
              return SizedBox(
                height: _hoehe,
                width: breite,
                child: getButton(
                    context: context,
                    changingFach: _changingFach,
                    d: d,
                    h: h,
                    a: 0), //a isn't used here, but is required, if !_stundenplanA[d][h].isEmpty
              );
            } else {
              return SizedBox(
                height: _hoehe,
                width: breite,
                child: Row(
                  children: List.generate(stundenplanA[d][h].length, (a) {
                    return Expanded(
                      child: SizedBox(
                        height: _hoehe,
                        child: getButton(
                            context: context,
                            changingFach: _changingFach,
                            d: d,
                            h: h,
                            a: a),
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
    aktualisiereStundenplan();

    final double breite = MediaQuery.of(context).size.width /
        (wochentage.length + 1); //breite der Spalten

    List<Widget> tage = getTage(breite);

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
                      child: const CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: null,
                        color: stundenplanFirstColumnColor,
                        disabledColor: stundenplanFirstColumnColor,
                        pressedOpacity: 1.0,
                        child: Text(''),
                      ),
                    ),
                    ...stunden.map((stunde) {
                      return SizedBox(
                        height: _hoehe,
                        width: breite,
                        child: CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: null,
                          color: stundenplanFirstColumnColor,
                          disabledColor: stundenplanFirstColumnColor,
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
