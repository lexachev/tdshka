import 'package:flame/components.dart';

class Enemy extends PositionComponent {
  final double speed;
  late Vector2 target;
  late SpriteComponent spriteComponent; // Контейнер для спрайта

  Enemy({required Vector2 position, this.speed = 50})
    : super(position: position, size: Vector2(40, 40)) {
    // Размер компонента задаёт область коллизии и размещения
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Загружаем спрайт врага
    final sprite = await Sprite.load('/enemy.png');

    // Создаём компонент для отображения спрайта
    spriteComponent = SpriteComponent(
      sprite: sprite,
      size: size, // Размер спрайта = размеру компонента
      position: Vector2.zero(), // Позиция внутри компонента (0,0)
    );

    // Добавляем спрайт в компонент
    add(spriteComponent);
  }

  @override
  void update(double dt) {
    super.update(dt);
    final game = findGame()!;
    final gameHeight = game.size.y;

    if (position.y > gameHeight + 100) {
      removeFromParent();
      return;
    }

    // Проверяем, достиг ли враг цели
    if (position.distanceTo(target) < 1) {
      return; // Ждём следующую точку маршрута
    }

    // Двигаемся к цели
    final direction = target - position;
    direction.normalize();
    position += direction * speed * dt;
  }

  // Метод для установки новой цели (используется при движении по маршруту)
  void setTarget(Vector2 newTarget) {
    target = newTarget;
  }
}
