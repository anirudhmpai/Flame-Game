import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame_game/game/enemy.dart';
import 'package:flutter/foundation.dart';

class Bullet extends SpriteComponent with CollisionCallbacks {
  double _speed = 450;
  Bullet(Sprite? sprite, Vector2? size, Vector2? position)
      : super(sprite: sprite, size: size, position: position);

  @override
  void update(double dt) {
    super.update(dt);
    this.position += Vector2(0, -1) * this._speed * dt;
    if (this.position.y < 0) {
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
    if (other is Enemy) {
      this.removeFromParent();
    }
  }
}
