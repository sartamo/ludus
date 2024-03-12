// Seite, um eine Hausaufgabe hinzuzufügen

import 'package:flutter/cupertino.dart';
import 'package:suppaapp/hausaufgaben.dart';

class HausaufgabeHinzufuegen extends StatefulWidget {
  const HausaufgabeHinzufuegen({super.key});

  @override
  State<HausaufgabeHinzufuegen> createState() => _HausaufgabeHinzufuegenState();
}

class _HausaufgabeHinzufuegenState extends State<HausaufgabeHinzufuegen> {
  DateTime _datum = DateTime.now();
  String _selectedName = '';
  bool auswahl = false;
  
  
String getSubtitlesDatum(DateTime datum) {
  String subtitles = '${datum.day + 1}.${datum.month}.${datum.year}';
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
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CupertinoButton(
                child: const Text('Abbrechen'), 
                onPressed: () => Navigator.pop(context),
              ),
              Expanded(
                child: CupertinoDatePicker(
                  showDayOfWeek: true,
                  dateOrder: DatePickerDateOrder.dmy,
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: _datum,
                  onDateTimeChanged: (DateTime newDateTime) {
                   _datum = newDateTime;
                   }
                  )
                ),
              CupertinoButton(
              child: const Text('Hinzufügen'),
              onPressed: () {
                setState(() {
                  _datum;
                });
                Navigator.pop(context); 
              },
            ),
            ],
          )
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
        middle: Text('$_selectedName hinzufügen'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.check_mark),
          onPressed: () =>
              Navigator.of(context).pop(Hausaufgabe(_selectedName, _datum)),
        ),
      ),
      child: SafeArea(
        // Erstellt eine "Knauschzone" um die Ränder des Bildschirms
        minimum: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.1,
            vertical: MediaQuery.of(context).size.height * 0.07),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          // mainAxisAlignment: MainAxisAlignment.center,
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
                    child: const Text('Abgabezeit hinzufügen')                
                    ),
              ]
            ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(getSubtitlesDatum(_datum)),
                    CupertinoButton(
                        padding: const EdgeInsets.only(left: 20),
                        child: const Text('reset'),
                        onPressed: () {
                          setState(() {
                            _datum = DateTime.now();
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
