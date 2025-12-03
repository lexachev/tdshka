import 'dart:async';

import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/image_composition.dart';
import 'package:tdshka/game/entities/enemy/enemy.dart';
import 'package:tdshka/game/entities/tower/tower.dart';
import 'package:tdshka/game/world/tile_map.dart';

class MyGame extends FlameGame {
  List<Vector2> routePoints = []; // Точки маршрута
  Timer? spawnTimer; // Таймер для спавна врагов

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
    towerBaseImage = await images.load('tileset/td/Objects/PlaceForTower1.png');
    _imagesLoaded = true;
    _calculateTileGrid(); // Рассчитываем сетку под экран
    _createMap(); // Создаём игровое поле
    _createRoute(); // Создаём маршрут
    _startSpawning(); // Запускаем спавн врагов
  }

  // Создаём маршрут по центру дороги

  void _createRoute() {
    final roadY = rows ~/ 2;
    routePoints.clear();
    print(
      'Generating route: columns=$columns, tileSize=$tileSize, roadY=$roadY',
    );

    for (int x = -1; x <= columns + 1; x++) {
      final point = Vector2(
        x * tileSize.toDouble() + tileSize / 2,
        roadY * tileSize.toDouble() + tileSize / 2,
      );
      routePoints.add(point);
      print('Point $x: ${point}');
    }

    print('Total route points: ${routePoints.length}');
  }

  void _startSpawning() {
    spawnTimer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (routePoints.length >= 2) {
        // Минимум 2 точки
        final startPosition = routePoints[0] - Vector2(tileSize.toDouble(), 0);
        final enemy = Enemy(
          position: startPosition,
          speed: 20,
          routePoints: routePoints,
        );
        add(enemy);
      }
    });
  }

  @override
  // ignore: override_on_non_overriding_member
  void onTapDown(TapDownInfo info) {
    final tapPosition = info.eventPosition.global;

    // Проверяем, кликнули ли на зону для башни
    for (final component in children) {
      if (component is Tile &&
          component.type == TileType.towerBase &&
          component.containsPoint(tapPosition)) {
        // Размещаем башню в центре тайла
        final tower = Tower(position: component.position + component.size / 2);
        add(tower);
        break;
      }
    }
  }

  /// Определяет количество тайлов и их размер исходя из размера экрана
  void _calculateTileGrid() {
    final screenWidth = size.x * 1; // 95% ширины (отступы по краям)
    final screenHeight = size.y * 1; // 95% высоты

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
