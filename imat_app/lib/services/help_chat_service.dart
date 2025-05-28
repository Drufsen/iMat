import 'package:imat_app/widgets/help_window.dart';

// Simple service to maintain chat state throughout the app
class HelpChatService {
  // Singleton instance
  static final HelpChatService _instance = HelpChatService._internal();
  factory HelpChatService() => _instance;
  HelpChatService._internal();

  // Chat state
  final List<ChatMessage> messages = [];
  bool hasResponded = false;

  void addMessage(ChatMessage message) {
    messages.add(message);
  }

  void reset() {
    messages.clear();
    hasResponded = false;
  }
}
