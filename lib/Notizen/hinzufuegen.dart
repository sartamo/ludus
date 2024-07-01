// Die Seite, um eine Notiz hinzuzufügen

import 'package:flutter/cupertino.dart';
import 'package:suppaapp/globals.dart';

class NotizHinzufuegen extends StatefulWidget {
  const NotizHinzufuegen({super.key});

  @override
  State<NotizHinzufuegen> createState() => _NotizHinzufuegenState();
}

class _NotizHinzufuegenState extends State<NotizHinzufuegen> {
  String _selectedTitel = '';
  String _selectedContent = '';

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: CupertinoNavigationBarBackButton(
          onPressed: () => Navigator.of(context).pop(),
        ),
        middle: _selectedTitel == ''
        ? const Text('Neue Notiz')
        : Text('Neue Notiz: $_selectedTitel'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.check_mark),
          onPressed: () => Navigator.of(context).pop((_selectedTitel, _selectedContent)),
        ),
      ),
      child: SafeArea(
        minimum: EdgeInsets.only(
          right: MediaQuery.of(context).size.width * widthMultiplier,
          left: MediaQuery.of(context).size.width *
              widthMultiplier, // Geändert zu Variable in globals.dart
          top: const CupertinoNavigationBar().preferredSize.height
              + View.of(context).physicalSize.height * heightMultiplier,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              CupertinoTextField(
                autofocus: true,
                placeholder: 'Titel',
                onChanged: (value) => setState(() => _selectedTitel = value),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.015,
              ),
              CupertinoTextField(
                placeholder: 'Notiz',
                expands: true,
                maxLines: null,
                onChanged: (value) => _selectedContent = value,
              )
            ],
          ),
        ),
      ),
    );
  }
}