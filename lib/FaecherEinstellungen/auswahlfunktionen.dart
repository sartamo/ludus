// Grundliegende Funktionen der Fächerfunktionen, die von allen Seiten aufgerufen werden

import 'package:flutter/cupertino.dart';
import 'package:suppaapp/globals.dart';
import 'dart:collection';

Future<(int, int, bool)> zeitenAuswahl(
    // Gibt zurück: Tag, Stunde, und ob der User abgebrochen ab
    BuildContext context,
    int selectedTag,
    int selectedStunde) async {
  bool auswahl = false;
  await showCupertinoModalPopup(
    context: context,
    builder: (context) => Container(
      height: MediaQuery.of(context).size.height / 3.5,
      width: MediaQuery.of(context).size.width * 0.9,
      padding: const EdgeInsets.only(top: 6.0),
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      color: CupertinoColors.systemBackground.resolveFrom(context),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CupertinoButton(
            child: const Text('Abbrechen'),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: CupertinoPicker(
              magnification: 1.1,
              useMagnifier: true,
              itemExtent: 45,
              scrollController: FixedExtentScrollController(
                initialItem: selectedTag,
              ),
              onSelectedItemChanged: (int selectedItem) =>
                  selectedTag = selectedItem,
              children: List<Widget>.generate(wochentage.length,
                  (int i) => Center(child: Text(wochentage[i]))),
            ),
          ),
          Expanded(
            child: CupertinoPicker(
              magnification: 1.1,
              useMagnifier: true,
              itemExtent: 45,
              scrollController: FixedExtentScrollController(
                initialItem: selectedStunde,
              ),
              onSelectedItemChanged: (int selectedItem) =>
                  selectedStunde = selectedItem,
              children: List<Widget>.generate(
                  stunden.length, (int i) => Center(child: Text(stunden[i]))),
            ),
          ),
          CupertinoButton(
              child: const Text('Hinzufügen'),
              onPressed: () {
                auswahl = true;
                Navigator.pop(context);
              }),
        ],
      ),
    ),
  );
  return (selectedTag, selectedStunde, auswahl);
}

SplayTreeSet<int> addZeit(
    SplayTreeMap<int, SplayTreeSet<int>> zeiten, int tag, int stunde) {
  // Wenn der Tag existiert, füge die Stunde hinzu
  SplayTreeSet<int>? myZeiten = zeiten[tag]; // Nötig, weil sonst Dart meckert
  if (myZeiten != null) {
    myZeiten.add(stunde);
    return myZeiten;
  } else {
    myZeiten = SplayTreeSet();
    myZeiten.add(stunde);
    return myZeiten;
  }
}

List<String> getSubtitles(SplayTreeMap<int, SplayTreeSet<int>> zeiten) {
  List<String> subtitles = [];
  List<Set<int>> values = zeiten.values.toList();
  for (Set<int> s in values) {
    String subtitle = '';
    int counter = 0;
    for (int i in s) {
      if (counter != 0) {
        subtitle += ', ';
      }
      counter++;
      subtitle += stunden[i];
    }
    subtitles.add(subtitle);
  }
  return subtitles;
}
