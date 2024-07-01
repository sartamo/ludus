// Hier kommen globale Variablen hin
import 'package:flutter/cupertino.dart';

const List<String> wochentage = [
  'Montag',
  'Dienstag',
  'Mittwoch',
  'Donnerstag',
  'Freitag',
  'Samstag',
  'Sonntag'
];

final List<String> stunden = List.generate(99, (index) => '${index + 1}. Stunde');

final ValueNotifier<double> stundenplanHoeheNotifier = ValueNotifier<double>(1.3);
final ValueNotifier<CupertinoThemeData> themeNotifier = ValueNotifier<CupertinoThemeData>(const CupertinoThemeData(brightness: Brightness.light));
final ValueNotifier<bool> wochenendeNotifier = ValueNotifier<bool>(false);
final ValueNotifier<int> anzahlStundenNotifier = ValueNotifier<int>(6);

const String currentVersion = 'v0.1.5';

const double widthMultiplier = 0.05; // Abstand zum Rand seitlich: Multiplier von context width
const double heightMultiplier = 0.05; // Abstand zur Navigation Bar von bestimmten Inhalten: Multiplier von context height