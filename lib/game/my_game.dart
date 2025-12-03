import 'package:flame/game.dart';
import 'package:flame/image_composition.dart';
import 'package:tdshka/game/world/tile_map.dart';

class MyGame extends FlameGame {
  late int columns; // Количество столбцов тайлов
  late int rows; // Количество строк тайлов
  late int tileSize; // Размер одного тайла в пикселях

  late Image? grassImage;
  late Image? pathImage1;
  late Image? pathImage2;
  late Image? towerBaseImage;
  bool _imagesLoaded = false;
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    grassImage = await images.load('tileset/td/Tiles/FieldsTile_38.png');
    pathImage1 = await images.load('tileset/td/Tiles/FieldsTile_05.png');
    pathImage2 = await images.load('tileset/td/Tiles/FieldsTile_07.png');
    towerBaseImage = await images.load('tileset/td/Tiles/FieldsTile_01.png');
    _imagesLoaded = true;
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
    if (!_imagesLoaded) {
      print('Изображения ещё не загружены!');
      return;
    }
    final roadY = rows ~/ 2; // Центр по вертикали

    for (int x = 0; x < columns; x++) {
      for (int y = 0; y < rows; y++) {
        TileType type = TileType.grass;
        Image? tileImage = grassImage; // По умолчанию — трава

        // Дорога шириной 2 тайла (y == roadY и y == roadY + 1)
        if (y == roadY || y == roadY + 1) {
          type = TileType.path;
          // Чередуем изображения для разнообразия
          tileImage = (x % 2 == 0) ? pathImage1 : pathImage2;
        }
        // Зоны для башен: выше и ниже дороги (с отступами)
        else if (y == roadY - 2 || y == roadY + 3) {
          if (x > 1 && x < columns - 2 && x % 3 == 0) {
            type = TileType.towerBase;
            tileImage = towerBaseImage;
          }
        }

        final tile = Tile(
          type: type,
          position: Vector2(x * tileSize.toDouble(), y * tileSize.toDouble()),
          size: Vector2(tileSize.toDouble(), tileSize.toDouble()),
          image: tileImage,
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
