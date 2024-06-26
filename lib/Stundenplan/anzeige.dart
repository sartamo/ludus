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
  final EdgeInsetsGeometry _buttonPadding = const EdgeInsets.all(1.1);  //Weißer Rand um jeden Button
  final BorderRadius _buttonRandRaduis = const BorderRadius.all(Radius.circular(2));  //Radius der Abrundung der Ecken der Buttons

  List<Column> getTage(double breite) {
    return List.generate((wochenendeNotifier.value == true ? 7: 5), (d) {
      //Liste von wochenendeNotifier.value == true ? 7: 5 Collumns it den jewailigen Stunden als CupertinoButton
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
            if (stundenplanA[d][h].isEmpty) {
              return SizedBox(
                height: breite*stundenplanHoeheNotifier.value,
                width: breite,
                child: Padding(padding: _buttonPadding, child:  getButton(
                    context: context,
                    changingFach: -1,
                    d: d,
                    h: h,
                    a: 0, //a isn't used here, but is required, if !_stundenplanA[d][h].isEmpty
                    buttonRandRaduis: _buttonRandRaduis),),
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
                        child: Padding(padding: _buttonPadding, child:  getButton(
                            context: context,
                            changingFach: -1,
                            d: d,
                            h: h,
                            a: a,
                            buttonRandRaduis: _buttonRandRaduis,),
                      ),
                    ),);
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
  
  void _updateState() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    stundenplanHoeheNotifier.addListener(_updateState);
    wochenendeNotifier.addListener(_updateState);
    anzahlStundenNotifier.addListener(_updateState);
    faecher.addListener(_updateState);
  }

  @override
  void dispose() {
    super.dispose();
    stundenplanHoeheNotifier.removeListener(_updateState);
    wochenendeNotifier.removeListener(_updateState);
    anzahlStundenNotifier.removeListener(_updateState);
    faecher.removeListener(_updateState);
  }

  @override
  Widget build(BuildContext context) {
    aktualisiereStundenplanA();

    double breite = MediaQuery.of(context).size.width * (1 - 2 * widthMultiplier) /
        ((wochenendeNotifier.value == true ? 7: 5)+1); //breite der Spalten

    List<Widget> tage = getTage(breite);

    return CupertinoPageScaffold(
      //main Widget
      navigationBar: CupertinoNavigationBar(
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
        ],),
      ),
      child: SingleChildScrollView(
        child: SafeArea(
          minimum: EdgeInsets.only(
          right: MediaQuery.of(context).size.width * widthMultiplier,
          left: MediaQuery.of(context).size.width *
              widthMultiplier, // Geändert zu Variable in globals.dart
          top: const CupertinoNavigationBar().preferredSize.height
              + View.of(context).physicalSize.height * heightMultiplier,
          ),
          child: Row(
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
                    ),
                  ),),
                  ...List.generate(anzahlStundenNotifier.value, (stunde) {
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
          ),
        ),
      ),
    );
  }
}
