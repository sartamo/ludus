// Seite, um ein Fach hinzuzufügen

import 'package:flutter/cupertino.dart';
//import 'package:suppaapp/FaecherEinstellungen/auswahlfunktionen.dart';
//import 'package:suppaapp/globals.dart';
import 'package:suppaapp/Stundenplan/aenderung.dart';
import 'dart:collection';

class FachHinzufuegen extends StatefulWidget {
  const FachHinzufuegen({super.key});

  @override
  State<FachHinzufuegen> createState() => _FachHinzufuegenState();
}

class _FachHinzufuegenState extends State<FachHinzufuegen> {
  String _selectedName = '';
  final SplayTreeMap<int, SplayTreeSet<int>> _zeiten =
      SplayTreeMap(); // SplayTreeMap: Automatische Sortierung

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: CupertinoNavigationBarBackButton(
          onPressed: () => Navigator.of(context).pop(),
        ),
        middle: _selectedName == ''
            ? const Text('Fach hinzufügen')
            : Text('$_selectedName hinzufügen'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.check_mark),
          onPressed: () => Navigator.of(context).pop((_selectedName, _zeiten)),
        ),
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
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CupertinoTextField(
                autofocus: true,
                placeholder: 'Fächername',
                onChanged: (value) => setState(() => _selectedName = value),
              ),
              StundenplanBearbeiten(
                zeiten: _zeiten,
                name: _selectedName,
                currentFachIndex: -1,
              ),

            ],
          ),
        ),
      ),
    );
  }
}
