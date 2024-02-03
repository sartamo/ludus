// Die Seite für die Fächerliste

import 'package:flutter/cupertino.dart';
import 'faecher.dart';

class Faecherliste extends StatefulWidget {
  const Faecherliste({super.key});

  List<CupertinoListTile> getFaecher(BuildContext context) {
    List<CupertinoListTile> feacherDisplay = [];
    for (Fach fach in faecher) {
      feacherDisplay.add(
        CupertinoListTile(
          title: Text(fach.name),
          onTap: () {
            Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (context) => fach
              ),
            );
          },
        ),
      );
    }
    return feacherDisplay;
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
          header: const Text('Fächer'),
          children: widget.getFaecher(context),
        ),
      ),
    );
  }
}