// Die Seite für die Einstellungen

import 'package:flutter/cupertino.dart';
import 'globals.dart';

class Einstellungen extends StatefulWidget {
  const Einstellungen({super.key});

  @override
  State<Einstellungen> createState() => _EinstellungenState();
}

class _EinstellungenState extends State<Einstellungen> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Willkommen in den Einstellungen <3'),
    );
  }
}