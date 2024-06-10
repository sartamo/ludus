// Seite für den Stundenplan

import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:suppaapp/FaecherEinstellungen/hinzufuegen.dart';
import 'package:suppaapp/FaecherEinstellungen/bearbeiten.dart';
import 'package:suppaapp/globals.dart';
import 'package:suppaapp/Faecher/management.dart';
import 'package:suppaapp/Stundenplan/helper.dart';

class Stundenplan extends StatefulWidget {
  const Stundenplan({super.key});

  @override
  State<Stundenplan> createState() => _StundenplanState();
}

class _StundenplanState extends State<Stundenplan> {
  final EdgeInsetsGeometry _buttonPadding = const EdgeInsets.all(0);

  List<Column> getTage(double breite) {
    return List.generate((wochentage.length), (d) {
      //Liste von wochentage.length Collumns it den jewailigen Stunden als CupertinoButton
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: breite*stundenplanHoeheNotifier.value,
            width: breite,
            child: Padding(padding: _buttonPadding, child: CupertinoButton(
              padding: const EdgeInsets.all(3),
              onPressed: null,
              color: stundenplanFirstColumnColor,
              disabledColor: stundenplanFirstColumnColor,
              pressedOpacity: 1.0,
              child: Text(wochentage[
                  d], maxLines: 1, overflow: TextOverflow.ellipsis,), // d is the index of the day; h is the index of the hour; a is the index of the subject (if there are multiple subjects in one hour)
            ),),
          ),
          ...List.generate(stunden.length, (h) {
            if (stundenplanA[d][h].isEmpty) {
              return SizedBox(
                height: breite*stundenplanHoeheNotifier.value,
                width: breite,
                child: Padding(padding: _buttonPadding, child:  getButton(
                    context: context,
                    changingFach: -1,
                    d: d,
                    h: h,
                    a: 0),), //a isn't used here, but is required, if !_stundenplanA[d][h].isEmpty
              );
            } else {
              return SizedBox(
                height: breite*stundenplanHoeheNotifier.value,
                width: breite,
                child: Row(
                  children: List.generate(stundenplanA[d][h].length, (a) {
                    return Expanded(
                      child: SizedBox(
                        height: breite*stundenplanHoeheNotifier.value,
                        child: getButton(
                            context: context,
                            changingFach: -1,
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

//Zeigt ein Popup, in dem man das Fach auswählen kann, das man bearbeiten will
  Future<int> showPopup() async {
    int chosenFach = -1;
    await showCupertinoModalPopup(
      context: context,
      builder: ((context) => CupertinoActionSheet(
            title: const Text('Fach auswählen'),
            message: const Text(
                'Wähle ein Fach aus, das du bearbeiten möchtest.'),
            actions: List.generate(faecher.faecher.length, (f) {
              return CupertinoActionSheetAction(
                onPressed: () {
                  chosenFach = f;
                  Navigator.pop(context);
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
          )),
    );
    return chosenFach;
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
    stundenplanHoeheNotifier.addListener(() {
      setState(() {});
    });
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
    stundenplanHoeheNotifier.removeListener(() {});
    faecher.removeListener(() {});
  }

  @override
  Widget build(BuildContext context) {
    aktualisiereStundenplanA();

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
                const Text('Stundenplan'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Tooltip(
                      message: 'Fach bearbeiten',
                      child: CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: const Icon(CupertinoIcons.table_badge_more),
                        onPressed: () async {
                          int index = await showPopup();
                          if(index != -1) {
                            _fachBearbeiten(index);
                          }
                        },
                      ),
                    ),
                    Tooltip(
                      message: 'Fach hinzufügen',
                      child: CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: const Icon(CupertinoIcons.add),
                        onPressed: () => _fachHinzufuegen(),
                      ),
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
                      height: breite*stundenplanHoeheNotifier.value,
                      width: breite,
                      child: Padding(padding: _buttonPadding, child: const CupertinoButton(
                        padding: EdgeInsets.all(3),
                        onPressed: null,
                        color: stundenplanFirstColumnColor,
                        disabledColor: stundenplanFirstColumnColor,
                        pressedOpacity: 1.0,
                        child: Text(''),
                      ),
                    ),),
                    ...stunden.map((stunde) {
                      return SizedBox(
                        height: breite*stundenplanHoeheNotifier.value,
                        width: breite,
                        child: Padding(padding: _buttonPadding, child: CupertinoButton(
                          padding: const EdgeInsets.all(3),
                          onPressed: null,
                          color: stundenplanFirstColumnColor,
                          disabledColor: stundenplanFirstColumnColor,
                          pressedOpacity: 1.0,
                          child: Text(stunde, maxLines: 1, overflow: TextOverflow.ellipsis,),
                        ),),
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
