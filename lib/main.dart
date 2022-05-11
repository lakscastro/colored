import 'dart:async';

import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wakelock/wakelock.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

  runApp(const ColoredApp());
}

class ColoredApp extends StatelessWidget {
  const ColoredApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Color _color = Colors.green;

  ColorPicker colorPickerDialog() {
    return ColorPicker(
      color: _color,
      onColorChanged: (color) => setState(() => _color = color),
      showMaterialName: true,
      showColorName: true,
      showColorCode: true,
      actionButtons: const ColorPickerActionButtons(
        dialogActionButtons: false,
      ),
      copyPasteBehavior: const ColorPickerCopyPasteBehavior(
        longPressMenu: true,
      ),
      pickersEnabled: const <ColorPickerType, bool>{
        ColorPickerType.both: false,
        ColorPickerType.primary: true,
        ColorPickerType.accent: true,
        ColorPickerType.bw: false,
        ColorPickerType.custom: true,
        ColorPickerType.wheel: true,
      },
    );
  }

  void _handleOpenColorPicker() {
    colorPickerDialog().showPickerDialog(
      context,
      constraints:
          const BoxConstraints(minHeight: 460, minWidth: 300, maxWidth: 320),
    );
  }

  Stream<bool>? _stream;
  bool _on = true;

  static const _k100ms = Duration(milliseconds: 100);

  @override
  void initState() {
    super.initState();

    _stream = Stream<bool>.periodic(_k100ms, (i) => i.isEven);

    Wakelock.enable();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onLongPress: _handleOpenColorPicker,
        onTap: () => _on = !_on,
        child: StreamBuilder<bool>(
          stream: _stream,
          builder: (context, snapshot) {
            return Container(
              color: _on
                  ? snapshot.data ?? true
                      ? _color
                      : Colors.black
                  : _color,
            );
          },
        ),
      ),
    );
  }
}
