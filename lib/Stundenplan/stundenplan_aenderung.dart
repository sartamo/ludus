import 'dart:collection';
import 'package:flutter/cupertino.dart';
//import 'package:flutter/services.dart';
import 'package:suppaapp/Faecher/management.dart';
import 'package:suppaapp/Stundenplan/stundenplan_Anzeige.dart';
//import 'package:suppaapp/FaecherEinstellungen/auswahlfunktionen.dart';
import 'package:suppaapp/globals.dart';
import 'package:suppaapp/Stundenplan/stundenplan_Helper.dart';

class StundenplanBearbeiten extends StatefulWidget {
  const StundenplanBearbeiten(
      {super.key,
      required this.zeiten,
      required this.name,
      required this.currentFachIndex //Der Index des Faches, das bearbeitet wird, -1 wenn ein neues Fach hinzugefügt wird (wird nur für die Anzeige benötingt)
      });

  final SplayTreeMap<int, SplayTreeSet<int>> zeiten;
  final String name;
  final int currentFachIndex;
  final double _hoehe = 100; //höhe der Reihen

  @override
  _StundenplanBearbeitenState createState() => _StundenplanBearbeitenState();
}

class _StundenplanBearbeitenState extends State<StundenplanBearbeiten> {
  double breite = 0.0;
  List<List<List<String>>> stundenplanB = [];

  void stundenplanBAktualisieren() {
    aktualisiereStundenplanA();

    stundenplanB = List.generate(
        wochentage.length, (_) => List.generate(stunden.length, (_) => []));
    for (int f = 0; f < faecher.faecher.length; f++) {
      if (f != widget.currentFachIndex) {
        for (int w = 0; w < wochentage.length; w++) {
          SplayTreeSet<int>? myZeiten = faecher.faecher[f].zeiten[w];
          if (myZeiten != null) {
            for (int s in myZeiten) {
              stundenplanA[w][s].add(faecher.faecher[f].name);
            }
          }
        }
      } else {
        for (int w = 0; w < wochentage.length; w++) {
          for (int s = 0; s < stunden.length; s++) {
            if (widget.zeiten[w]?.contains(s) ?? false) {
              stundenplanB[w][s].add(widget.name);
            }
          }
        }
      }
    }

    if (widget.currentFachIndex == -1) {
      for (int w = 0; w < wochentage.length; w++) {
        for (int s = 0; s < stunden.length; s++) {
          if (widget.zeiten[w]?.contains(s) ?? false) {
            stundenplanB[w][s].add(widget.name);
          }
        }
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    stundenplanBAktualisieren();

    double breite = (MediaQuery.of(context).size.width * (1 - 0.1 * 2)) /
        (wochentage.length + 1); //breite der Spalten

    CupertinoButton getAenderungsButton({
      //gibt einen Button zurück
      required int d,
      required int h,
      required int a,
    }) {
      if (stundenplanB[d][h].isEmpty) {
        return CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            if (widget.zeiten.containsKey(d)) {
              if (widget.zeiten[d]!.contains(h)) {
                widget.zeiten[d]?.remove(h);
                stundenplanBAktualisieren();
              } else {
                widget.zeiten[d]?.add(h);
                stundenplanBAktualisieren();
              }
            } else {
              widget.zeiten.putIfAbsent(d, () => SplayTreeSet<int>.from([h]));
              stundenplanBAktualisieren();
            }
          },
          color: stundenplanFreeColor,
          pressedOpacity: 1.0,
          child: const Text('Frei'),
        );
      } else {
        return CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            if (widget.zeiten.containsKey(d)) {
              if (widget.zeiten[d]!.contains(h)) {
                widget.zeiten[d]?.remove(h);
                stundenplanBAktualisieren();
              } else {
                widget.zeiten[d]?.add(h);
                stundenplanBAktualisieren();
              }
            } else {
              widget.zeiten.putIfAbsent(d, () => SplayTreeSet<int>.from([h]));
              stundenplanBAktualisieren();
            }
          },
          color: getFachIndex(d: d, h: h, a: a) == -1
              ? CupertinoColors.activeOrange
              : faecher.faecher[getFachIndex(d: d, h: h, a: a)].farbe,
          pressedOpacity: 1.0,
          child: Text(stundenplanB[d][h][a]),
        );
      }
    }

    List<Widget> tage = List.generate((wochentage.length), (d) {
      //Liste von wochentage.length Collumns it den jewailigen Stunden als CupertinoButton
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: widget._hoehe,
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
            if (stundenplanB[d][h].isEmpty) {
              return SizedBox(
                height: widget._hoehe,
                width: breite,
                child: getAenderungsButton(
                    d: d,
                    h: h,
                    a: 0), //a isn't used here, but is required, if !_stundenplanB[d][h].isEmpty
              );
            } else {
              return SizedBox(
                height: widget._hoehe,
                width: breite,
                child: Row(
                  children: List.generate(stundenplanB[d][h].length, (a) {
                    return Expanded(
                      child: SizedBox(
                        height: widget._hoehe,
                        child: getAenderungsButton(d: d, h: h, a: a),
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

// *
// *
// *

    return Row(
      //main Row
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          // First column (Side Bar)
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: widget._hoehe,
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
                height: widget._hoehe,
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
    );
  }
}
