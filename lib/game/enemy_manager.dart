import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flame_game/game/enemy.dart';
import 'package:flame_game/game/game_size.dart';

class EnemyManager extends Component with GameSize, HasGameRef {
  late Timer _timer;
  SpriteSheet spriteSheet;
  EnemyManager({required this.spriteSheet}) : super() {
    _timer = Timer(1, onTick: _spawnEnemy, repeat: true);
  }

  void _spawnEnemy() {
    Vector2 initialSize = Vector2(64, 64);
    Vector2 position = Vector2(Random().nextDouble() * gameSize.x, 0);
    position.clamp(Vector2.zero(), gameSize);
    Enemy enemy = Enemy(spriteSheet.getSpriteById(32), initialSize, position);
    enemy.onResize(gameSize);
    gameRef.add(enemy);
  }

  @override
  void onMount() {
    super.onMount();
    _timer.start();
  }

  @override
  void onRemove() {
    super.onRemove();
    _timer.stop();
  }

  @override
  void update(double dt) {
    super.update(dt);
    _timer.update(dt);
  }
}
