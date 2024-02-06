// Seite, um ein Fach der Fächerliste hinzuzufügen

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:suppaapp/faecher.dart';
import 'package:suppaapp/globals.dart';

class FachHinzufuegen extends StatefulWidget {
  const FachHinzufuegen({super.key});

  @override
  State<FachHinzufuegen> createState() => _FachHinzufuegenState();
}

class _FachHinzufuegenState extends State<FachHinzufuegen> {

  int _selectedTag = 0;
  int _selectedStunde = 0;

  Map<int,List<int>> _zeiten = {0 : [1, 3], 2 : [0, 4]};

  List<Widget> _getListTiles(){
    List<Widget> listTiles = [];
    for (int i in List.generate(wochentage.length, (int index) => index)) {
      List<int>? myStunden = _zeiten[i];
      if (myStunden != null) {
        String mySubtitle = '';
        int counter = 0;
        for (int j in myStunden) {
          if (counter != 0) {
            mySubtitle += ', ';
          }
          counter++;
          mySubtitle += stunden[myStunden[j]];
        }
        listTiles.add(
          CupertinoListTile(
            title: Text(wochentage[i]),
            subtitle: Text(mySubtitle),
          ),
        );
      }
    }
    return listTiles;
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
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    )
                  ),
                );
              }
            ),
            
          ],
        ),
      ),
    );
  }
}