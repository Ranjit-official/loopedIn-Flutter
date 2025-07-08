import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:loopedin/common/models/conversation_model.dart';
import 'package:loopedin/features/auth/resources/api_service.dart';

class ChatWidget extends StatefulWidget {
  final ConversationModel? conversation;
  final String? currentUserId;

  const ChatWidget({super.key, this.conversation, this.currentUserId});

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  final _chatController = InMemoryChatController();
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  void _loadMessages() {
    if (widget.conversation?.messages != null) {
      // Convert our MessageModel to flutter_chat_core TextMessage
      final messages = widget.conversation!.messages!.map((message) {
        return TextMessage(
          id: message.id,
          authorId: message.senderId,
          createdAt: message.createdAt,
          text: message.content,
        );
      }).toList();

      // Add messages to chat controller
      for (final message in messages) {
        _chatController.insertMessage(message);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.conversation == null) {
      return const Center(
        child: Text(
          'No conversation loaded',
          style: TextStyle(color: Color(0xFF6B7280)),
        ),
      );
    }

    return Chat(
      chatController: _chatController,
      currentUserId: widget.currentUserId ?? 'unknown',

      onMessageSend: (text) async {
        if (widget.conversation == null || widget.currentUserId == null) {
          return;
        }

        // Create a temporary message for immediate UI feedback
        final tempMessage = TextMessage(
          id: 'temp_${Random().nextInt(1000) + 1}',
          authorId: widget.currentUserId!,
          createdAt: DateTime.now(),
          text: text,
        );

        // Add message to chat immediately
        _chatController.insertMessage(tempMessage);

        try {
          // Send message to API
          final sentMessage = await _apiService.sendMessage(
            conversationId: widget.conversation!.id,
            content: text,
          );

          // Replace temporary message with real message from API
          _chatController.removeMessage(tempMessage);
          _chatController.insertMessage(
            TextMessage(
              id: sentMessage.id,
              authorId: sentMessage.senderId,
              createdAt: sentMessage.createdAt,
              text: sentMessage.content,
            ),
          );
        } catch (e) {
          // Remove temporary message on error
          _chatController.removeMessage(tempMessage);

          // Show error message
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to send message: ${e.toString()}'),
                backgroundColor: const Color(0xFFEF4444),
                duration: const Duration(seconds: 3),
              ),
            );
          }
        }
      },
      resolveUser: (UserID id) async {
        // Try to get user info from conversation
        if (widget.conversation != null) {
          if (id == widget.conversation!.participant1Id) {
            return User(
              id: id,
              name: widget.conversation!.participant1Name ?? 'User 1',
            );
          } else if (id == widget.conversation!.participant2Id) {
            return User(
              id: id,
              name: widget.conversation!.participant2Name ?? 'User 2',
            );
          }
        }
        return User(id: id, name: 'Unknown User');
      },
    );
  }
}
