import 'message_model.dart';

class ConversationModel {
  final String id;
  final String participant1Id;
  final String participant2Id;
  final String? participant1Name;
  final String? participant2Name;
  final String? participant1Title;
  final String? participant2Title;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String status; // 'active', 'ended', etc.
  final DateTime? lastMessageAt;
  final String? lastMessageContent;
  final List<MessageModel>? messages; // Messages in the conversation

  ConversationModel({
    required this.id,
    required this.participant1Id,
    required this.participant2Id,
    this.participant1Name,
    this.participant2Name,
    this.participant1Title,
    this.participant2Title,
    required this.createdAt,
    this.updatedAt,
    required this.status,
    this.lastMessageAt,
    this.lastMessageContent,
    this.messages,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    List<MessageModel>? messages;
    if (json['messages'] != null) {
      messages = (json['messages'] as List)
          .map((messageJson) => MessageModel.fromJson(messageJson))
          .toList();
    }

    // Handle date parsing with null safety
    DateTime parseDate(dynamic dateValue) {
      if (dateValue == null) {
        return DateTime.now(); // Fallback to current time
      }
      if (dateValue is String) {
        try {
          return DateTime.parse(dateValue);
        } catch (e) {
          return DateTime.now(); // Fallback to current time
        }
      }
      return DateTime.now(); // Fallback to current time
    }

    return ConversationModel(
      id: json['id']?.toString() ?? '',
      participant1Id: json['participant1_id']?.toString() ?? '',
      participant2Id: json['participant2_id']?.toString() ?? '',
      participant1Name: json['participant1_name']?.toString(),
      participant2Name: json['participant2_name']?.toString(),
      participant1Title: json['participant1_title']?.toString(),
      participant2Title: json['participant2_title']?.toString(),
      createdAt: parseDate(json['created_at']),
      updatedAt: json['updated_at'] != null ? parseDate(json['updated_at']) : null,
      status: json['status']?.toString() ?? 'active',
      lastMessageAt: json['last_message_at'] != null ? parseDate(json['last_message_at']) : null,
      lastMessageContent: json['last_message_content']?.toString(),
      messages: messages,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'participant1_id': participant1Id,
      'participant2_id': participant2Id,
      'participant1_name': participant1Name,
      'participant2_name': participant2Name,
      'participant1_title': participant1Title,
      'participant2_title': participant2Title,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'status': status,
      'last_message_at': lastMessageAt?.toIso8601String(),
      'last_message_content': lastMessageContent,
      'messages': messages?.map((message) => message.toJson()).toList(),
    };
  }

  // Helper method to get the other participant's info
  Map<String, String?> getOtherParticipantInfo(String currentUserId) {
    if (participant1Id == currentUserId) {
      return {'name': participant2Name, 'title': participant2Title};
    } else {
      return {'name': participant1Name, 'title': participant1Title};
    }
  }

  // Helper method to format last active time
  String getLastActiveText() {
    if (lastMessageAt == null) {
      return 'No messages';
    }

    final now = DateTime.now();
    final difference = now.difference(lastMessageAt!);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
