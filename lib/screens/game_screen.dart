import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:provider/provider.dart';
import 'package:tdshka/game/my_game.dart';
import 'package:tdshka/models/game_state.dart';
//import 'package:tower_defense/game/my_game.dart';

class GameScreen extends StatelessWidget {
  GameScreen({super.key});

  final MyGame _game = MyGame();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tower Defense')),
      body: GameWidget(
        game: _game,
        overlayBuilderMap: {'hud': (context, game) => const HudOverlay()},
        initialActiveOverlays: const ['hud'],
      ),
    );
  }
}

class HudOverlay extends StatelessWidget {
  const HudOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context);
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Здоровье: ${gameState.health}',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            Text(
              'Деньги: ${gameState.money}',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
