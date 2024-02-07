// Seite, um ein Fach der Fächerliste hinzuzufügen

import 'package:flutter/cupertino.dart';
import 'package:suppaapp/faecher.dart';
import 'package:suppaapp/globals.dart';
import 'dart:collection';

class FachHinzufuegen extends StatefulWidget {
  const FachHinzufuegen({super.key});

  @override
  State<FachHinzufuegen> createState() => _FachHinzufuegenState();
}

class _FachHinzufuegenState extends State<FachHinzufuegen> {

  int _selectedTag = 0;
  int _selectedStunde = 0;
  final SplayTreeMap<int,SplayTreeSet<int>> _zeiten = SplayTreeMap(); // SplayTreeMap: Automatische Sortierung

  SplayTreeSet<int> _addZeit(int tag, int stunde) {
    if (_zeiten.keys.contains(tag)){ // Wenn der Tag existiert, füge die Stunde hinzu
      SplayTreeSet<int>? myZeiten = _zeiten[tag]; // Nötig, weil sonst Dart meckert
      if (myZeiten == null) {
        return SplayTreeSet();
      }
      myZeiten.add(stunde);
      return myZeiten;
    }
    SplayTreeSet<int> myZeiten = SplayTreeSet();
    myZeiten.add(stunde);
    return myZeiten;
  }

  List<String> getSubtitles(){
    List<String> subtitles = [];
    List<Set<int>> values = _zeiten.values.toList();
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

  @override
  Widget build(BuildContext context){
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: CupertinoNavigationBarBackButton(
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      child: SafeArea(  // Erstellt eine "Knauschzone" um die Ränder des Bildschirms
        minimum: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.1,
          vertical: MediaQuery.of(context).size.height * 0.07
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CupertinoTextField(
              autofocus: true,
              placeholder: 'Fächername',
            ),
            CupertinoButton(
              child: const Text('Zeit hinzufügen'),
              onPressed: () {
                showCupertinoModalPopup(
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
                            itemExtent: 40,
                            scrollController: FixedExtentScrollController(
                              initialItem: _selectedTag,
                            ),
                            onSelectedItemChanged: (int selectedItem) => setState(() => _selectedTag = selectedItem),
                            children: List<Widget>.generate(wochentage.length, (int i) => Center(child: Text(wochentage[i]))),
                          ),
                        ),
                        Expanded(
                          child: CupertinoPicker(
                            magnification: 1.1,
                            useMagnifier: true,
                            itemExtent: 40,
                            scrollController: FixedExtentScrollController(
                              initialItem: _selectedStunde,
                            ),
                            onSelectedItemChanged: (int selectedItem) => setState(() => _selectedStunde = selectedItem),
                            children: List<Widget>.generate(stunden.length, (int i) => Center(child: Text(stunden[i]))),
                          ),
                        ),
                        CupertinoButton(
                          child: const Text('Hinzufügen'),
                          onPressed: () {
                            setState(() {
                              _zeiten[_selectedTag] = _addZeit(_selectedTag, _selectedStunde);
                            });
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }
            ),
            ListView.builder(
              itemExtent: 35,
              shrinkWrap: true,
              itemCount: _zeiten.length,
              itemBuilder:(_, index) {
                return Row(
                  children: [
                    Text(wochentage[_zeiten.keys.toList()[index]]),
                    const Spacer(),
                    Text(getSubtitles()[index]),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}