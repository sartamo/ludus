import 'package:flutter/cupertino.dart';
import 'package:suppaapp/hausaufgabenheft.dart';
import 'package:suppaapp/faecherliste.dart';
import 'package:suppaapp/Stundenplan/anzeige.dart';
import 'package:suppaapp/einstellungen.dart';
import 'package:suppaapp/notizen.dart';
import 'package:suppaapp/globals.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const Suppaapp());

class Suppaapp extends StatefulWidget {
  const Suppaapp({super.key});

  // This widget is the root of your application.
  @override
  State<Suppaapp> createState() => SuppaappState();
}

class SuppaappState extends State<Suppaapp> {
  Future<void> _loadPreferences() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    double? stundenplanHoehe = preferences.getDouble('stundenplanHoehe');
    if (stundenplanHoehe != null) {
      stundenplanHoeheNotifier.value = stundenplanHoehe;
    }
    bool? darkmode = preferences.getBool('darkmode');
    if (darkmode != null) {
      themeNotifier.value = darkmode
      ? const CupertinoThemeData(brightness: Brightness.dark)
      : const CupertinoThemeData(brightness: Brightness.light);
    }
  }

  Future<void> _savePreferences() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setDouble('stundenplanHoehe', stundenplanHoeheNotifier.value);
    preferences.setBool('darkmode', (themeNotifier.value.brightness == Brightness.dark));
  }

  CupertinoThemeData _theme = const CupertinoThemeData(brightness: Brightness.light);

  @override
  void initState() {
    super.initState();
    _loadPreferences();
    themeNotifier.addListener(() {
      setState(() {
        _theme = themeNotifier.value;
      });
      _savePreferences();
    });
    stundenplanHoeheNotifier.addListener(() {
      _savePreferences();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner : false,
      title: 'Ludus',
      theme: _theme,
      home: const Homepage(),
    );
  }
}

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context){
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.list_bullet),
            label: 'Fächerliste',
            tooltip: 'Fächerliste',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.book),
            label: 'Hausaufgaben',
            tooltip: 'Hausaufgaben',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.pencil),
            label: 'Notizheft',
            tooltip: 'Notizheft',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.table),
            label: 'Stundenplan',
            tooltip: 'Stundenplan',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.settings),
            label: 'Einstellungen',
            tooltip: 'Einstellungen',
          ),
        ],
      ), 
      tabBuilder: (BuildContext context, int index) {
        return CupertinoTabView(
          builder: (BuildContext context) {
            return index == 0
            ? const Faecherliste()
            : index == 1
            ? const Hausaufgabenheft()
            : index == 2
            ? const Notizen()
            : index == 3
            ? const Stundenplan()
            : const Einstellungen();
          },
        );
      },
    );
  }
}