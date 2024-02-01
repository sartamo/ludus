// Seite für den Stundenplan

import 'package:flutter/cupertino.dart';
import 'globals.dart';

class Stundenplan extends StatefulWidget {
  const Stundenplan({super.key});

  @override
  State<Stundenplan> createState() => _StundenplanState();
}

class _StundenplanState extends State<Stundenplan> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Willkommen im Stundenplan <3'),
    );
  }
}