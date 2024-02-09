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
  final double _hoehe = 100;
  final Color _firstColumnColor = CupertinoColors.systemGrey;
  final Color _hourColor = CupertinoColors.activeOrange;
  final Color _freeColor = CupertinoColors.systemGrey2;

  final List<List<String>> _stundenplanA = List.generate(
      wochentage.length, (_) => List.filled(stunden.length, ''));

  void _aktualisiereStundenplan(List<List<String>> stundenplanA) {
    for (int f = 0; f < faecherList.faecher.length; f++) {
      Fach myFach = faecherList.faecher[f];
      for (int w = 0; w < wochentage.length; w++) {
        Set<int>? myZeiten = myFach.zeiten[w];
        if (myZeiten != null) {
          for (int s in myZeiten) {
            stundenplanA[w][s] = myFach.name;
          }
        }
      }
    }
  }

  @override
  void initState () {
    super.initState();
    faecherList.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    _aktualisiereStundenplan(_stundenplanA);

    final double breite = MediaQuery.of(context).size.width / (wochentage.length + 1);

    List<Widget> tage = List.generate((wochentage.length), (index) {
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
              child: Text(wochentage[index]), // Display the value of 'tag'
            ),
          ),
          ...List.generate(stunden.length, (index2) {
            if (_stundenplanA[index][index2] == '') {
              return SizedBox(
                height: _hoehe,
                width: breite,
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: null,
                  color: _freeColor,
                  disabledColor: _freeColor,
                  pressedOpacity: 1.0,
                  child: const Text('Frei'), // Display the value of 'tag'
                ),
              );
            } else {
              return SizedBox(
                height: _hoehe,
                width: breite,
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {},
                  color: _hourColor,
                  disabledColor: _hourColor,
                  pressedOpacity: 1.0,
                  child: Text(_stundenplanA[index]
                      [index2]), // Display the value of 'tag'
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
