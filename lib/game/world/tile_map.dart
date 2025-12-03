import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/painting.dart';

/// Типы тайлов игрового поля
enum TileType {
  path, // дорога (маршрут врагов)
  grass, // фон (трава)
  towerBase, // зона для установки башен
}

/// Компонент тайла карты
class Tile extends PositionComponent with CollisionCallbacks {
  TileType type;
  late Paint paint;

  Tile({required this.type, required Vector2 position, required Vector2 size})
    : super(position: position, size: size) {
    paint = Paint()..color = _getColor();
    add(RectangleHitbox()); // Хитбокс для коллизий
  }

  /// Возвращает цвет в зависимости от типа тайла
  Color _getColor() {
    switch (type) {
      case TileType.path:
        return const Color(0xFF8B4513); // Коричневый (дорога)
      case TileType.grass:
        return const Color(0xFF7CFC00); // Зелёный (трава)
      case TileType.towerBase:
        return const Color(0xFFD3D3D3); // Серый (база для башни)
    }
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(size.toRect(), paint);
    super.render(canvas);
  }

  /// Обработчик столкновений (можно расширить при необходимости)
  // @override
  // void onCollision(Set<Vector2> points, Collision other) {
  //   // Логика при столкновении (например, запрет размещения башен на дороге)
  // }
}
