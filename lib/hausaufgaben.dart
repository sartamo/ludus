// Das Management der einzelnen Fächer

import 'package:flutter/cupertino.dart';

class Hausaufgabe extends StatefulWidget {
  final String name;
  final DateTime datum;

  const Hausaufgabe(this.name,this.datum, {super.key});

  @override
  State<Hausaufgabe> createState() => _HausaufgabeState();
}

class _HausaufgabeState extends State<Hausaufgabe> {
  late List<Text> _display;
  late String _name;

  List<Text> _getDisplay() {
    // Gibt den anzuzeigenden Text an _HausaufgabeState
    List<Text> display = [  
      Text('Hausaufgabe ${widget.name}'),
      const Text('Abgabe:'),
    ];
    return display;
  }

  @override
  void initState() {
    _display = _getDisplay();
    _name = widget.name;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: CupertinoNavigationBarBackButton(
          onPressed: () => Navigator.pop(context),
        ),
        middle: Text(_name),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _display,
        ),
      ),
    );
  }
}