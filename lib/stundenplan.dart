// Seite für den Stundenplan

import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:suppaapp/globals.dart';

class Stundenplan extends StatefulWidget {
  const Stundenplan({super.key});

  @override
  State<Stundenplan> createState() => _StundenplanState();
}

class _StundenplanState extends State<Stundenplan> {
  @override
  Widget build(BuildContext context) {
    const double hoehe = 100;
    double breite = MediaQuery.of(context).size.width / (wochentage.length + 1);
    const Color firstColumnColor = CupertinoColors.systemGrey;
    const Color hourColor = CupertinoColors.activeOrange;
    const Color freeColor = CupertinoColors.systemGrey2;

    List<List<String>> stundenplanA = List.generate(
        wochentage.length, (_) => List.filled(stunden.length, ''));
    stundenplanA[0][0] = 'Mathe';
    stundenplanA[1][1] = 'Deutsch';
    stundenplanA[2][2] = 'Englisch';
    stundenplanA[3][3] = 'Geschichte';
    stundenplanA[4][4] = 'Kunst';
    stundenplanA[1][0] = 'Mathe';

    // Define your list of Column widgets
    List<Widget> tage = List.generate((wochentage.length), (index) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: hoehe,
            width: breite,
            child: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: null,
              color: firstColumnColor,
              disabledColor: firstColumnColor,
              pressedOpacity: 1.0,
              child: Text(wochentage[index]), // Display the value of 'tag'
            ),
          ),
          ...List.generate(stunden.length, (index2) {
            if (stundenplanA[index][index2] == '') {
              return SizedBox(
                height: hoehe,
                width: breite,
                child: const CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: null,
                  color: freeColor,
                  disabledColor: freeColor,
                  pressedOpacity: 1.0,
                  child: Text('Frei'), // Display the value of 'tag'
                ),
              );
            } else {
              return SizedBox(
                height: hoehe,
                width: breite,
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () { },
                  color: hourColor,
                  disabledColor: hourColor,
                  pressedOpacity: 1.0,
                  child: Text(stundenplanA[index]
                      [index2]), // Display the value of 'tag'
                ),
              );
            }
          }).toList(),
        ],
      );
    }).toList();

    return SingleChildScrollView(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            // First column (Side Bar)
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: hoehe,
                width: breite,
                child: const CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: null,
                  color: firstColumnColor,
                  disabledColor: firstColumnColor,
                  pressedOpacity: 1.0,
                  child: Text(''),
                ),
              ),
              ...stunden.map((stunde) {
                return SizedBox(
                  height: hoehe,
                  width: breite,
                  child: CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: null,
                    color: firstColumnColor,
                    disabledColor: firstColumnColor,
                    pressedOpacity: 1.0,
                    child: Text(stunde),
                  ),
                );
              }).toList(),
            ],
          ),
          ...tage
        ],
      ),
    );
  }
}
