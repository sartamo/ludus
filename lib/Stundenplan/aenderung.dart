import 'dart:collection';
import 'package:flutter/cupertino.dart';
//import 'package:flutter/services.dart';
import 'package:suppaapp/FaecherEinstellungen/farb_slider.dart';
import 'package:suppaapp/Faecher/management.dart';
// import 'package:suppaapp/Stundenplan/anzeige.dart';
//import 'package:suppaapp/FaecherEinstellungen/auswahlfunktionen.dart';
import 'package:suppaapp/globals.dart';
import 'package:suppaapp/Stundenplan/helper.dart';

class StundenplanBearbeiten extends StatefulWidget {
  const StundenplanBearbeiten({
    super.key,
    required this.zeiten,
    required this.name,
    required this.currentFachIndex, //Der Index des Faches, das bearbeitet wird, -1 wenn ein neues Fach hinzugefügt wird (wird nur für die Anzeige benötingt)
    required this.farbe,
    required this.colorNotifier,
  });

  final ValueNotifier<bool> colorNotifier;
  final SplayTreeMap<int, SplayTreeSet<int>> zeiten;
  final String name;
  final int currentFachIndex;
  final MutableFarbe farbe;

  @override
  State<StundenplanBearbeiten> createState() => StundenplanBearbeitenState();
}

class StundenplanBearbeitenState extends State<StundenplanBearbeiten> {
  double breite = 0.0;
  List<List<List<String>>> stundenplanB = [];
  final EdgeInsetsGeometry _buttonPadding = const EdgeInsets.all(1.1);  //Weißer Rand um jeden Button
  final BorderRadius _buttonRandRaduis = const BorderRadius.all(Radius.circular(2));  //Radius der Abrundung der Ecken der Buttons

  void stundenplanBAktualisieren() {
    stundenplanB = List.generate(
        (wochenendeNotifier.value == true ? 7: 5), (_) => List.generate(anzahlStundenNotifier.value, (_) => []));
    for (int f = 0; f < faecher.faecher.length; f++) {
      if (f != widget.currentFachIndex) {
        for (int w = 0; w < (wochenendeNotifier.value == true ? 7: 5); w++) {
          SplayTreeSet<int>? myZeiten = faecher.faecher[f].zeiten[w];
          if (myZeiten != null) {
            for (int s in myZeiten) {
              if (s < anzahlStundenNotifier.value) {
                stundenplanB[w][s].add(faecher.faecher[f].name);
              }
            }
          }
        }
      } else {
        for (int w = 0; w < (wochenendeNotifier.value == true ? 7: 5); w++) {
          for (int s = 0; s < anzahlStundenNotifier.value; s++) {
            if (widget.zeiten[w]?.contains(s) ?? false) {
              if (s < anzahlStundenNotifier.value) {
                stundenplanB[w][s].add(widget.name);
              }
            }
          }
        }
      }
    }

    if (widget.currentFachIndex == -1) {
      for (int w = 0; w < (wochenendeNotifier.value == true ? 7: 5); w++) {
        for (int s = 0; s < anzahlStundenNotifier.value; s++) {
          if (widget.zeiten[w]?.contains(s) ?? false) {
            if (s < anzahlStundenNotifier.value) {
              stundenplanB[w][s].add(widget.name);
            }
          }
        }
      }
    }

    _updateState();
  }

  void _updateState() {
    if (mounted) {
      setState(() {});
    }
  }


  @override
  void initState() {
    super.initState();
    stundenplanBAktualisieren();
    
    stundenplanHoeheNotifier.addListener(_updateState);
    wochenendeNotifier.addListener(_updateState);
    anzahlStundenNotifier.addListener(_updateState);
    widget.colorNotifier.addListener(_updateState);
  }

