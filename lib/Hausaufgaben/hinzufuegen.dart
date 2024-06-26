// Seite, um eine Hausaufgabe hinzuzufügen

import 'package:flutter/cupertino.dart';
import 'package:suppaapp/globals.dart';

class HausaufgabeHinzufuegen extends StatefulWidget {
  const HausaufgabeHinzufuegen({super.key});

  @override
  State<HausaufgabeHinzufuegen> createState() => _HausaufgabeHinzufuegenState();
}

class _HausaufgabeHinzufuegenState extends State<HausaufgabeHinzufuegen> {
  DateTime _datum = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  String _selectedName = '';  
  
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
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: CupertinoNavigationBarBackButton(
          onPressed: () => Navigator.of(context).pop(),
        ),
        middle: _selectedName == ''
          ? const Text('Hausaufgabe hinzufügen')
          : Text('$_selectedName hinzufügen'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.check_mark),
          onPressed: () =>
              Navigator.of(context).pop((_selectedName, _datum)),
        ),
      ),
      child: SafeArea(
        // Erstellt eine "Knauschzone" um die Ränder des Bildschirms
        minimum: EdgeInsets.only(
          right: MediaQuery.of(context).size.width * widthMultiplier,
          left: MediaQuery.of(context).size.width *
              widthMultiplier, // Geändert zu Variable in globals.dart
          top: const CupertinoNavigationBar().preferredSize.height
              + View.of(context).physicalSize.height * heightMultiplier),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CupertinoTextField(
              autofocus: true,
              placeholder: 'Hausaufgabe',
              onChanged: (value) => setState(() => _selectedName = value),
            ),
            Row(
              mainAxisAlignment:MainAxisAlignment.spaceBetween,
              children:[
                CupertinoButton(
                  padding: const EdgeInsets.only(top: 20, bottom: 10),
                  onPressed: _showDatePicker,
                  child: const Text('Abgabezeit verändern')                
                ),
              ]
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(getSubtitlesDatum(_datum)),
                CupertinoButton(
                  padding: const EdgeInsets.only(left: 20),
                  child: const Text('Heute'),
                  onPressed: () {
                    setState(() {
                      _datum = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
                    });
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
