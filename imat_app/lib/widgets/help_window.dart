import 'package:flutter/material.dart';

class HelpWindow extends StatelessWidget {
  const HelpWindow({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Help header
        Container(
          color: Colors.blue,
          padding: const EdgeInsets.all(12),
          child: const Row(
            children: [
              Icon(Icons.chat, color: Colors.white),
              SizedBox(width: 8),
              Text(
                'Hjälp',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        // Help messages area
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            color: Colors.grey[100],
            child: const Center(
              child: Text(
                'Skriv ett meddelande nedan eller ring oss på 072-730 99 50.',
                style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),

        // Message input
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Skriv ett meddelande...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send, color: Color.fromARGB(255, 0, 169, 211)),
                onPressed: () {
                  // Send message logic will go here
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
