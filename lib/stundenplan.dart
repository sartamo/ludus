// Seite für den Stundenplan

import 'package:flutter/cupertino.dart';
import 'package:suppaapp/FaecherEinstellungen/hinzufuegen.dart';
import 'package:suppaapp/globals.dart';
import 'package:suppaapp/faecher.dart';

class Stundenplan extends StatefulWidget {
  const Stundenplan({super.key});

  @override
  State<Stundenplan> createState() => _StundenplanState();
}

class _StundenplanState extends State<Stundenplan> {
  final double _hoehe = 100; //höhe der Reihen
  final Color _firstColumnColor =
      CupertinoColors.systemGrey; //Farbe der ersten Spalte und Zeile
  final Color _hourColor =
      CupertinoColors.activeOrange; //Farbe der belegten Stunden
  final Color _freeColor =
      CupertinoColors.systemGrey2; //Farbe der freien Stunden

  List<List<List<String>>> _stundenplanA = List.generate(
      //Äußere Liste: Wochentag, mittlere Liste: Stunde, innere Liste: Nammen der Fächer
      wochentage.length,
      (_) => List.generate(stunden.length, (_) => []));

  void _aktualisiereStundenplan() {
    //aktualisiert _stundenplanA an Hand von facher
    _stundenplanA = List.generate(
        wochentage.length, (_) => List.generate(stunden.length, (_) => []));
    for (int f = 0; f < faecherList.faecher.length; f++) {
      Fach myFach = faecherList.faecher[f];
      for (int w = 0; w < wochentage.length; w++) {
        Set<int>? myZeiten = myFach.zeiten[w];
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
        onPressed: null,
        color: _freeColor,
        disabledColor: _freeColor,
        pressedOpacity: 1.0,
        child: const Text('Frei'),
      );
    } else {
      return CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: () {},
        color: _hourColor,
        disabledColor: _hourColor,
        pressedOpacity: 1.0,
        child: Text(_stundenplanA[d][h][a]),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    faecherList.addListener(() {
      _aktualisiereStundenplan();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    _aktualisiereStundenplan();

    final double breite = MediaQuery.of(context).size.width /
        (wochentage.length + 1); //breite der Spalten

    List<Widget> tage = List.generate((wochentage.length), (d) {  //Liste von wochentage.length Collumns it den jewailigen Stunden als CupertinoButton
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
          }).toList(),
        ],
      );
    }).toList();

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      child: SingleChildScrollView(
        child: Column(
          children: [
            CupertinoNavigationBar(
              middle: const Text('Stundenplan'),
              trailing: CupertinoButton(
                padding: EdgeInsets.zero,
                child: const Icon(CupertinoIcons.settings),
                onPressed: () {
                  showCupertinoModalPopup(
                    context: context,
                    builder: (BuildContext context) => CupertinoActionSheet(
                      title: const Text('Settings'),
                      message: const Text('Select an option'),
                      actions: <CupertinoActionSheetAction>[
                        CupertinoActionSheetAction(
                          child: const Text('Ändere den Stundenplan'),
                          onPressed: () {
                            Navigator.pop(context, 'Option 1');
                            // Add your code for Option 1 here
                          },
                        ),
                        CupertinoActionSheetAction(
                          child: const Text('Füge Fach hinzu'),
                          onPressed: () {
                            result() async {
                              Navigator.pop(context);
                              return await Navigator.of(context).push(
                                CupertinoPageRoute(
                                    builder: (context) =>
                                        const FachHinzufuegen()),
                              );
                            }

                            result().then((output) {
                              setState(() => faecherList.addFach(output));
                            });
                          },
                        ),
                        // Add more options here
                      ],
                      cancelButton: CupertinoActionSheetAction(
                        child: const Text('Cancel'),
                        onPressed: () {
                          Navigator.pop(context, 'Cancel');
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            Row(
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
                    }).toList(),
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
