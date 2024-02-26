// Seite, um ein Fach hinzuzufügen

import 'package:flutter/cupertino.dart';
//import 'package:suppaapp/FaecherEinstellungen/auswahlfunktionen.dart';
import 'package:suppaapp/Faecher/faecher.dart';
//import 'package:suppaapp/globals.dart';
import 'package:suppaapp/Stundenplan/stundenplan_Aenderung.dart';
import 'dart:collection';

class FachBearbeiten extends StatefulWidget {
  // Aufruf: FachBearbeiten(fach), Verarbeitung vom Ergebnis siehe faecherliste.dart
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
      SplayTreeMap<int, SplayTreeSet<int>>.from(widget.fach.zeiten); // SplayTreeMap: Automatische Sortierung
  late final TextEditingController _textController;

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
              Navigator.of(context).pop((_selectedName, _zeiten));
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
              StundenplanBearbeiten(
                zeiten: _zeiten,
                name: _selectedName,
              ),

              /*CupertinoButton(
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
              ),*/
            ],
          ),
        ),
      ),
    );
  }
}
