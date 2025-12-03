import 'package:flame/components.dart';

class Enemy extends PositionComponent {
  final double speed;
  late Vector2 target;
  late List<Vector2> routePoints;
  int currentWaypointIndex = 0;
  late SpriteComponent spriteComponent;
  bool isReady = false;

  Enemy({required Vector2 position, this.speed = 50, required this.routePoints})
    : super(position: position, size: Vector2(40, 40)) {
    target = routePoints[0];
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    final sprite = await Sprite.load('enemy.png');
    spriteComponent = SpriteComponent(sprite: sprite, size: size);
    add(spriteComponent);
    isReady = true;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!isReady) return;
    // print('--- Enemy Update ---');
    // print('Pos: ${position}');
    // print('Target: ${target}');
    // print(
    //   'Distance to target: ${position.distanceTo(target).toStringAsFixed(1)}',
    // );
    // print('isReady: $isReady, currentIndex: $currentWaypointIndex');

    final game = findGame()!;
    final gameSize = game.size;

    // Удаление за пределами экрана
    if (position.x < -100 ||
        position.x > gameSize.x + 100 ||
        position.y < -100 ||
        position.y > gameSize.y + 100) {
      print('удаление');
      removeFromParent();
      return;
    }

    // Переход к следующей точке
    if (currentWaypointIndex < routePoints.length - 1) {
      final nextTarget = routePoints[currentWaypointIndex + 1];
      if (position.distanceTo(nextTarget) < 15) {
        currentWaypointIndex++;
        target = nextTarget;
      }
    } else {
      // Продлеваем движение за последнюю точку
      target =
          routePoints.last +
          (routePoints.last - routePoints[routePoints.length - 2])
                  .normalized() *
              300;
    }

    // Движение
    final direction = target - position;
    if (direction.length > 0.1) {
      direction.normalize();
      position += direction * speed * dt;
    } else {
      // Если застряли — принудительно переходим к следующей точке
      if (currentWaypointIndex < routePoints.length - 1) {
        currentWaypointIndex++;
        target = routePoints[currentWaypointIndex];
      }
    }
  }
}
