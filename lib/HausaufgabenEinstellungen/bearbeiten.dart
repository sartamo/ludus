// Seite, um eine Hausaufgbe zu bearbeiten

import 'package:flutter/cupertino.dart';
import 'package:suppaapp/FaecherEinstellungen/auswahlfunktionen.dart';
import 'package:suppaapp/faecher.dart';
import 'package:suppaapp/globals.dart';
import 'dart:collection';

class FachBearbeiten extends StatefulWidget {
  final Fach fach;

  const FachBearbeiten(this.fach, {super.key});

  @override
  State<FachBearbeiten> createState() => _FachBearbeitenState();
}

class _FachBearbeitenState extends State<FachBearbeiten> {
  int _selectedTag = 0;
  int _selectedStunde = 0;
  late String _selectedName = widget.fach.name;
  late final SplayTreeMap<int, SplayTreeSet<int>> _zeiten =
      widget.fach.zeiten; // SplayTreeMap: Automatische Sortierung

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: CupertinoNavigationBarBackButton(
          onPressed: () => Navigator.of(context).pop(),
        ),
        middle: Text('$_zeiten bearbeiten'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.check_mark),
          onPressed: () => Navigator.of(context).pop((_selectedName, _zeiten)),
        ),
      ),
      child: SafeArea(
        // Erstellt eine "Knauschzone" um die Ränder des Bildschirms
        minimum: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.1,
            vertical: MediaQuery.of(context).size.height * 0.07),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CupertinoTextFormFieldRow(
              autofocus: true,
              placeholder: 'Fächername',
              initialValue: _selectedName,
              onChanged: (value) => _selectedName = value,
            ),
            CupertinoButton(
                padding: const EdgeInsets.only(top: 20, bottom: 10),
                child: const Text('Zeit hinzufügen'),
                onPressed: () {
                  Future<(int, int, bool)> result =
                      zeitenAuswahl(context, _selectedTag, _selectedStunde);
                  result.then((output) {
                    if (output.$3) {
                      setState(() {
                        _zeiten[output.$1] =
                            addZeit(_zeiten, output.$1, output.$2);
                        _selectedTag = output.$1;
                        _selectedStunde = output.$2;
                      });
                    }
                  });
                }),
            ListView.builder(
              itemExtent: 50,
              shrinkWrap: true,
              itemCount: _zeiten.length,
              itemBuilder: (_, index) {
                return Row(
                  children: [
                    Text(wochentage[_zeiten.keys.toList()[index]]),
                    const Spacer(),
                    Text(getSubtitles(_zeiten)[index]),
                    CupertinoButton(
                        padding: const EdgeInsets.only(left: 20),
                        child: const Icon(CupertinoIcons.minus),
                        onPressed: () => setState(
                            () => _zeiten.remove(_zeiten.keys.toList()[index])))
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
