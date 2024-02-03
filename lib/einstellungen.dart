// Die Seite für die Einstellungen

import 'package:flutter/cupertino.dart';
import 'Einstellungen/faecherverwaltung.dart';

class Einstellungen extends StatefulWidget {
  const Einstellungen({super.key});

  @override
  State<Einstellungen> createState() => _EinstellungenState();
}

class _EinstellungenState extends State<Einstellungen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CupertinoListSection( // Liste der Einstellungen
        header: const Text('Einstellungen'),
        children: [
          CupertinoListTile(
            title: const Text('Fächer verwalten'),
            onTap: () {
              Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: (context) => const Faecherverwaltung(),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}