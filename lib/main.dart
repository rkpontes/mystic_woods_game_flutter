import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mystic_woods/components/level.dart';
import 'package:mystic_woods/components/player.dart';
import 'package:mystic_woods/core/game_config.dart';
import 'package:mystic_woods/game_world.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();

  final player = Player(character: GameConfig.character);
  final world = Level(
    levelName: GameConfig.map,
    player: player,
  );
  GameWorld game = GameWorld(
    player: player,
    world: world,
    showJoyStick: GameConfig.showJoyStick,
  );
  runApp(
    GameWidget(
        game: kDebugMode
            ? GameWorld(
                player: player,
                world: world,
                showJoyStick: GameConfig.showJoyStick,
              )
            : game),
  );
}
