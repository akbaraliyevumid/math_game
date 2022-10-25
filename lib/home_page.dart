import 'package:flutter/material.dart';
import 'package:math_game/consts.dart';
import 'package:math_game/add_game_page.dart';
import 'package:math_game/set_var_time.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 50,
              color: Colors.green.withOpacity(0.5),
              child: const SetVarTime(),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GamePage()),
                );
              },
              child: const Text("+"),
            ),
          ],
        ),
      ),
    );
  }
}
