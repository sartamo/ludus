// Die Seite für die Fächerliste

import 'package:flutter/cupertino.dart';
import 'faecher.dart';
import 'globals.dart';

class Faecherliste extends StatefulWidget {
  const Faecherliste({super.key});

  List<CupertinoListTile> getFaecher(BuildContext context) {
    List<CupertinoListTile> feacherList = [];
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
      feacherList.add(
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
          onTap: () {
            Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (context) => myFach
              ),
            );
          },
        ),
      );
    }
    return feacherList;
  }

  @override
  State<Faecherliste> createState() => _FaecherlisteState();
}

class _FaecherlisteState extends State<Faecherliste> {

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Center(
        child: CupertinoListSection(
          children: widget.getFaecher(context),
        ),
      ),
    );
  }
}