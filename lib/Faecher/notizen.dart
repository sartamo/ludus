// Die Notizen für das jeweilige Fach

import 'package:flutter/cupertino.dart';
import 'package:suppaapp/Faecher/faecher.dart';
import 'package:suppaapp/Faecher/management.dart';
import 'package:suppaapp/Notizen/hinzufuegen.dart';
import 'package:suppaapp/Notizen/bearbeiten.dart';

class Notizen extends StatefulWidget {
  final Fach fach;
  const Notizen(this.fach, {super.key});

  @override
  State<Notizen> createState() => _NotizenState();
}

class _NotizenState extends State<Notizen> {
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
              onPressed:() => Navigator.of(context).pop(),
            ),
            middle: Text('Notizen (${widget.fach.name})'),
            trailing: CupertinoButton(
              padding: EdgeInsets.zero,
              child: const Icon(CupertinoIcons.add),
              onPressed: () async {
                // result: (titel, inhalt)
                (String, String) result = await Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (context) => const NotizHinzufuegen()
                  ),
                );
                faecher.updateFach(
                  index: faecher.faecher.indexOf(widget.fach),
                  notizen: widget.fach.notizen + [result],
                );
              }
            ),
          ),
          widget.fach.notizen.isEmpty
          ? const Center(
            child: Text('Füge Notizen hinzu, damit sie hier erscheinen'))
          : CupertinoListSection(
            children: List<Widget>.generate(
              widget.fach.notizen.length,
              (index) => CupertinoListTile(
                title: Text(widget.fach.notizen[index].$1), // Titel der Notiz
                subtitle: Text(widget.fach.notizen[index].$2), // Inhalt der Notiz
              ),
            ),
          ),
        ],
      ),
    );
  }
}