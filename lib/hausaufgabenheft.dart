import 'package:flutter/cupertino.dart';

class Hausaufgabenheft extends StatefulWidget {
  const Hausaufgabenheft({super.key});

  @override
  State<Hausaufgabenheft> createState() => _HausaufgabenheftState();
}

class _HausaufgabenheftState extends State<Hausaufgabenheft> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Willkommen im Hausaufgabenheft <3'),
    );
  }
}