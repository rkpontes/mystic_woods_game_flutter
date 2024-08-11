import 'package:mystic_woods/components/collision_area.dart';
import 'package:mystic_woods/components/player.dart';

bool checkCollision(Player player, CollisionArea collisionArea) {
  final playerRect = player.toRect();
  final collisionRect = collisionArea.toRect();
  return playerRect.overlaps(collisionRect);
}
