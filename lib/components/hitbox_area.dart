// ignore_for_file: use_super_parameters

import 'package:flame/components.dart';

class HitboxArea extends PositionComponent {
  HitboxArea({
    position,
    size,
  }) : super(position: position, size: size) {
    debugMode = true;
  }
}
