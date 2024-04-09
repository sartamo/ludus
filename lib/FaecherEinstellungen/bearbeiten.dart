// Seite, um ein Fach hinzuzufügen

import 'package:flutter/cupertino.dart';
//import 'package:suppaapp/FaecherEinstellungen/auswahlfunktionen.dart';
import 'package:suppaapp/Faecher/faecher.dart';
import 'package:suppaapp/Faecher/management.dart';
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
  final double _colorTextFieldWidth = (TextPainter(
              text: const TextSpan(text: '999'),
              textDirection: TextDirection.ltr)
            ..layout())
          .width+16;
  int _colorRed = 0;
  int _colorGreen = 0;
  int _colorBlue = 0;
  final TextEditingController _redController = TextEditingController();
  final TextEditingController _greenController = TextEditingController();
  final TextEditingController _blueController = TextEditingController();

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

  int _searchFach ()
  {
    for (int i = 0; i < faecher.faecher.length; i++)
    {
      if (faecher.faecher[i] == widget.fach)
      {
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

              
              Column(
                children: [
                  Row(
                    children: [
                      const SizedBox(
                        width: 50,
                        child: Text('Rot:'),
                      ),
                      SizedBox(
                        width: _colorTextFieldWidth,
                        child: CupertinoTextField(
                          controller: _redController,
                          autocorrect: false,
                          keyboardType: TextInputType.number,
                          maxLength: 3,
                          textAlign: TextAlign.center,
                          onChanged: (value) {
                            try {
                              setState(() {
                                if (int.parse(value) <= 255) {
                                  if (int.parse(value) >= 0) {
                                    _colorRed = int.parse(value);
                                  }
                                  else
                                  {
                                    _redController.text = '0';
                                    _colorRed = 0;
                                  }
                                }
                                else {
                                  _redController.text = '255';
                                  _colorRed = 255;
                                }
                              });
                            }
                            catch (e) {
                              _redController.text = _colorRed.toString();
                            }
                          },
                        ),
                      ),
                      Expanded(
                        child: CupertinoSlider(
                          activeColor: CupertinoColors.systemRed,
                          value: _colorRed.toDouble(),
                          onChanged: (r) {
                            setState(() {
                              _colorRed = r.toInt();
                              _redController.text = r.toInt().toString();
                            });
                          },
                          min: 0,
                          max: 255,
                          thumbColor: Color.fromARGB(
                              255, _colorRed, _colorGreen, _colorBlue),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 50,
                        child: Text('Grün:'),
                      ),
                      SizedBox(
                        width: _colorTextFieldWidth,
                        child: CupertinoTextField(
                          controller: _greenController,
                          autocorrect: false,
                          keyboardType: TextInputType.number,
                          maxLength: 3,
                          textAlign: TextAlign.center,
                          onChanged: (value) {
                            try {
                              setState(() {
                                if (int.parse(value) <= 255) {
                                  if (int.parse(value) >= 0) {
                                    _colorGreen = int.parse(value);
                                  }
                                  else
                                  {
                                    _greenController.text = '0';
                                    _colorGreen = 0;
                                  }
                                }
                                else {
                                  _greenController.text = '255';
                                  _colorGreen = 255;
                                }
                              });
                            }
                            catch (e) {
                              _greenController.text = _colorGreen.toString();
                            }
                          },
                        ),
                      ),
                      Expanded(
                        child: CupertinoSlider(
                          activeColor: CupertinoColors.systemGreen,
                          value: _colorGreen.toDouble(),
                          onChanged: (r) {
                            setState(() {
                              _colorGreen = r.toInt();
                              _greenController.text = r.toInt().toString();
                            });
                          },
                          min: 0,
                          max: 255,
                          thumbColor: Color.fromARGB(
                              255, _colorRed, _colorGreen, _colorBlue),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 50,
                        child: Text('Blau:'),
                      ),
                      SizedBox(
                        width: _colorTextFieldWidth,
                        child: CupertinoTextField(
                          controller: _blueController,
                          autocorrect: false,
                          keyboardType: TextInputType.number,
                          maxLength: 3,
                          textAlign: TextAlign.center,
                          onChanged: (value) {
                            try {
                              setState(() {
                                if (int.parse(value) <= 255) {
                                  if (int.parse(value) >= 0) {
                                    _colorBlue = int.parse(value);
                                  }
                                  else
                                  {
                                    _blueController.text = '0';
                                    _colorBlue = 0;
                                  }
                                }
                                else {
                                  _blueController.text = '255';
                                  _colorBlue = 255;
                                }
                              });
                            }
                            catch (e) {
                              _blueController.text = _colorBlue.toString();
                            }
                          },
                        ),
                      ),
                      Expanded(
                        child: CupertinoSlider(
                          activeColor: CupertinoColors.systemBlue,
                          value: _colorBlue.toDouble(),
                          onChanged: (r) {
                            setState(() {
                              _colorBlue = r.toInt();
                              _blueController.text = r.toInt().toString();
                            });
                          },
                          min: 0,
                          max: 255,
                          thumbColor: Color.fromARGB(
                              255, _colorRed, _colorGreen, _colorBlue),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              StundenplanBearbeiten(
                zeiten: _zeiten,
                name: _selectedName,
                currentFachIndex: _searchFach(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
