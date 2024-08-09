import 'dart:io';

import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mystic_woods/mystic_woods.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();

  bool showJoyStick = Platform.isAndroid || Platform.isIOS;

  MysticWoods game = MysticWoods(showJoyStick: showJoyStick);
  runApp(
    GameWidget(
        game: kDebugMode ? MysticWoods(showJoyStick: showJoyStick) : game),
  );
}
