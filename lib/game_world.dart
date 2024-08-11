import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';
import 'package:mystic_woods/components/player.dart';
import 'package:mystic_woods/components/level.dart';

class GameWorld extends FlameGame
    with HasKeyboardHandlerComponents, DragCallbacks {
  GameWorld({
    required this.world,
    required this.player,
    required this.showJoyStick,
  });

  @override
  final Level world;
  final bool showJoyStick;
  final Player player;

  late final CameraComponent cam;
  JoystickComponent? joystick;

  @override
  FutureOr<void> onLoad() async {
    await images.loadAllImages();

    cam = CameraComponent.withFixedResolution(
      world: world,
      width: 640,
      height: 360,
    );

    cam.viewfinder.anchor = Anchor.topLeft;
    cam.viewport.anchor = Anchor.topLeft;

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
      knobRadius: 120,
      background: SpriteComponent(
        sprite: Sprite(
          images.fromCache('HUD/joystick.png'),
        ),
      ),
      margin: const EdgeInsets.only(left: 15, bottom: 15),
    );

    add(joystick!);
  }

  void updateJoystick() {
    if (joystick == null) return;

    switch (joystick!.direction) {
      case JoystickDirection.left:
        player.horizontalMoviment = -1;
        break;
      case JoystickDirection.right:
        player.horizontalMoviment = 1;
        break;
      case JoystickDirection.up:
        player.verticalMoviment = -1;
        break;
      case JoystickDirection.down:
        player.verticalMoviment = 1;
        break;
      case JoystickDirection.upLeft:
        player.horizontalMoviment = -1;
        player.verticalMoviment = -1;
        break;
      case JoystickDirection.upRight:
        player.horizontalMoviment = 1;
        player.verticalMoviment = -1;
        break;
      case JoystickDirection.downLeft:
        player.horizontalMoviment = -1;
        player.verticalMoviment = 1;
        break;
      case JoystickDirection.downRight:
        player.horizontalMoviment = 1;
        player.verticalMoviment = 1;
        break;
      default:
        player.horizontalMoviment = 0;
        player.verticalMoviment = 0;
        break;
    }
  }
}
