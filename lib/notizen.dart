import 'package:flutter/cupertino.dart';
import 'package:suppaapp/Faecher/management.dart';
import 'package:suppaapp/Faecher/faecher.dart';
import 'package:suppaapp/Notizen/bearbeiten.dart';
import 'package:suppaapp/Notizen/hinzufuegen.dart';

class Notizen extends StatefulWidget {
  const Notizen({super.key});

  @override
  State<Notizen> createState() => _NotizenState();
}

class _NotizenState extends State<Notizen> {
  // Gibt true zurück, wenn die Notizen aller Fächer leer sind
  bool _isNotizenEmpty() {
    bool result = true;
    for (Fach fach in faecher.faecher) {
      if (fach.notizen.isNotEmpty) {
        result = false;
      }
    }
    return result;
  }

  Future<(String, String)?> _notizHinzufuegen() async {
    (String, String)? result = await Navigator.of(context).push(
      CupertinoPageRoute(builder: (context) => const NotizHinzufuegen())
    );
    return result;
  }

  @override
  void initState() {
    super.initState();
    faecher.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    faecher.removeListener(() {});
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Notizen'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.add),
          onPressed: () {
            showCupertinoModalPopup(
              context: context,
              builder: ((context) => CupertinoActionSheet(
                title: const Text('Fach auswählen'),
                message: const Text('Wähle das Fach aus, für das du eine Notiz hinzufügen möchstest'),
                actions: List<Widget>.generate(faecher.faecher.length, (index) => 
                  CupertinoActionSheetAction(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Future<(String, String)?> result = _notizHinzufuegen();
                      result.then((value) {
                        if (value != null) {
                          faecher.updateFach(
                            index: index,
                            notizen: faecher.faecher[index].notizen + [value]
                          );
                        }
                      });
                    },
                    child: Text(faecher.faecher[index].name),
                  ),
                )
              ))
            );
          },
        ),
      ),
      child: SafeArea(
        minimum: EdgeInsets.only(
          top: const CupertinoNavigationBar().preferredSize.height,
        ),
        child: SingleChildScrollView(
          child: _isNotizenEmpty()
          ? const Column(
            children: <Widget> [
              SizedBox(height: 20),
              Center(child: Text('Du hast noch keine Notizen erstellt'))
            ]
          )
          : Column(
            children: List<Widget>.generate(
              faecher.faecher.length, 
              (i) => faecher.faecher[i].notizen.isEmpty
              ? const SizedBox.shrink() // Ein leeres Widget, wenn die Notizen von einem Fach keinen Inhalt haben
              : CupertinoListSection(
                header: Text(faecher.faecher[i].name),
                children: List<Widget>.generate(
                  faecher.faecher[i].notizen.length, 
                  (j) => CupertinoListTile(
                    title: Text(faecher.faecher[i].notizen[j].$1), // i. Fach, j. Eintrag: Titel der Notiz
                    subtitle: Text(faecher.faecher[i].notizen[j].$2), // i. Fach, j. Eintrag: Inhalt der Notiz (erste Zeile)
                    onTap: () async {
                      (String, String)? result = await Navigator.of(context).push(CupertinoPageRoute(
                        builder: ((context) => NotizBearbeiten(faecher.faecher[i].notizen[j]))
                      ));
                      if (result != null) {
                        faecher.faecher[i].notizen[j] = result;
                        faecher.updateFach(
                          index: i,
                        );
                      }
                    },
                    trailing: CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: const Icon(CupertinoIcons.minus),
                      onPressed: () => faecher.updateFach(
                        index: i,
                        notizen: faecher.faecher[i].notizen..removeAt(j)
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}