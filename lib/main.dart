import 'package:flutter/cupertino.dart';
import 'hausaufgabenheft.dart';

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
          ],
        ), 
        tabBuilder: (BuildContext context, int index) {
        return CupertinoTabView(
          builder: (BuildContext context) {
            return Center(
              child: Text('Content of tab $index'),
            );
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

