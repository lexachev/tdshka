import 'dart:ui';

import 'package:flame/components.dart';
import 'package:tdshka/game/entities/enemy/enemy.dart';

class Tower extends PositionComponent {
  final double range; // Радиус атаки
  final double fireRate; // Скорострельность (выстрелов в секунду)

  Tower({required Vector2 position, this.range = 60, this.fireRate = 1})
    : super(position: position, size: Vector2(40, 40));

  @override
  void render(Canvas canvas) {
    // Временный визуальный элемент — квадрат
    final paint = Paint()..color = const Color(0xFF3498DB);
    canvas.drawRect(size.toRect(), paint);

    // Рисуем радиус атаки (для отладки)
    final rangePaint = Paint()
      ..color = const Color(0x403498DB)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle((size / 2) as Offset, range, rangePaint);
  }

  @override
  void update(double dt) {
    // Ищем ближайшего врага в радиусе
    Enemy? nearestEnemy;
    double minDistance = range;

    for (final component in children) {
      if (component is Enemy) {
        final distance = position.distanceTo(component.position);
        if (distance < minDistance) {
          minDistance = distance;
          nearestEnemy = component;
        }
      }
    }

    // Если враг найден — «атакуем» (в данном случае просто отмечаем)
    if (nearestEnemy != null) {
      print('Tower at ${position} attacks enemy at ${nearestEnemy.position}');
      // Здесь будет логика выстрела (пули, урон и т.п.)
    }
  }
}
