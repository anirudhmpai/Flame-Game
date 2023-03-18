import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/sprite.dart';
import 'package:flame_game/game/bullet.dart';
import 'package:flame_game/game/enemy_manager.dart';
import 'package:flame_game/game/player.dart';
import 'package:flutter/material.dart';

import 'enemy.dart';

class SpaceGlider extends FlameGame
    with PanDetector, TapDetector, HasCollisionDetection, HasDraggables {
  late final JoystickComponent joystick;
  Offset? _pointerStartPosition;
  Offset? _pointerCurrentPosition;
  late Player player;
  late Enemy enemy;
  double _joystickRadius = 60;
  double _deadzoneRadius = 10;
  late SpriteSheet _spriteSheet;
  late EnemyManager _enemyManager;
  @override
  Future<void>? onLoad() async {
    await images.load('simpleSpace_tilesheet@2.png');
    _spriteSheet = SpriteSheet.fromColumnsAndRows(
      image: images.fromCache('simpleSpace_tilesheet@2.png'),
      columns: 8,
      rows: 6,
    );
    joystick = JoystickComponent(
      knob: CircleComponent(radius: 20, paint: Paint()..color = Colors.white),
      background:
          CircleComponent(radius: 60, paint: Paint()..color = Colors.grey),
      margin: const EdgeInsets.only(left: 40, bottom: 40),
    );
    player = Player(
        _spriteSheet.getSpriteById(18), Vector2(64, 64), canvasSize / 2,
        joystick: joystick);
    player.anchor = Anchor.center;
    player.onResize(canvasSize);
    add(player);
    _enemyManager = EnemyManager(spriteSheet: _spriteSheet);
    _enemyManager.onResize(canvasSize);
    add(_enemyManager);
    add(joystick);

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    final bullets = children.whereType<Bullet>();
    for (final enemy in _enemyManager.children.whereType<Enemy>()) {
      for (final bullet in bullets) {
        if (enemy.containsPoint(bullet.absoluteCenter)) {
          enemy.removeFromParent();
          bullet.removeFromParent();
          break;
        }
      }
      if (enemy.containsPoint(player.absoluteCenter)) {
        enemy.removeFromParent();
        player.removeFromParent();
        break;
      }
    }
  }

  @override
  void render(Canvas canvas) {
    if (_pointerStartPosition != null) {
      canvas.drawCircle(_pointerStartPosition!, _joystickRadius,
          Paint()..color = Colors.grey.withAlpha(100));
    }
    if (_pointerCurrentPosition != null) {
      var delta = _pointerCurrentPosition! - _pointerStartPosition!;
      if (delta.distance > _deadzoneRadius) {
        delta = _pointerStartPosition! +
            (Vector2(delta.dx, delta.dy).normalized() * _joystickRadius)
                .toOffset();
      } else {
        delta = _pointerCurrentPosition!;
      }
      canvas.drawCircle(
          delta, 20, Paint()..color = Colors.white.withAlpha(100));
    }
    super.render(canvas);
  }

  @override
  void onTapDown(TapDownInfo info) {
    super.onTapDown(info);
    Bullet bullet = Bullet(_spriteSheet.getSpriteById(28), Vector2(64, 64),
        this.player.position.clone());
    bullet.anchor = Anchor.center;
    add(bullet);
  }

  @override
  void handlePanDown(DragDownDetails details) {
    debugPrint('pan down');
  }

  @override
  void handlePanEnd(DragEndDetails details) {
    // debugPrint('pan end');
    _pointerStartPosition = null;
    _pointerCurrentPosition = null;
    player.setMoveDirection(Vector2.zero());
  }

  @override
  void handlePanStart(DragStartDetails details) {
    // debugPrint('pan start');
    _pointerStartPosition = details.globalPosition;
    _pointerCurrentPosition = details.globalPosition;
  }

  @override
  void handlePanUpdate(DragUpdateDetails details) {
    // debugPrint('pan update');
    _pointerCurrentPosition = details.globalPosition;
    var delta = _pointerCurrentPosition! - _pointerStartPosition!;
    if (delta.distance > _joystickRadius) {
      player.setMoveDirection(Vector2(delta.dx, delta.dy));
    } else {
      player.setMoveDirection(Vector2.zero());
    }
  }

  @override
  void onPanCancel() {
    // debugPrint('pan canceled');
    _pointerStartPosition = null;
    _pointerCurrentPosition = null;
    player.setMoveDirection(Vector2.zero());
  }

  @override
  void onPanDown(DragDownInfo info) {
    debugPrint('pan downed');
  }

  @override
  void onPanEnd(DragEndInfo info) {
    debugPrint('pan ended');
  }

  @override
  void onPanStart(DragStartInfo info) {
    debugPrint('pan started');
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    debugPrint('pan updated');
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    this.children.forEach((element) {
      element.onGameResize(this.size);
    });
  }
}
