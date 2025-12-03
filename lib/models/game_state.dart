import 'package:flutter/foundation.dart';

class GameState extends ChangeNotifier {
  int _money = 100;
  int _health = 10;

  int get money => _money;
  int get health => _health;

  void addMoney(int amount) {
    _money += amount;
    notifyListeners();
  }

  void removeMoney(int amount) {
    if (_money >= amount) {
      _money -= amount;
      notifyListeners();
    }
  }

  void takeDamage(int damage) {
    _health -= damage;
    notifyListeners();
  }
}
