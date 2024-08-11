// ignore_for_file: use_super_parameters

import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:mystic_woods/components/collision_area.dart';
import 'package:mystic_woods/components/hitbox_area.dart';
import 'package:mystic_woods/core/utils.dart';
import 'package:mystic_woods/game_world.dart';

enum PlayerState { idle, running }

class Player extends SpriteAnimationGroupComponent
    with HasGameRef<GameWorld>, KeyboardHandler {
  String character;

  Player({
    position,
    required this.character,
  }) : super(position: position);

  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;

  double horizontalMoviment = 0.0;
  double verticalMoviment = 0.0;
  double moveSpeed = 50;
  Vector2 velocity = Vector2.zero();
  List<CollisionArea> collisionAreas = [];
  HitboxArea hitbox = HitboxArea(
    position: Vector2(10, 3),
    size: Vector2(14, 18),
  );

  @override
  FutureOr<void> onLoad() {
    _onLoadAllAnimations();
    debugMode = true;
    add(RectangleHitbox(
      position: hitbox.position,
      size: hitbox.size,
      isSolid: true,
    ));
    return super.onLoad();
  }

  @override
  void update(double dt) {
    _updatePlayerState();
    _updatePlayerMovement(dt);
    _checkCollisions();
    super.update(dt);
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    horizontalMoviment = 0.0;
    verticalMoviment = 0.0;

    final isLeftKeyPressed = keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    final isRightKeyPressed =
        keysPressed.contains(LogicalKeyboardKey.arrowRight);
    final isUpKeyPressed = keysPressed.contains(LogicalKeyboardKey.arrowUp);
    final isDownKeyPressed = keysPressed.contains(LogicalKeyboardKey.arrowDown);

    horizontalMoviment += isLeftKeyPressed ? -1 : 0;
    horizontalMoviment += isRightKeyPressed ? 1 : 0;
    verticalMoviment += isUpKeyPressed ? -1 : 0;
    verticalMoviment += isDownKeyPressed ? 1 : 0;

    if (keysPressed.contains(LogicalKeyboardKey.shiftLeft) ||
        keysPressed.contains(LogicalKeyboardKey.shiftRight)) {
      moveSpeed = 200;
    } else {
      moveSpeed = 100;
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
    double stepTime = 0.07;
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

  void _updatePlayerState() {
    PlayerState playerState = PlayerState.idle;

    if (velocity.x < 0 && scale.x > 0) {
      flipHorizontallyAroundCenter();
    } else if (velocity.x > 0 && scale.x < 0) {
      flipHorizontallyAroundCenter();
    }

    if (velocity.x != 0 || velocity.y != 0) {
      playerState = PlayerState.running;
    }

    current = playerState;
  }

  void _updatePlayerMovement(double dt) {
    velocity.x = horizontalMoviment * moveSpeed;
    velocity.y = verticalMoviment * moveSpeed;
    position.x += velocity.x * dt;
    position.y += velocity.y * dt;
  }

  void _checkCollisions() {
    bool hasCollision;

    do {
      hasCollision = false;

      for (final collision in collisionAreas) {
        if (checkCollision(this, collision)) {
          final intersection = toRect().intersect(collision.toRect());
          final intersectionArea = intersection.width * intersection.height;

          if (intersectionArea > 0) {
            hasCollision = true;

            // Verifica se a colisão é horizontal ou vertical
            if (intersection.width > intersection.height) {
              // Colisão vertical (cima/baixo)
              if (velocity.y > 0) {
                // Movendo-se para baixo, reposiciona para cima
                position.y -= intersection.height;
              } else if (velocity.y < 0) {
                // Movendo-se para cima, reposiciona para baixo
                position.y += intersection.height;
              }
            } else {
              // Colisão horizontal (esquerda/direita)
              if (velocity.x > 0) {
                // Movendo-se para a direita, reposiciona para a esquerda
                position.x -= intersection.width;
              } else if (velocity.x < 0) {
                // Movendo-se para a esquerda, reposiciona para a direita
                position.x += intersection.width;
              }
            }

            // Sai do loop para recalcular as colisões após o ajuste da posição
            break;
          }
        }
      }
    } while (hasCollision); // Continua até não haver mais colisões
  }
}
