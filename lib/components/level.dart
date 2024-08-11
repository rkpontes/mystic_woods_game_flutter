import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:mystic_woods/components/collision_area.dart';
import 'package:mystic_woods/components/player.dart';

class Level extends World {
  Level({required this.levelName, required this.player});

  final String levelName;
  final Player player;
  late TiledComponent level;
  List<CollisionArea> collisionAreas = [];

  static const String spawnpointsLayerName = 'Spawnpoints';
  static const String collisionsLayerName = 'Collisions';
  static const String playerClass = 'Player';

  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load('$levelName.tmx', Vector2.all(16));
    add(level);

    _loadSpawnPoints();
    _loadCollisionAreas();

    player.collisionAreas = collisionAreas;

    return super.onLoad();
  }

  void _loadSpawnPoints() {
    final ObjectGroup? spawnPointsLayer =
        level.tileMap.getLayer<ObjectGroup>(spawnpointsLayerName);

    if (spawnPointsLayer != null) {
      for (final spawnpoint in spawnPointsLayer.objects) {
        if (spawnpoint.class_ == playerClass) {
          player.position = Vector2(spawnpoint.x, spawnpoint.y);
          add(player);
        }
      }
    }
  }

  void _loadCollisionAreas() {
    final ObjectGroup? collisionsLayer =
        level.tileMap.getLayer<ObjectGroup>(collisionsLayerName);

    if (collisionsLayer != null) {
      for (final collision in collisionsLayer.objects) {
        final collisionArea = CollisionArea(
          position: Vector2(collision.x, collision.y),
          size: Vector2(collision.width, collision.height),
        );
        collisionAreas.add(collisionArea);
        add(collisionArea);
      }
    }
  }
}
