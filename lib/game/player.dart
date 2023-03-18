import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame_game/game/enemy.dart';
import 'package:flame_game/game/game_size.dart';
import 'package:flutter/foundation.dart';

class Player extends SpriteComponent with GameSize, CollisionCallbacks {
  Vector2 moveDirection = Vector2.zero();
  double _speed = 300;
  final JoystickComponent joystick;
  late final Vector2 _lastSize = size.clone();
  late final Transform2D _lastTransform = transform.clone();
  Player(Sprite? sprite, Vector2? size, Vector2? position,
      {required this.joystick})
      : super(sprite: sprite, size: size, position: position);

  @override
  void update(double dt) {
    super.update(dt);
    this.position += moveDirection.normalized() * _speed * dt;
    this.position.clamp(Vector2.zero(), gameSize);
    if (!joystick.delta.isZero() && activeCollisions.isEmpty) {
      _lastSize.setFrom(size);
      _lastTransform.setFrom(transform);
      position.add(joystick.relativeDelta * _speed * dt);
      angle = joystick.delta.screenAngle();
    }
  }

  void setMoveDirection(Vector2 newMoveDirection) {
    moveDirection = newMoveDirection;
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

  @override
  void onCollisionStart(Set<Vector2> _, PositionComponent __) {
    super.onCollisionStart(_, __);
    transform.setFrom(_lastTransform);
    size.setFrom(_lastSize);
  }

  @override
  void onCollisionEnd(PositionComponent __) {
    super.onCollisionEnd(__);
  }
}
