import 'package:flame/components.dart';

mixin GameSize on Component {
  late Vector2 gameSize;

  void onResize(Vector2 newGameSize) {
    gameSize = newGameSize;
  }
}
