// Die Seite für die Einstellungen

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:suppaapp/globals.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';

class Einstellungen extends StatefulWidget {
  const Einstellungen({super.key});

  @override
  State<Einstellungen> createState() => EinstellungenState();
}

class EinstellungenState extends State<Einstellungen> {
  late Future<String> _latestVersion;
  final TextEditingController _stundenplanHoeheController = TextEditingController();
  bool _darkmode = (themeNotifier.value.brightness == Brightness.dark);
  final TextEditingController _anzahlStundenController = TextEditingController();
  //final GlobalKey _stundenplanHoeheKey = GlobalKey();

  Future<String> _loadLatestVersion() async {
    late final Response response;
    try {
      response = await get(
        Uri.parse('https://api.github.com/repos/sartamo/ludus/releases/latest'), 
        headers: {'Accept': 'application/vnd.github+json'}
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> content = jsonDecode(response.body);
        dynamic version = content['name'];
        if (version != null && version is String) {
          return version;
        } else {
          throw const FormatException('Could not find version number: Invalid json file');
        }
      } else {
        throw ClientException('Could not fetch data: Status code ${response.statusCode}');
      }
    } catch(e) {
      return Future.error(e.toString());
    }
  }

  // Funktionen bzgl. Laden der aktuellen Version von Github

  Widget _loading() => CupertinoListTile( // Die Daten werden gerade heruntergeladen
    title: const Text(''),
    trailing: CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {},
      child: const CupertinoActivityIndicator(),
    ),
  );

  Widget _error(String error) => CupertinoListTile( // Konnte die Daten nicht herunterladen
    title: const Text(
      'Konnte keine Verbindung zu Github aufbauen.',
      style: TextStyle(
        color: CupertinoColors.destructiveRed,
      ),
    ),
    subtitle: Text(error),
    trailing: CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        setState(() {_latestVersion = _loadLatestVersion();});
      },
      child: const Icon(CupertinoIcons.refresh),
    ),
  );

  Widget _checkPositive() => CupertinoListTile( // Daten wurden geholt: Die App ist aktuell
    title: const Text(
      'Du hast die aktuellste Version der App: $currentVersion',
      style: TextStyle(
        color: CupertinoColors.activeGreen,
      ),
    ),
    trailing: CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        setState(() {_latestVersion = _loadLatestVersion();});
      },
      child: const Icon(CupertinoIcons.refresh),
    ),
  );

  Widget _checkNegative(String newVersion) => CupertinoListTile( // Daten wurden geholt: Es gibt eine neue Version newVersion der App
    title: Text(
      'Version $newVersion ist erschienen',
      style: const TextStyle(
        color: CupertinoColors.activeBlue,
      ),
    ),
    subtitle: const Text('Tippe, um zum Downloadlink zu gelangen'),
    trailing: CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        setState(() {_latestVersion = _loadLatestVersion();});
      },
      child: const Icon(CupertinoIcons.refresh),
    ),
    onTap:() async {
      final Uri url = Uri.parse('https://github.com/sartamo/ludus/releases/latest');
      if (!await launchUrl(url)) {
        throw Exception('Could not launch $url');
      }
    },
  );

  List<Widget> _getUniversalWidgets() => [ // Die CupertinoListTiles, die in allen Versionen der App verwendet werden (auch Web)
    CupertinoListTile(
      title: const Text('Darkmode'),
      subtitle: const Text('Dunke Anzeige'),
      trailing: CupertinoSwitch(
        value: _darkmode,
        onChanged: (bool? value) {
          themeNotifier.value = value ?? false
          ? const CupertinoThemeData(brightness: Brightness.dark)
          : const CupertinoThemeData(brightness: Brightness.light);
        },
      ),
    ),
    CupertinoListTile(
      title: const Text('Stundenplan Höhe'),
      subtitle: const Text('Höhe der Tiles im Verhältnis zur Breite', maxLines: 3,),
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
    CupertinoListTile(
      title: const Text('Wochenende im Stundenplan'),
      subtitle: const Text('Zeigt im Stundenplan auch Samstag und Sonntag an'),
      trailing: CupertinoSwitch(
        value: wochenendeNotifier.value,
        onChanged: (bool value) {
          setState(() {
            wochenendeNotifier.value = value;
          });
        },
      ),
    ),
    CupertinoListTile(
      title: const Text('Stunden pro Tag'),
      subtitle: const Text('Die Anzahl der Stunden pro Tag, die im Stundenplan angezeigt werden'),
      trailing: SizedBox(
        width: 56,
        child: CupertinoTextField(
          controller: _anzahlStundenController,
          autocorrect: false,
          textAlign: TextAlign.center,
          maxLines: 1,
          maxLength: 2,
          onChanged: (value) {
            if (value != '') {
              try {
                value = value.replaceAll(',', '.');
                setState(() {
                    if (int.parse(value) >= 1 && int.parse(value) <= 99) {
                      anzahlStundenNotifier.value = int.parse(value);
                    } else {
                      _anzahlStundenController.text = '1';
                      anzahlStundenNotifier.value = 1;
                    }
                });
              } catch (e) {
                _anzahlStundenController.text = anzahlStundenNotifier.value.toString();
              }
            }
          },
          onSubmitted: (value) {
            if(value == '') {
              _anzahlStundenController.text = anzahlStundenNotifier.value.toString();
            }
          },
        ),
      ),
    ),
  ];

  List<Widget> _getAndroidWidgets() => _getUniversalWidgets()..insert(
    0, 
    FutureBuilder(
      future: _latestVersion,
      builder: (context, snapshot) => snapshot.connectionState != ConnectionState.done
        ? _loading()
        : snapshot.hasError
        ? _error(snapshot.error.toString())
        : snapshot.hasData
        ? snapshot.data == currentVersion
          ? _checkPositive()
          : _checkNegative(snapshot.data!) 
        : _loading() // Kein definierter State: Wahrscheinlich loading
    ),
  );

  @override
  void initState() {
    if (defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.linux) {
      _latestVersion = _loadLatestVersion();
    }
    _stundenplanHoeheController.text = stundenplanHoeheNotifier.value.toString();
    _anzahlStundenController.text = anzahlStundenNotifier.value.toString();
    stundenplanHoeheNotifier.addListener(() {
      setState(() {
        _stundenplanHoeheController.text = stundenplanHoeheNotifier.value.toString();
      });
    });
    themeNotifier.addListener(() {
      setState(() {
        _darkmode = ((themeNotifier.value.brightness == Brightness.dark));
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Einstellungen'),
      ),
      child: SafeArea(
        minimum: EdgeInsets.only(
          top: const CupertinoNavigationBar().preferredSize.height,
        ),
        child: SingleChildScrollView(
          child: CupertinoListSection(
            children: defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.linux
              ? _getAndroidWidgets() // Android: Release Notification
              : _getUniversalWidgets() // Alles außer Android (hat keine Releases auf Github)
          ),
        ),
      ),
    );
  }
}