  @override
  void dispose() {
    stundenplanHoeheNotifier.removeListener(_updateState);
    wochenendeNotifier.removeListener(_updateState);
    anzahlStundenNotifier.removeListener(_updateState);
    widget.colorNotifier.removeListener(_updateState);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    stundenplanBAktualisieren();

    double breite = (MediaQuery.of(context).size.width * (1 - widthMultiplier * 2)) /
        ((wochenendeNotifier.value == true ? 7: 5) + 1); //breite der Spalten

    CupertinoButton getAenderungsButton({
      //gibt einen Button zurück
      required int d,
      required int h,
      required int a,
    }) {
      if (stundenplanB[d][h].isEmpty) {
        return CupertinoButton(
          borderRadius: _buttonRandRaduis,
          padding: const EdgeInsets.all(3),
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
          borderRadius: _buttonRandRaduis,
          padding: const EdgeInsets.all(3),
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
          color: getFachIndex(d: d, h: h, a: a) == -1 ||
                  getFachIndex(d: d, h: h, a: a) == widget.currentFachIndex
              ? widget.farbe.farbe
              : faecher.faecher[getFachIndex(d: d, h: h, a: a)].farbe,
          pressedOpacity: 1.0,
          child: Text(stundenplanB[d][h][a], maxLines: 1, overflow: TextOverflow.ellipsis,),
        );
      }
    }

    List<Widget> tage = List.generate(((wochenendeNotifier.value == true ? 7: 5)), (d) {
      //Liste von (wochenendeNotifier.value == true ? 7: 5) Collumns it den jewailigen Stunden als CupertinoButton
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: breite*stundenplanHoeheNotifier.value,
            width: breite,
            child: Padding(padding: _buttonPadding, child: CupertinoButton(
              borderRadius: _buttonRandRaduis,
              padding: const EdgeInsets.all(3),
              onPressed: null,
              color: stundenplanFirstColumnColor,
              disabledColor: stundenplanFirstColumnColor,
              pressedOpacity: 1.0,
              child: Text(wochentage[
                  d], maxLines: 1, overflow: TextOverflow.ellipsis,), // d is the index of the day; h is the index of the hour; a is the index of the subject (if there are multiple subjects in one hour)
            ),),
          ),
          ...List.generate(anzahlStundenNotifier.value, (h) {
            if (stundenplanB[d][h].isEmpty) {
              return SizedBox(
                height: breite*stundenplanHoeheNotifier.value,
                width: breite,
                child: Padding(padding: _buttonPadding, child: getAenderungsButton(
                    d: d,
                    h: h,
                    a: 0),), //a isn't used here, but is required, if !_stundenplanB[d][h].isEmpty
              );
            } else {
              return SizedBox(
                height: breite*stundenplanHoeheNotifier.value,
                width: breite,
                child: Row(
                  children: List.generate(stundenplanB[d][h].length, (a) {
                    return Expanded(
                      child: SizedBox(
                        height: breite*stundenplanHoeheNotifier.value,
                        child: Padding(padding: _buttonPadding, child: getAenderungsButton(d: d, h: h, a: a),
                      ),),
                    );
                  }),
                ),
              );
            }
          })
        ],
      );
    }).toList();

    //
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
              height: breite*stundenplanHoeheNotifier.value,
              width: breite,
              child: Padding(padding: _buttonPadding, child: CupertinoButton(
                borderRadius: _buttonRandRaduis,
                padding: const EdgeInsets.all(3),
                onPressed: null,
                color: stundenplanFirstColumnColor,
                disabledColor: stundenplanFirstColumnColor,
                pressedOpacity: 1.0,
                child: const Text(''),
              ),),
            ),
            ...List.generate(anzahlStundenNotifier.value,(stunde) {
              return SizedBox(
                height: breite*stundenplanHoeheNotifier.value,
                width: breite,
                child: Padding(padding: _buttonPadding, child: CupertinoButton(
                  borderRadius: _buttonRandRaduis,
                  padding: const EdgeInsets.all(3),
                  onPressed: null,
                  color: stundenplanFirstColumnColor,
                  disabledColor: stundenplanFirstColumnColor,
                  pressedOpacity: 1.0,
                  child: Text(stunden[stunde], maxLines: 1, overflow: TextOverflow.ellipsis,),
                ),),
              );
            })
          ],
        ),
        ...tage
      ],
    );
  }
}
