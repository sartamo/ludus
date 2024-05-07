// Seite, um ein Fach hinzuzufügen

import 'package:flutter/cupertino.dart';
//import 'package:suppaapp/FaecherEinstellungen/auswahlfunktionen.dart';
import 'package:suppaapp/Faecher/faecher.dart';
import 'package:suppaapp/Faecher/management.dart';
import 'package:suppaapp/FaecherEinstellungen/farb_slider.dart';
//import 'package:suppaapp/globals.dart';
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
      SplayTreeMap<int, SplayTreeSet<int>>.from(widget.fach.zeiten); // SplayTreeMap: Automatische Sortierung
  late final TextEditingController _textController;
  late final MutableFarbe _selectedFarbe = MutableFarbe(farbe: widget.fach.farbe);
  final ValueNotifier<bool> _colorNotifier = ValueNotifier<bool>(false);
  

  @override
  initState() {
    _textController = TextEditingController(text: _selectedName);
    // Damit das Eingabefeld einen initial Value hat (den ursprünglichen Namen)
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
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
              Navigator.of(context).pop((_selectedName, _zeiten, _selectedFarbe.farbe));
            }),
      ),
      child: SingleChildScrollView(
        child: SafeArea(
          // Erstellt eine "Knauschzone" um die Ränder des Bildschirms
          minimum: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width *
                  0.1, //Bei Änderung von horizontal auch in stundenplan_Aenderung.dart bei der Definition von breite ändern (die 0.1 aus:(1-0.1*2)) (Momentan Zeile 31, kann sich aber ändern)
              vertical: MediaQuery.of(context).size.height * 0.07),
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
              
              FarbSlider(farbe: _selectedFarbe, colorNotifier: _colorNotifier,),

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
