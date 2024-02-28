import 'package:flutter/cupertino.dart';
import 'package:suppaapp/hausaufgabenheft.dart';
import 'package:suppaapp/faecherliste.dart';
import 'package:suppaapp/Stundenplan/anzeige.dart';
import 'package:suppaapp/einstellungen.dart';
import 'package:suppaapp/notizen.dart';

void main() => runApp(const Suppaapp());

class Suppaapp extends StatelessWidget {
  const Suppaapp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      debugShowCheckedModeBanner : false,
      title: 'Schulus Appus',
      theme: CupertinoThemeData(brightness: Brightness.light),
      home: Homepage(),
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
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.book),
            label: 'Hausaufgabenheft',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.pencil),
            label: 'Notizheft'
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.table),
            label: 'Stundenplan'
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.settings),
            label: 'Einstellungen'
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