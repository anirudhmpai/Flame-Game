import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame_game/game/game_size.dart';
import 'package:flutter/foundation.dart';

import 'bullet.dart';
import 'player.dart';

class Enemy extends SpriteComponent with GameSize, CollisionCallbacks {
  double _speed = 250;
  Enemy(Sprite? sprite, Vector2? size, Vector2? position)
      : super(sprite: sprite, size: size, position: position);
  @override
  void update(double dt) {
    super.update(dt);
    this.position += Vector2(0, 1) * _speed * dt;
    if (this.position.y > gameSize.y) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas shape) {
    super.render(shape);
    renderDebugMode(shape);
  }

  @override
  void onMount() {
    super.onMount();
    final hitboxShape = CircleHitbox.relative(0.4, parentSize: this.size);
    add(hitboxShape);
  }

  @mustCallSuper
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    onCollisionCallback?.call(intersectionPoints, other);
    if (other is Bullet || other is Player) {
      this.removeFromParent();
    }
  }
}
