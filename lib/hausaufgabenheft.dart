import 'package:flutter/material.dart';

class HausaufgabenheftPage extends StatefulWidget {
  @override
  State<HausaufgabenheftPage> createState() => _HausaufgabenheftPageState();
}

class _HausaufgabenheftPageState extends State<HausaufgabenheftPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Page'),
      ),
      body: const Center(
        child: Text(
          'This is the second page!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}