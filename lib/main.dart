import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tdshka/screens/game_screen.dart';
import 'package:tdshka/models/game_state.dart';

void main() {
  runApp(
    ChangeNotifierProvider(create: (_) => GameState(), child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tower Defense',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: GameScreen(),
    );
  }
}
