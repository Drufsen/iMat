import 'package:flutter/material.dart';
import 'package:imat_app/widgets/text_size_slider.dart';

class HelpWindow extends StatelessWidget {
  const HelpWindow({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      height: 420, // ✅ Constrain the height
      child: Column(
        children: [
          // Header
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

          // Main message area
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              color: Colors.grey[100],
              child: const Center(
                child: Text(
                  'Skriv ett meddelande nedan eller ring oss på 072-730 99 50.',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),

          // Input + send button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                  icon: const Icon(Icons.send, color: Color(0xFF00A9D3)),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
