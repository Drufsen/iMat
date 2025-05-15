import 'package:flutter/material.dart';

class HelpWindow extends StatelessWidget {
  const HelpWindow({Key? key}) : super(key: key);

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
                'Help',
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
                'Help messages will appear here',
                style: TextStyle(color: Colors.grey),
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
                    hintText: 'Type a message...',
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
                icon: const Icon(Icons.send, color: Colors.blue),
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