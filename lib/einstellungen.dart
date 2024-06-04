// Die Seite für die Einstellungen

import 'package:flutter/cupertino.dart';

class Einstellungen extends StatelessWidget {
  const Einstellungen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Column(
        children: [
          const CupertinoNavigationBar(
            middle: Text('Einstellungen'),
          ),
          CupertinoListSection(
            children: const [
              CupertinoListTile(
                title: Text('Leider gibt es momentan noch keine Einstellungen'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
