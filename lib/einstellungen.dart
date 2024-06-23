// Die Seite für die Einstellungen

import 'package:flutter/cupertino.dart';
import 'package:suppaapp/globals.dart';

class Einstellungen extends StatefulWidget {
  const Einstellungen({super.key});

  @override
  State<Einstellungen> createState() => EinstellungenState();
}

class EinstellungenState extends State<Einstellungen> {
  final TextEditingController _stundenplanHoeheController = TextEditingController();
  bool _darkmode = (themeNotifier.value.brightness == Brightness.dark);
  final TextEditingController _anzahlStundenController = TextEditingController();
  //final GlobalKey _stundenplanHoeheKey = GlobalKey();

  @override
  void initState() {
    _stundenplanHoeheController.text = stundenplanHoeheNotifier.value.toString();
    _anzahlStundenController.text = anzahlStundenNotifier.value.toString();
    stundenplanHoeheNotifier.addListener(() {
      setState(() {
        _stundenplanHoeheController.text = stundenplanHoeheNotifier.value.toString();
      });
    });
    themeNotifier.addListener(() {
      setState(() {
        _darkmode = ((themeNotifier.value.brightness == Brightness.dark));
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Einstellungen'),
      ),
      child: SafeArea(
        minimum: EdgeInsets.only(
          top: const CupertinoNavigationBar().preferredSize.height,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CupertinoListSection(
                children: [
                  CupertinoListTile(
                    title: const Text('Darkmode'),
                    subtitle: const Text('Dunke Anzeige'),
                    trailing: CupertinoSwitch(
                      value: _darkmode,
                      onChanged: (bool? value) {
                        themeNotifier.value = value ?? false
                        ? const CupertinoThemeData(brightness: Brightness.dark)
                        : const CupertinoThemeData(brightness: Brightness.light);
                      },
                    ),
                  ),
                  CupertinoListTile(
                    title: const Text('Stundenplan Höhe'),
                    subtitle: const Text('Höhe der Tiles im Verhältnis zur Breite', maxLines: 3,),
                    //additionalInfo: SizedBox(height: ((_stundenplanHoeheKey.currentContext?.findRenderObject() as RenderBox?)?.size?.height ?? 30)*_stundenplanHoeheKey,),
                    //key: _stundenplanHoeheKey,
                    trailing: SizedBox(
                  width: 56,
                  child: CupertinoTextField(
                    controller: _stundenplanHoeheController,
                    autocorrect: false,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    onSubmitted: (value) {
                      if (value != '') {
                        try {
                          value = value.replaceAll(',', '.');
                          setState(() {
                            if (double.parse(value) <= 5) {
                              if (double.parse(value) >= 0.2) {
                                stundenplanHoeheNotifier.value = double.parse(value);
                              } else {
                                _stundenplanHoeheController.text = '0.2';
                                stundenplanHoeheNotifier.value = 0.2;
                              }
                            } else {
                              _stundenplanHoeheController.text = '5';
                              stundenplanHoeheNotifier.value = 5;
                            }
                          });
                        } catch (e) {
                          _stundenplanHoeheController.text = stundenplanHoeheNotifier.value.toString();
                        }
                      }
                    },
                  ),
                ),
                  ),
                  CupertinoListTile(
                    title: const Text('Wochenende im Stundenplan'),
                    subtitle: const Text('Zeigt im Stundenplan auch Samstag und Sonntag an'),
                    trailing: CupertinoSwitch(
                      value: wochenendeNotifier.value,
                      onChanged: (bool value) {
                        setState(() {
                          wochenendeNotifier.value = value;
                        });
                      },
                    ),
                  ),
                  CupertinoListTile(
                    title: const Text('Stunden pro Tag'),
                    subtitle: const Text('Die Anzahl der Stunden pro Tag, die im Stundenplan angezeigt werden'),
                    trailing: SizedBox(
                  width: 56,
                  child: CupertinoTextField(
                    controller: _anzahlStundenController,
                    autocorrect: false,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    maxLength: 2,
                    onChanged: (value) {
                      if (value != '') {
                        try {
                          value = value.replaceAll(',', '.');
                          setState(() {
                              if (int.parse(value) >= 1 && int.parse(value) <= 99) {
                                anzahlStundenNotifier.value = int.parse(value);
                              } else {
                                _anzahlStundenController.text = '1';
                                anzahlStundenNotifier.value = 1;
                              }
                          });
                        } catch (e) {
                          _anzahlStundenController.text = anzahlStundenNotifier.value.toString();
                        }
                      }
                    },
                    onSubmitted: (value) {
                      if(value == '') {
                        _anzahlStundenController.text = anzahlStundenNotifier.value.toString();
                      }
                    },
                  ),
                ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
