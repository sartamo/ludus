import 'package:flutter/cupertino.dart';
import 'hausaufgabenheft.dart';
import 'faecherliste.dart';
import 'stundenplan.dart';
import 'einstellungen.dart';

void main() => runApp(const Suppaapp());


class Suppaapp extends StatelessWidget {
  const Suppaapp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
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
            icon: Icon(CupertinoIcons.time),
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
            if(index==0){
              return const Faecherliste();
            }
            else if(index==1){
              return const Hausaufgabenheft();
            }
            else if (index==2){
              return const Stundenplan();
            }
            else if (index==3){
              return const Einstellungen();
            }
            else{
              return const Center(
                child: Text('Fehlerhafte Implementierung von Seitenwechsel'), // Wird normalerweise nicht angezeigt
              );
            }
          },
        );
      },
    );
  }
}