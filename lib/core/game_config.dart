// ignore_for_file: constant_identifier_names

import 'dart:io';

class GameConfig {
  static String character = CharacterType.gabe.name;
  static String map = MapType.region1_stage1.name;

  setCharacter(CharacterType newCharacter) {
    character = newCharacter.toString();
  }

  setMap(MapType newMap) {
    map = newMap.name;
  }

  static bool get showJoyStick => Platform.isAndroid || Platform.isIOS;
}

enum CharacterType { gabe, mani }

enum MapType {
  region1_stage1,
}
