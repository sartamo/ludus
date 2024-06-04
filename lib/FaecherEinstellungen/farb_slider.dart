import 'package:flutter/cupertino.dart';

class FarbSlider extends StatefulWidget {
  final MutableFarbe farbe;
  final ValueNotifier<bool> colorNotifier;

  const FarbSlider(
      {super.key, required this.farbe, required this.colorNotifier});

  @override
  FarbSliderState createState() => FarbSliderState();
}

class FarbSliderState extends State<FarbSlider> {
  final double _colorTextFieldWidth = (TextPainter(
              text: const TextSpan(text: '255'),
              textDirection: TextDirection.ltr)
            ..layout())
          .width +
      32;
  late int _colorRed;
  late int _colorGreen;
  late int _colorBlue;
  final TextEditingController _redController = TextEditingController();
  final TextEditingController _greenController = TextEditingController();
  final TextEditingController _blueController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _colorRed = widget.farbe.farbe.red;
    _colorGreen = widget.farbe.farbe.green;
    _colorBlue = widget.farbe.farbe.blue;
    _redController.text = _colorRed.toString();
    _greenController.text = _colorGreen.toString();
    _blueController.text = _colorBlue.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const SizedBox(
              width: 50,
              child: Text('Rot:'),
            ),
            SizedBox(
              width: _colorTextFieldWidth,
              child: CupertinoTextField(
                controller: _redController,
                autocorrect: false,
                keyboardType: TextInputType.number,
                maxLength: 3,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  if (value != '') {
                    try {
                      setState(() {
                        if (int.parse(value) <= 255) {
                          if (int.parse(value) >= 0) {
                            _colorRed = int.parse(value);
                          } else {
                            _redController.text = '0';
                            _colorRed = 0;
                          }
                        } else {
                          _redController.text = '255';
                          _colorRed = 255;
                        }
                        widget.farbe.farbe = Color.fromARGB(
                            255, _colorRed, _colorGreen, _colorBlue);
                        widget.colorNotifier.value =
                            !widget.colorNotifier.value;
                      });
                    } catch (e) {
                      _redController.text = _colorRed.toString();
                    }
                  }
                },
              ),
            ),
            Expanded(
              child: CupertinoSlider(
                activeColor: CupertinoColors.systemRed,
                value: _colorRed.toDouble(),
                onChanged: (r) {
                  setState(() {
                    _colorRed = r.toInt();
                    _redController.text = r.toInt().toString();
                    widget.farbe.farbe =
                        Color.fromARGB(255, _colorRed, _colorGreen, _colorBlue);
                  });
                },
                onChangeEnd: (value) =>
                    widget.colorNotifier.value = !widget.colorNotifier.value,
                min: 0,
                max: 255,
                thumbColor: widget.farbe.farbe,
              ),
            ),
          ],
        ),
        Row(
          children: [
            const SizedBox(
              width: 50,
              child: Text('Grün:'),
            ),
            SizedBox(
              width: _colorTextFieldWidth,
              child: CupertinoTextField(
                controller: _greenController,
                autocorrect: false,
                keyboardType: TextInputType.number,
                maxLength: 3,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  if (value != '') {
                    try {
                      setState(() {
                        if (int.parse(value) <= 255) {
                          if (int.parse(value) >= 0) {
                            _colorGreen = int.parse(value);
                          } else {
                            _greenController.text = '0';
                            _colorGreen = 0;
                          }
                        } else {
                          _greenController.text = '255';
                          _colorGreen = 255;
                        }
                        widget.farbe.farbe = Color.fromARGB(
                            255, _colorRed, _colorGreen, _colorBlue);
                        widget.colorNotifier.value =
                            !widget.colorNotifier.value;
                      });
                    } catch (e) {
                      _greenController.text = _colorGreen.toString();
                    }
                  }
                },
              ),
            ),
            Expanded(
              child: CupertinoSlider(
                activeColor: CupertinoColors.systemGreen,
                value: _colorGreen.toDouble(),
                onChanged: (r) {
                  setState(() {
                    _colorGreen = r.toInt();
                    _greenController.text = r.toInt().toString();
                    widget.farbe.farbe =
                        Color.fromARGB(255, _colorRed, _colorGreen, _colorBlue);
                  });
                },
                onChangeEnd: (value) =>
                    widget.colorNotifier.value = !widget.colorNotifier.value,
                min: 0,
                max: 255,
                thumbColor: widget.farbe.farbe,
              ),
            ),
          ],
        ),
        Row(
          children: [
            const SizedBox(
              width: 50,
              child: Text('Blau:'),
            ),
            SizedBox(
              width: _colorTextFieldWidth,
              child: CupertinoTextField(
                controller: _blueController,
                autocorrect: false,
                keyboardType: TextInputType.number,
                maxLength: 3,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  if (value != '') {
                    try {
                      setState(() {
                        if (int.parse(value) <= 255) {
                          if (int.parse(value) >= 0) {
                            _colorBlue = int.parse(value);
                          } else {
                            _blueController.text = '0';
                            _colorBlue = 0;
                          }
                        } else {
                          _blueController.text = '255';
                          _colorBlue = 255;
                          widget.farbe.farbe = Color.fromARGB(
                              255, _colorRed, _colorGreen, _colorBlue);
                          widget.colorNotifier.value =
                              !widget.colorNotifier.value;
                        }
                      });
                    } catch (e) {
                      _blueController.text = _colorBlue.toString();
                    }
                  }
                },
              ),
            ),
            Expanded(
              child: CupertinoSlider(
                activeColor: CupertinoColors.systemBlue,
                value: _colorBlue.toDouble(),
                onChanged: (r) {
                  setState(() {
                    _colorBlue = r.toInt();
                    _blueController.text = r.toInt().toString();
                    widget.farbe.farbe =
                        Color.fromARGB(255, _colorRed, _colorGreen, _colorBlue);
                  });
                },
                onChangeEnd: (value) =>
                    widget.colorNotifier.value = !widget.colorNotifier.value,
                min: 0,
                max: 255,
                thumbColor: widget.farbe.farbe,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class MutableFarbe {
  // MutableFarbe speichert eine Farbe als Referenz, damit sie einfach weitergegeben werden kann, da Color immutable ist
  Color farbe;
  MutableFarbe({required this.farbe});
}
