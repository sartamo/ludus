// Seite, um eine Hausaufgabe zu bearbeiten

import 'package:flutter/cupertino.dart';
import 'package:suppaapp/globals.dart';

class HausaufgabeBearbeiten extends StatefulWidget {
  final (String, DateTime) hausaufgabe;
  const HausaufgabeBearbeiten(this.hausaufgabe, {super.key});

  @override
  State<HausaufgabeBearbeiten> createState() => _HausaufgabeBearbeitenState();
}

class _HausaufgabeBearbeitenState extends State<HausaufgabeBearbeiten> {
  late DateTime _datum;
  late DateTime _initialDatum;
  late String _selectedContent;
  late final TextEditingController _contentController; // Für initial Text benötigt

  String getSubtitlesDatum(DateTime datum) {
    String subtitles = '${datum.day}.${datum.month}.${datum.year}';
    return subtitles;
  }

  void _showDatePicker () { 
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return Container(
          color: CupertinoColors.systemBackground.resolveFrom(context),
          height: 400,
          width: 700,
          padding: const EdgeInsets.only(top: 6.0),
          margin: EdgeInsets.only(
             bottom: MediaQuery.of(context).viewInsets.bottom,
        	),
          child: CupertinoDatePicker(
            showDayOfWeek: true,
            dateOrder: DatePickerDateOrder.dmy,
            mode: CupertinoDatePickerMode.date,
            initialDateTime: _datum,
            minimumDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
            itemExtent: 50,
            onDateTimeChanged: (DateTime newDateTime) {
              setState(() {_datum = newDateTime;});
            }
          ),
        );
      },
    );
  }

  @override
  void initState() {
    _datum = widget.hausaufgabe.$2;
    _initialDatum = _datum;
    _selectedContent = widget.hausaufgabe.$1;
    _contentController = TextEditingController(text: _selectedContent);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: CupertinoNavigationBarBackButton(
          onPressed: () => Navigator.of(context).pop(),
        ),
        middle: _selectedContent == ''
          ? const Text('Hausaufgabe bearbeiten')
          : Text('$_selectedContent bearbeiten'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.check_mark),
          onPressed: () => Navigator.of(context).pop((_selectedContent, _datum)),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CupertinoTextField(
              autofocus: true,
              placeholder: 'Hausaufgabe',
              controller: _contentController,
              onChanged: (value) => setState(() => _selectedContent = value),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CupertinoButton(
                  padding: const EdgeInsets.only(top: 20, bottom: 10),
                  onPressed: _showDatePicker,
                  child: const Text('Abgabezeit verändern'),
                ),
                CupertinoButton(
                  padding: const EdgeInsets.only(left:20),
                  child: const Text('Heute'),
                  onPressed: () => setState(() {_datum = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);}),
                )
              ]
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(getSubtitlesDatum(_datum)),
                CupertinoButton(
                  padding: const EdgeInsets.only(left: 20),
                  child: const Text('Reset'),
                  onPressed: () => setState(() {_datum = _initialDatum;})
                ),
              ],
            )
          ]
        ),
      ),
    );
  }
}