import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:suppaapp/globals.dart';
import 'package:suppaapp/Faecher/faecher.dart';
import 'package:suppaapp/Faecher/management.dart';

const stundenplanFirstColumnColor =
    CupertinoColors.systemGrey; //Farbe der ersten Spalte und Zeile

const Color stundenplanFreeColor =
    CupertinoColors.systemGrey2; //Farbe der freien Stunden

List<List<List<String>>> stundenplanA = List.generate(
    //Äußere Liste: Wochentag, mittlere Liste: Stunde, innere Liste: Nammen der Fächer
    wochentage.length,
    (_) => List.generate(stunden.length, (_) => []));

void aktualisiereStundenplan() {
  //aktualisiert _stundenplanA an Hand von facher
  stundenplanA = List.generate(
      wochentage.length, (_) => List.generate(stunden.length, (_) => []));
  for (int f = 0; f < faecher.faecher.length; f++) {
    Fach myFach = faecher.faecher[f];
    for (int w = 0; w < wochentage.length; w++) {
      SplayTreeSet<int>? myZeiten = myFach.zeiten[w];
      if (myZeiten != null) {
        for (int s in myZeiten) {
          stundenplanA[w][s].add(myFach.name);
        }
      }
    }
  }
}

CupertinoButton getButton({
  //gibt einen Button zurück
  required BuildContext context,
  required int changingFach,
  required int d,
  required int h,
  required int a,
}) {
  if (stundenplanA[d][h].isEmpty) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: changingFach == -1
          ? null
          : () => clickButton(
              context: context,
              changingFach: changingFach,
              d: d,
              h: h,
              a: a), //if _changingFach == -1, onPressed is null, else onPressed is _clickButton
      color: stundenplanFreeColor,
      disabledColor: stundenplanFreeColor,
      pressedOpacity: 1.0,
      child: const Text('Frei'),
    );
  } else {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        clickButton(
            context: context, changingFach: changingFach, d: d, h: h, a: a);
      },
      color: faecher.faecher[getFachIndex(d: d, h: h, a: a)].farbe,
      //disabledColor: _hourColor,
      pressedOpacity: 1.0,
      child: Text(stundenplanA[d][h][a]),
    );
  }
}

void clickButton({
  required BuildContext context,
  required int changingFach,
  required int d,
  required int h,
  required int a,
}) {
  if (changingFach == -1) {
    int index = getFachIndex(d: d, h: h, a: a);
    if (index != -1) {
      Navigator.of(context).push(
        CupertinoPageRoute(builder: (context) => faecher.faecher[index]),
      );
    }
  } else {
    SplayTreeMap<int, SplayTreeSet<int>> zeiten =
        SplayTreeMap.from(faecher.faecher[changingFach].zeiten);
    Fach currentFach = faecher.faecher[changingFach];
    if (zeiten[d]?.contains(h) ?? false) {
      //Wenn das Fach bereits in der Stunde eingetragen ist, wird es entfernt
      SplayTreeSet<int> tempZeitenSet = SplayTreeSet.from(zeiten[d] ?? {});
      tempZeitenSet.remove(h);
      zeiten[d] = tempZeitenSet;
      faecher.updateFach(
          index: changingFach, name: currentFach.name, zeiten: zeiten);
    } else {
      //Wenn das Fach noch nicht in der Stunde eingetragen ist, wird es hinzugefügt
      if (zeiten[d] == null) {
        zeiten[d] = SplayTreeSet.from({h});
        faecher.updateFach(
            index: changingFach, name: currentFach.name, zeiten: zeiten);
      } else {
        SplayTreeSet<int> tempZeitenSet = SplayTreeSet.from(zeiten[d] ?? {});
        tempZeitenSet.add(h);
        zeiten[d] = tempZeitenSet;
        faecher.updateFach(
            index: changingFach, name: currentFach.name, zeiten: zeiten);
      }
    }
  }
}

int getFachIndex({required int d, required int h, required int a}) {
  int o = -1;
  for (int f = 0; f < faecher.faecher.length; f++) {
    if (faecher.faecher[f].zeiten[d]?.contains(h) ?? false) {
      o++;
      if (a == o) {
        return f;
      }
    }
  }
  return -1;
}
