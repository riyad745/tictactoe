import 'package:flutter/material.dart';
import 'package:tictactoe/features/computer/presentation/easy_computer.dart';
import 'package:tictactoe/features/computer/presentation/hard_computer.dart';

class GameSettingsDialog {
  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(child: Text('Choose Level')),
          content: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ComputerEasyGameScreen()),
                  );
                },
                child: const Text('Easy'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ComputerHardGameScreen()),
                  );
                },
                child: const Text('Hard'),
              ),
            ],
          ),
        );
      },
    );
  }
}
