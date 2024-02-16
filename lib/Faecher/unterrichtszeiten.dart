// Die Seite für die Unterrichtszeiten der Fächer

import 'package:flutter/cupertino.dart';
import 'package:suppaapp/globals.dart';
import 'package:suppaapp/Faecher/hauptseite.dart';
import 'dart:collection';

class Unterrichtszeiten extends StatelessWidget {
  final Fach fach;
  const Unterrichtszeiten(this.fach, {super.key});

  String _getSubtitle(int index) {
    SplayTreeSet<int> value = fach.zeiten.values.toList()[index];
    String subtitle = '';
    int counter = 0;
    for (int i in value) {
      if (counter != 0) {
        subtitle += ', ';
      }
      counter++;
      subtitle += stunden[i];
    }
    return subtitle;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        child: Column(
      children: <Widget>[
        CupertinoNavigationBar(
          leading: CupertinoNavigationBarBackButton(
            onPressed: () => Navigator.of(context).pop(),
          ),
          middle: Text("Unterrichtszeiten (${fach.name})"),
        ),
        CupertinoListSection(
          children: List<Widget>.generate(
              fach.zeiten.length,
              (index) => CupertinoListTile(
                    title: Text(wochentage[fach.zeiten.keys.toList()[index]]),
                    subtitle: Text(_getSubtitle(index)),
                  )),
        )
      ],
    )
        /*
      child: SafeArea(
        minimum: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.1,
          vertical: MediaQuery.of(context).size.height * 0.07,
        ),
        child: ListView.builder(
          itemExtent: 50,
          shrinkWrap: true,
          itemCount: fach.zeiten.length,
          itemBuilder: (context, index) {
            return Row(
              children: [
                Text(wochentage[fach.zeiten.keys.toList()[index]]),
                const Spacer(),
                Text(_getSubtitles()[index])
              ],
            );
          },
        ),
      ),*/
        );
  }
}
