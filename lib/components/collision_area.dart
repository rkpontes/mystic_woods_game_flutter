// ignore_for_file: use_super_parameters

import 'package:flame/components.dart';

class CollisionArea extends PositionComponent {
  CollisionArea({
    position,
    size,
  }) : super(position: position, size: size) {
    debugMode = true;
  }
}
