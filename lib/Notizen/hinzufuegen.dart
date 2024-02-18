// Die Seite, um eine Notiz hinzuzufügen

import 'package:flutter/cupertino.dart';

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
        minimum: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.1,
          vertical: MediaQuery.of(context).size.height * 0.07
        ),
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
    );
  }
}