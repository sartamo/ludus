// Die Fächerverwaltung / -bearbeitung

import 'package:flutter/cupertino.dart';
import 'package:suppaapp/faecher.dart';
import 'package:suppaapp/globals.dart';

class Faecherverwaltung extends StatefulWidget {
  const Faecherverwaltung({super.key});

  List<CupertinoListTile> getFaecher() {
    List<CupertinoListTile> faecherList = [];
    late int i;
    late int j;
    late String mySubtitle;


    for (Fach myFach in faecher) {
      mySubtitle = '';
      i = 0; // Damit die Kommata richtig zwischen den Wochentagen gesetzt werden
      for (int w in [0, 1, 2, 3, 4]) { // Geht die Wochentage durch
        List<int>? myZeiten = myFach.zeiten[w];
        if (myZeiten != null) {
          if (i != 0){mySubtitle += ', ';}
          j = 0; // Damit die Kommata richtig zwischen den Stunden gesetzt werden
          i += 1;
          mySubtitle += '${wochentage[w]} (';
          for (int s in myZeiten) {
            if (j != 0) {
              mySubtitle += ', ';
            }
            j += 1;
            mySubtitle += '${stunden[s]}';
          }
          mySubtitle += ')';
        }
      }
      faecherList.add(
        CupertinoListTile(
          title: Text(myFach.name),
          subtitle: Text(mySubtitle),
          trailing: Row(
            children: [
              CupertinoButton(
                padding: EdgeInsets.zero,
                child: const Icon(CupertinoIcons.settings),
                onPressed: () {},
              ),
              CupertinoButton(
                padding: EdgeInsets.zero,
                child: const Icon(CupertinoIcons.minus),
                onPressed: () {},
              ),
            ],
          ),
          onTap: () {},
        ),
      );
    }

    return faecherList;
  }

  @override
  State<Faecherverwaltung> createState() => _FaecherverwaltungState();
}

class _FaecherverwaltungState extends State<Faecherverwaltung> {
  @override
  Widget build(BuildContext context) {
    return CupertinoListSection(
      header: const Text('Fächer'),
      children: widget.getFaecher(),
    );
  }
}