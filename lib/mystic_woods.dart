import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/painting.dart';
import 'package:mystic_woods/components/player.dart';
import 'package:mystic_woods/game_config.dart';
import 'package:mystic_woods/components/level.dart';

class MysticWoods extends FlameGame
    with HasKeyboardHandlerComponents, DragCallbacks {
  MysticWoods({required this.showJoyStick});

  final bool showJoyStick;

  late final CameraComponent cam;
  JoystickComponent? joystick;
  final Player player = Player(character: GameConfig.character);

  @override
  FutureOr<void> onLoad() async {
    await images.loadAllImages();

    final world = Level(
      levelName: GameConfig.map,
      player: player,
    );

    cam = CameraComponent.withFixedResolution(
      world: world,
      width: 640,
      height: 360,
    );

    cam.viewfinder.anchor = Anchor.topLeft;

    addAll([cam, world]);
    addJoystick();

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (showJoyStick) {
      updateJoystick();
    }
    super.update(dt);
  }

  void addJoystick() {
    if (!showJoyStick) {
      return;
    }

    joystick = JoystickComponent(
      knob: SpriteComponent(
        sprite: Sprite(
          images.fromCache('HUD/knob.png'),
        ),
      ),
      knobRadius: 64,
      background: SpriteComponent(
        sprite: Sprite(
          images.fromCache('HUD/joystick.png'),
        ),
      ),
      margin: const EdgeInsets.only(left: 5, bottom: 5),
    );

    add(joystick!);
  }

  void updateJoystick() {
    if (joystick == null) return;

    switch (joystick!.direction) {
      case JoystickDirection.left:
        player.playerDirection = PlayerDirection.left;
        break;
      case JoystickDirection.upLeft:
        player.playerDirection = PlayerDirection.left;
        player.playerDirection = PlayerDirection.up;
        break;
      case JoystickDirection.downLeft:
        player.playerDirection = PlayerDirection.left;
        player.playerDirection = PlayerDirection.down;
        break;
      case JoystickDirection.right:
        player.playerDirection = PlayerDirection.right;
        break;
      case JoystickDirection.upRight:
        player.playerDirection = PlayerDirection.right;
        player.playerDirection = PlayerDirection.up;
        break;
      case JoystickDirection.downRight:
        player.playerDirection = PlayerDirection.right;
        player.playerDirection = PlayerDirection.down;
        break;
      case JoystickDirection.up:
        player.playerDirection = PlayerDirection.up;
        break;
      case JoystickDirection.down:
        player.playerDirection = PlayerDirection.down;
        break;
      default:
        player.playerDirection = PlayerDirection.none;
        break;
    }
  }
}
