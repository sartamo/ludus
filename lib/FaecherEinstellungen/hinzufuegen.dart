// Seite, um ein Fach hinzuzufügen

import 'package:flutter/cupertino.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
//import 'package:suppaapp/FaecherEinstellungen/auswahlfunktionen.dart';
//import 'package:suppaapp/globals.dart';
import 'package:suppaapp/FaecherEinstellungen/farb_slider.dart';
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
  final MutableFarbe _selectedFarbe = MutableFarbe(farbe: CupertinoColors.activeOrange);
  final ValueNotifier<bool> _colorNotifier = ValueNotifier<bool>(false);

  @override
  initState() {
    _colorNotifier.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _colorNotifier.removeListener(() {
      setState(() {});
    });
    super.dispose();
  }

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
          onPressed: () => Navigator.of(context).pop((_selectedName, _zeiten, _selectedFarbe.farbe)),
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
                currentFachIndex: -1,
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
