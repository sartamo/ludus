// Die Seite für die Unterrichtszeiten der Fächer

import 'package:flutter/cupertino.dart';
import 'package:suppaapp/globals.dart';
import 'package:suppaapp/Faecher/faecher.dart';
import 'package:suppaapp/Faecher/management.dart';
import 'dart:collection';

class Unterrichtszeiten extends StatefulWidget {
  final Fach fach;
  const Unterrichtszeiten(this.fach, {super.key});

  @override
  State<Unterrichtszeiten> createState() => _UnterrichtszeitenState();
}

class _UnterrichtszeitenState extends State<Unterrichtszeiten> {
  String _getSubtitle(int index) {
    SplayTreeSet<int> value = widget.fach.zeiten.values.toList()[index];
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
  void initState() {
    super.initState();
    faecher.addListener(() {
      setState(() {});
    });
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
            middle: Text("Unterrichtszeiten (${widget.fach.name})"),
          ),
          CupertinoListSection(
            children: List<Widget>.generate(
                widget.fach.zeiten.length,
                (index) => CupertinoListTile(
                      title: Text(wochentage[widget.fach.zeiten.keys.toList()[index]]),
                      subtitle: Text(_getSubtitle(index)),
                    )),
          )
        ],
      ),
    );
  }
}
