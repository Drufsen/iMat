import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/widgets/scalable_text.dart';

class HelpWindow extends StatefulWidget {
  const HelpWindow({super.key});

  @override
  State<HelpWindow> createState() => _HelpWindowState();
}

class _HelpWindowState extends State<HelpWindow> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _hasResponded = false; // Track if the bot has already sent a response
  
  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
  
  void _handleSend() {
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        // Add user message
        _messages.add(ChatMessage(
          text: _messageController.text.trim(),
          isUser: true,
        ));
        
        _messageController.clear();
        
        // Mock response only if we haven't responded yet
        if (!_hasResponded) {
          _hasResponded = true; // Mark that we've responded
          
          // Mock response after a slight delay
          Future.delayed(const Duration(seconds: 1), () {
            if (mounted) {
              setState(() {
                _messages.add(const ChatMessage(
                  text: "Tack för ditt meddelande! Vi återkommer till dig så snart som möjligt.",
                  isUser: false,
                ));
              });
            }
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        Container(
          color: AppTheme.colorScheme.primary,
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(Icons.chat, color: AppTheme.colorScheme.onPrimary),
              const SizedBox(width: 8),
              ScalableText(
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
            child: _messages.isEmpty
                ? const Center(
                    child: ScalableText(
                      'Skriv ett meddelande nedan eller ring oss på 072-730 99 50.',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.builder(
                    itemCount: _messages.length,
                    itemBuilder: (context, index) => _messages[index],
                  ),
          ),
        ),

        // Input + send button
        Padding(
          padding: const EdgeInsets.only(
            bottom: 16.0,
            left: 8.0,
            right: 8.0,
            top: 12.0,
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
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
                  onSubmitted: (_) => _handleSend(),
                ),
              ),
              IconButton(
                icon: Icon(Icons.send, color: AppTheme.colorScheme.primary),
                onPressed: _handleSend,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isUser;
  
  const ChatMessage({
    super.key,
    required this.text,
    required this.isUser,
  });
  
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: isUser ? AppTheme.colorScheme.primary : Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 2.0,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        child: ScalableText(
          text,
          style: TextStyle(
            color: isUser ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }
}
