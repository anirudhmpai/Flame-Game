import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame_game/game/game.dart';
import 'package:flutter/widgets.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen();
  runApp(GameWidget(game: SpaceGlider()));
}
