// Seite, um ein Fach hinzuzufügen

import 'package:flutter/cupertino.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
//import 'package:suppaapp/FaecherEinstellungen/auswahlfunktionen.dart';
import 'package:suppaapp/Faecher/faecher.dart';
import 'package:suppaapp/Faecher/management.dart';
import 'package:suppaapp/FaecherEinstellungen/farb_slider.dart';
import 'package:suppaapp/globals.dart';
import 'package:suppaapp/Stundenplan/aenderung.dart';
import 'dart:collection';

class FachBearbeiten extends StatefulWidget {
  // Aufruf: FachBearbeiten(fach), Verarbeitung vom Ergebnis siehe faecherliste.dart
  final Fach fach;

  const FachBearbeiten(this.fach, {super.key});

  @override
  State<FachBearbeiten> createState() => _FachBearbeitenState();
}

class _FachBearbeitenState extends State<FachBearbeiten> {
  late String _selectedName = widget.fach.name;
  late final SplayTreeMap<int, SplayTreeSet<int>> _zeiten =
      SplayTreeMap<int, SplayTreeSet<int>>.from(
    widget.fach.zeiten.map(((key, value)
    => MapEntry(key, SplayTreeSet<int>.from(value)))),); // SplayTreeMap: Automatische Sortierung
  late final TextEditingController _textController;
  late final MutableFarbe _selectedFarbe =
      MutableFarbe(farbe: widget.fach.farbe);
  final ValueNotifier<bool> _colorNotifier = ValueNotifier<bool>(false);

  @override
  initState() {
    _textController = TextEditingController(text: _selectedName);
    // Damit das Eingabefeld einen initial Value hat (den ursprünglichen Namen)
    _colorNotifier.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    _colorNotifier.removeListener(() {
      setState(() {});
    });
    super.dispose();
  }

  int _searchFach() {
    for (int i = 0; i < faecher.faecher.length; i++) {
      if (faecher.faecher[i] == widget.fach) {
        return i;
      }
    }
    return -1;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: CupertinoNavigationBarBackButton(
          // Rückgabe null bei Abbruch
          onPressed: () => Navigator.of(context).pop(),
        ),
        middle: _selectedName == ''
            ? const Text('Fach bearbeiten')
            : Text('$_selectedName bearbeiten'),
        trailing: CupertinoButton(
            padding: EdgeInsets.zero,
            child: const Icon(CupertinoIcons.check_mark),
            onPressed: () {
              // Rückgabe von ausgewähltem Name und den Zeiten bei Bestätigung
              Navigator.of(context)
                  .pop((_selectedName, _zeiten, _selectedFarbe.farbe));
            }),
      ),
      child: SingleChildScrollView(
        child: SafeArea(
          // Erstellt eine "Knauschzone" um die Ränder des Bildschirms
          minimum: EdgeInsets.only(
              right: MediaQuery.of(context).size.width * widthMultiplier,
              left: MediaQuery.of(context).size.width *
                  widthMultiplier, // Geändert zu Variable in globals.dart
              top: const CupertinoNavigationBar().preferredSize.height
                  + MediaQuery.of(context).size.height * heightMultiplier,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CupertinoTextField(
                autofocus: true,
                placeholder: 'Fächername',
                controller:
                    _textController, // Fächername steht am Anfang im Textfeld
                onChanged: (value) => setState(() => _selectedName = value),
              ),
              const SizedBox(height: 8),
              Material(
                color: Colors.transparent,
                elevation: 0,
                child: DefaultTextStyle(
                  style: CupertinoTheme.of(context).textTheme.textStyle,
                  child: Card(
                    color: Color.fromRGBO(
                        _selectedFarbe.farbe.red,
                        _selectedFarbe.farbe.green,
                        _selectedFarbe.farbe.blue,
                        200),
                    child: ExpandableNotifier(
                      child: ExpandablePanel(
                        header: Row(
                          children: [
                            const SizedBox(
                              width: 5,
                            ),
                            const Text('Farbe:',
                                style: TextStyle(fontSize: 32)),
                            Container(
                              width: 48,
                              height: 32,
                              margin: const EdgeInsets.only(left: 8),
                              decoration: BoxDecoration(
                                color: _selectedFarbe.farbe,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ],
                        ),
                        collapsed: const SizedBox(
                          height: 0,
                        ),
                        expanded: Row(
                          children: [
                            const SizedBox(
                              width: 3,
                            ),
                            Expanded(
                              child: FarbSlider(
                                farbe: _selectedFarbe,
                                colorNotifier: _colorNotifier,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              StundenplanBearbeiten(
                zeiten: _zeiten,
                name: _selectedName,
                currentFachIndex: _searchFach(),
                farbe: _selectedFarbe,
                colorNotifier: _colorNotifier,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
