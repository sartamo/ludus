// Die Seite für das Hausaufgabenheft

import 'package:flutter/cupertino.dart';
import 'dart:collection';
import 'package:suppaapp/Faecher/management.dart';
import 'package:suppaapp/Faecher/faecher.dart';
import 'package:suppaapp/Hausaufgaben/hinzufuegen.dart';
import 'package:suppaapp/Hausaufgaben/bearbeiten.dart';
import 'package:suppaapp/globals.dart';

class Hausaufgabenheft extends StatefulWidget {
  const Hausaufgabenheft({super.key});

  @override
  State<Hausaufgabenheft> createState() => _HausaufgabenheftState();
}

class _HausaufgabenheftState extends State<Hausaufgabenheft> {
  // Gibt true zurück, wenn die Hausis aller Fächer leer sind
  bool _isHausaufgabenheftEmpty() {
    bool result = true;
    for (Fach fach in faecher.faecher) {
      if (fach.hausaufgaben.isNotEmpty) {
        result = false;
      }
    }
    return result;
  }

  SplayTreeMap<DateTime, List<(Fach, int,  String)>> _getHausaufgabenMap() { // Gibt die Hausaufgaben umgeschrieben als Map zurück (Datum wird einer Liste der entsprechenden Hausis zugeordnet)
    SplayTreeMap<DateTime, List<(Fach, int, String)>> map = SplayTreeMap(); // Format: datum : (fach, position, content)
    for (Fach fach in faecher.faecher) {
      for (int i = 0; i < fach.hausaufgaben.length; i++) {
        (String, DateTime) element = fach.hausaufgaben[i];
        List<(Fach, int, String)>? entry = map[element.$2];
        if (entry == null) {
          map[element.$2] = [(fach, i, element.$1)];
        }
        else {
          map[element.$2] = entry..add((fach, i, element.$1));
        }
      }
    }
    return map;
  }

  late SplayTreeMap<DateTime, List<(Fach, int, String)>> _hausaufgabenMap;

  @override
  void initState() {
    _hausaufgabenMap = _getHausaufgabenMap();
    super.initState();
    faecher.addListener(() {
      if (mounted) {
        setState(() {_hausaufgabenMap = _getHausaufgabenMap();});
      }
    });
   }

   @override
   void dispose() {
    super.dispose();
    faecher.removeListener(() {});
   }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Hausaufgabenheft'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.add),
          onPressed: () {
            showCupertinoModalPopup(
              context: context,
              builder: ((context) => CupertinoActionSheet(
                title: const Text('Fach auswählen'),
                message: const Text('Wähle das Fach aus, für das du eine Hausaufgabe hinzufügen möchstest'),
                actions: List<Widget>.generate(
                  faecher.faecher.length,
                  (index) => CupertinoActionSheetAction(
                    child: Text(faecher.faecher[index].name),
                    onPressed: () async {
                      Navigator.of(context).pop();
                      (String, DateTime)? result = await Navigator.of(context).push(
                        CupertinoPageRoute(builder: (context) => const HausaufgabeHinzufuegen())
                      );
                      if (result != null) {
                        faecher.updateFach(
                          index: index,
                          hausaufgaben: faecher.faecher[index].hausaufgaben + [result]
                        );
                      }
                    },
                  )
                )
              ))
            );
          },
        )
      ),
      child: SafeArea(
        minimum: EdgeInsets.only(
          top: const CupertinoNavigationBar().preferredSize.height,
        ),
        child: SingleChildScrollView(
          child: _isHausaufgabenheftEmpty()
          ? const Column(
            children: <Widget> [
              SizedBox(height: 20),
              Center(child: Text('Du hast noch keine Hausaufgaben erstellt')),
            ]
          )
          : Column(
            children: List<Widget>.generate(
              _hausaufgabenMap.length,
              (i) => CupertinoListSection(
                header: Text("${wochentage[_hausaufgabenMap.keys.elementAt(i).weekday - 1]}, ${_hausaufgabenMap.keys.elementAt(i).day}.${_hausaufgabenMap.keys.elementAt(i).month}.${_hausaufgabenMap.keys.elementAt(i).year}"),
                children: List<Widget>.generate(
                  _hausaufgabenMap.values.elementAt(i).length,
                  (j) => CupertinoListTile(
                    title: Text(_hausaufgabenMap.values.elementAt(i)[j].$3), // Content
                    subtitle: Text(_hausaufgabenMap.values.elementAt(i)[j].$1.name), // Fachname
                    onTap: () async {
                      (String, DateTime)? result = await Navigator.of(context).push(CupertinoPageRoute(
                        builder: (context) => HausaufgabeBearbeiten((_hausaufgabenMap.values.elementAt(i)[j].$3, _hausaufgabenMap.keys.elementAt(i))),
                      ));
                      if (result != null) {
                        _hausaufgabenMap.values.elementAt(i)[j].$1.hausaufgaben[_hausaufgabenMap.values.elementAt(i)[j].$2] = result;
                        faecher.updateFach(
                          index: faecher.faecher.indexOf(_hausaufgabenMap.values.elementAt(i)[j].$1)
                        );
                      }
                    },
                    trailing: CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: const Icon(CupertinoIcons.minus),
                      onPressed: () => faecher.updateFach(
                        index: faecher.faecher.indexOf(_hausaufgabenMap.values.elementAt(i)[j].$1),
                        hausaufgaben: _hausaufgabenMap.values.elementAt(i)[j].$1.hausaufgaben..removeAt(_hausaufgabenMap.values.elementAt(i)[j].$2)
                      ),
                    )
                  ))
              )
            ),
          )
        )
      )
    );
  }
}