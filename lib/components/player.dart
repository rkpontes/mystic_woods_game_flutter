// ignore_for_file: use_super_parameters

import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:mystic_woods/mystic_woods.dart';

enum PlayerState { idle, running }

enum PlayerDirection { up, down, left, right, none }

enum PlayerFacing { left, right }

class Player extends SpriteAnimationGroupComponent
    with HasGameRef<MysticWoods>, KeyboardHandler {
  String character;

  Player({
    position,
    required this.character,
  }) : super(position: position);

  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;

  PlayerDirection playerDirection = PlayerDirection.none;
  double moveSpeed = 100;
  Vector2 velocity = Vector2.zero();
  PlayerFacing playerFacing = PlayerFacing.right;

  @override
  FutureOr<void> onLoad() {
    _onLoadAllAnimations();
    return super.onLoad();
  }

  @override
  void update(double dt) {
    _updatePlayerMovement(dt);
    super.update(dt);
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final isLeftKeyPressed =
        keysPressed.contains(LogicalKeyboardKey.arrowLeft) ||
            keysPressed.contains(LogicalKeyboardKey.keyA);
    final isRightKeyPressed =
        keysPressed.contains(LogicalKeyboardKey.arrowRight) ||
            keysPressed.contains(LogicalKeyboardKey.keyD);
    final isUpKeyPressed = keysPressed.contains(LogicalKeyboardKey.arrowUp) ||
        keysPressed.contains(LogicalKeyboardKey.keyW);
    final isDownKeyPressed =
        keysPressed.contains(LogicalKeyboardKey.arrowDown) ||
            keysPressed.contains(LogicalKeyboardKey.keyS);

    // speed
    if (keysPressed.contains(LogicalKeyboardKey.shiftLeft) ||
        keysPressed.contains(LogicalKeyboardKey.shiftRight)) {
      moveSpeed = 200;
    } else {
      moveSpeed = 100;
    }

    // direction
    if (isLeftKeyPressed && isRightKeyPressed) {
      playerDirection = PlayerDirection.none;
    } else if (isLeftKeyPressed) {
      playerDirection = PlayerDirection.left;
    } else if (isRightKeyPressed) {
      playerDirection = PlayerDirection.right;
    } else if (isUpKeyPressed && isDownKeyPressed) {
      playerDirection = PlayerDirection.none;
    } else if (isUpKeyPressed) {
      playerDirection = PlayerDirection.up;
    } else if (isDownKeyPressed) {
      playerDirection = PlayerDirection.down;
    } else {
      playerDirection = PlayerDirection.none;
    }

    return super.onKeyEvent(event, keysPressed);
  }

  void _onLoadAllAnimations() {
    animations = {
      PlayerState.idle: _spriteAnimation(PlayerState.idle),
      PlayerState.running: _spriteAnimation(PlayerState.running),
    };

    current = PlayerState.idle;
  }

  SpriteAnimation _spriteAnimation(PlayerState state) {
    double stepTime = 0.09;
    int amount = 7;

    if (state == PlayerState.idle) {
      amount = 1;
    }

    return SpriteAnimation.fromFrameData(
      game.images
          .fromCache('rpg-pack/chars/$character/$character-idle-run.png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: stepTime,
        textureSize: Vector2.all(24),
      ),
    );
  }

  void _updatePlayerMovement(double dt) {
    double dirX = 0.0;
    double dirY = 0.0;
    switch (playerDirection) {
      case PlayerDirection.left:
        if (playerFacing != PlayerFacing.left) {
          flipHorizontallyAroundCenter();
          playerFacing = PlayerFacing.left;
        }
        current = PlayerState.running;
        dirX -= moveSpeed;
        break;
      case PlayerDirection.right:
        if (playerFacing != PlayerFacing.right) {
          flipHorizontallyAroundCenter();
          playerFacing = PlayerFacing.right;
        }
        current = PlayerState.running;
        dirX += moveSpeed;
        break;
      case PlayerDirection.up:
        current = PlayerState.running;
        dirY -= moveSpeed;
        break;
      case PlayerDirection.down:
        current = PlayerState.running;
        dirY += moveSpeed;
        break;
      case PlayerDirection.none:
        current = PlayerState.idle;
        break;
      default:
        break;
    }
    velocity = Vector2(dirX, dirY);
    position += velocity * dt;
  }
}
