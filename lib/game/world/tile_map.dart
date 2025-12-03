import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/collisions.dart';

/// Типы тайлов игрового поля
enum TileType {
  path, // дорога (маршрут врагов)
  grass, // фон (трава)
  towerBase, // зона для установки башен
}

/// Компонент тайла карты
class Tile extends PositionComponent with CollisionCallbacks {
  TileType type;
  Image? image; // Изображение тайла (может быть null для отладки)

  Tile({
    required this.type,
    required Vector2 position,
    required Vector2 size,
    this.image, // Принимаем изображение как параметр
  }) : super(position: position, size: size) {
    add(RectangleHitbox());
  }

  @override
  void render(Canvas canvas) {
    if (image != null) {
      // Рисуем изображение в границах тайла
      canvas.drawImageRect(
        image!,
        Rect.fromLTWH(0, 0, image!.width.toDouble(), image!.height.toDouble()),
        size.toRect(),
        Paint(),
      );
    } else {
      // Резервная заливка цветом (на случай отсутствия изображения)
      final paint = Paint()..color = _getColor();
      canvas.drawRect(size.toRect(), paint);
    }
    super.render(canvas);
  }

  Color _getColor() {
    switch (type) {
      case TileType.path:
        return const Color(0xFF8B4513);
      case TileType.grass:
        return const Color(0xFF7CFC00);
      case TileType.towerBase:
        return const Color(0xFFD3D3D3);
    }
  }

  // @override
  // void onCollision(Set<Vector2> points, Collision other) {}
}
