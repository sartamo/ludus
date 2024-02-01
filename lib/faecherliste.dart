// Die Seite für die Fächerliste

import 'package:flutter/cupertino.dart';
import 'faecher.dart';

class Faecherliste extends StatefulWidget {
  const Faecherliste({super.key});

  @override
  State<Faecherliste> createState() => _FaecherlisteState();
}

class _FaecherlisteState extends State<Faecherliste> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CupertinoListSection(
        header: const Text('Fächer'),
        children: <CupertinoListTile>[
          CupertinoListTile(
            title: const Text('Mathematik'),
            onTap: () {
              Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: (context) => const Fach('Mathematik', {0 : [3], 2 : [0], 4 : [5]})
                ),
              );
            }
          ),
          CupertinoListTile(
            title: const Text('Deutsch'),
            onTap: () {
              Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: (context) => const Fach('Deutsch', {1 : [4, 5], 4 : [0]})
                ),
              );
            }
          ),
          CupertinoListTile(
            title: const Text('Englisch'),
            onTap: () {
              Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: (context) => const Fach('Englisch', {2 : [3], 3 : [5], 4 : [3, 4]})
                ),
              );
            }
          ),
        ],
      ),
    );
  }
}