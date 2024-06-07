// Die Seite für die Einstellungen

import 'package:flutter/cupertino.dart';
import 'package:suppaapp/globals.dart';

class Einstellungen extends StatefulWidget {
  const Einstellungen({super.key});

@override
  State<Einstellungen> createState() => EinstellungenState();
}

class EinstellungenState extends State<Einstellungen> {

  final TextEditingController _stundenplanHoeheController = TextEditingController();
  //final GlobalKey _stundenplanHoeheKey = GlobalKey();

  @override
  void initState() {
    _stundenplanHoeheController.text = '1.3';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Column(
        children: [
          const CupertinoNavigationBar(
            middle: Text('Einstellungen'),
          ),
          CupertinoListSection(
            children: [
              CupertinoListTile(
                title: const Text('Höhe Stundenplan'),
                subtitle: const Text('Die Höhe der Reien im Stundenplan im Vergleich zu den Spalten (bei einem Wert von 2 ist jede Stunde doppelt so hoch wie breit)', maxLines: 3,),
                //additionalInfo: SizedBox(height: ((_stundenplanHoeheKey.currentContext?.findRenderObject() as RenderBox?)?.size?.height ?? 30)*_stundenplanHoeheKey,),
                //key: _stundenplanHoeheKey,
                trailing: SizedBox(
              width: 56,
              child: CupertinoTextField(
                controller: _stundenplanHoeheController,
                autocorrect: false,
                textAlign: TextAlign.center,
                maxLines: 1,
                onSubmitted: (value) {
                  if (value != '') {
                    try {
                      value = value.replaceAll(',', '.');
                      setState(() {
                        if (double.parse(value) <= 5) {
                          if (double.parse(value) >= 0.2) {
                            stundenplanHoeheNotifier.value = double.parse(value);
                          } else {
                            _stundenplanHoeheController.text = '0.2';
                            stundenplanHoeheNotifier.value = 0.2;
                          }
                        } else {
                          _stundenplanHoeheController.text = '5';
                          stundenplanHoeheNotifier.value = 5;
                        }
                      });
                    } catch (e) {
                      _stundenplanHoeheController.text = stundenplanHoeheNotifier.value.toString();
                    }
                  }
                },
              ),
            ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
