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

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
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
  /*
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),

      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Fächerliste',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Hausaufgabenheft',
          ),
        ],
        
          onTap: (index) {
            if (index == 0) {
              _incrementCounter();
            }
            if(index == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HausaufgabenheftPage()),
              );
            }
          },
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
    );
  }
  */
}

