// Die Seite, um eine Notiz zu bearbeiten

import 'package:flutter/cupertino.dart';
import 'package:suppaapp/globals.dart';

class NotizBearbeiten extends StatefulWidget {
  final (String, String) notiz;
  const NotizBearbeiten(this.notiz, {super.key});

  @override
  State<NotizBearbeiten> createState() => _NotizBearbeitenState();
}

class _NotizBearbeitenState extends State<NotizBearbeiten> {
  late String _selectedTitel;
  late String _selectedContent;
  late final TextEditingController _titelController;
  late final TextEditingController _contentController;

  @override
  void initState() {
    _selectedTitel = widget.notiz.$1;
    _selectedContent = widget.notiz.$2;
    _titelController = TextEditingController(text: _selectedTitel);
    _contentController = TextEditingController(text: _selectedContent);
    super.initState();
  }

  @override
  void dispose() {
    _titelController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: CupertinoNavigationBarBackButton(
          onPressed: () => Navigator.of(context).pop(),
        ),
        middle: _selectedTitel == ''
        ? const Text('Notiz bearbeiten')
        : Text('Notiz bearbeiten: $_selectedTitel'),
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
              + MediaQuery.of(context).size.height * heightMultiplier,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              CupertinoTextField(
                autofocus: true,
                placeholder: 'Titel',
                controller: _titelController,
                onChanged: (value) => setState(() => _selectedTitel = value),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.015,
              ),
              CupertinoTextField(
                placeholder: 'Notiz',
                expands: true,
                maxLines: null,
                controller: _contentController,
                onChanged: (value) => _selectedContent = value,
              ),
            ],
          ),
        ),
      ),
    );
  }
}