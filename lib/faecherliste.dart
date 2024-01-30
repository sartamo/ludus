import 'package:flutter/cupertino.dart';

class Faecherliste extends StatefulWidget {
  const Faecherliste({super.key});

  @override
  State<Faecherliste> createState() => _FaecherlisteState();
}

class _FaecherlisteState extends State<Faecherliste> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Willkommen in der Fächerliste <3'),
    );
  }
}