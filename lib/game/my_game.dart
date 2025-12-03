import 'package:flame/game.dart';
import 'package:tdshka/game/world/tile_map.dart';

class MyGame extends FlameGame {
  late int columns; // Количество столбцов тайлов
  late int rows; // Количество строк тайлов
  late int tileSize; // Размер одного тайла в пикселях

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _calculateTileGrid(); // Рассчитываем сетку под экран
    _createMap(); // Создаём игровое поле
  }

  /// Определяет количество тайлов и их размер исходя из размера экрана
  void _calculateTileGrid() {
    final screenWidth = size.x * 0.95; // 95% ширины (отступы по краям)
    final screenHeight = size.y * 0.95; // 95% высоты

    // Базовый размер тайла (можно менять для плотности)
    const baseTileSize = 40;

    // Рассчитываем количество тайлов
    columns = (screenWidth / baseTileSize).floor();
    rows = (screenHeight / baseTileSize).floor();

    // Корректируем размер тайла для полного заполнения экрана
    tileSize = (screenWidth / columns).toInt();
  }

  /// Создаёт игровое поле из тайлов с логикой размещения
  void _createMap() {
    // Центрируем дорогу по вертикали
    final roadY = rows ~/ 2;

    for (int x = 0; x < columns; x++) {
      for (int y = 0; y < rows; y++) {
        TileType type = TileType.grass;

        // Дорога: сплошная горизонтальная линия
        if (y == roadY) {
          type = TileType.path;
        }
        // Зоны для башен: сверху и снизу от дороги (с промежутками)
        else if (y == roadY - 1 || y == roadY + 1) {
          // Пропускаем крайние клетки для эстетики
          if (x > 1 && x < columns - 2) {
            // Чередуем башни через 2 клетки (больше пространства)
            if (x % 3 == 0) {
              type = TileType.towerBase;
            }
          }
        }

        final tile = Tile(
          type: type,
          position: Vector2(x * tileSize.toDouble(), y * tileSize.toDouble()),
          size: Vector2(tileSize.toDouble(), tileSize.toDouble()),
        );
        add(tile);
      }
    }
  }

  /// Перерасчёт при изменении размера экрана (например, поворот устройства)
  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    _calculateTileGrid();

    print('Удаление тайлов');
    children.forEach((component) {
      if (component is Tile) {
        component.removeFromParent();
        print('Удален тайл');
      }
    });

    print('Пересоздание карты');
    _createMap();
  }
}
