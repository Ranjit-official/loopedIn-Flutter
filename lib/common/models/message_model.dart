class MessageModel {
  final String id;
  final String conversationId;
  final String senderId;
  final String? senderName;
  final String content;
  final String messageType; // 'text', 'image', 'file', etc.
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String status; // 'sent', 'delivered', 'read', etc.
  final Map<String, dynamic>? metadata; // Additional message data

  MessageModel({
    required this.id,
    required this.conversationId,
    required this.senderId,
    this.senderName,
    required this.content,
    required this.messageType,
    required this.createdAt,
    this.updatedAt,
    required this.status,
    this.metadata,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
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

    return MessageModel(
      id: json['id']?.toString() ?? '',
      conversationId: json['conversation_id']?.toString() ?? '',
      senderId: json['sender_id']?.toString() ?? '',
      senderName: json['sender_name']?.toString(),
      content: json['content']?.toString() ?? '',
      messageType: json['message_type']?.toString() ?? 'text',
      createdAt: parseDate(json['created_at']),
      updatedAt: json['updated_at'] != null
          ? parseDate(json['updated_at'])
          : null,
      status: json['status']?.toString() ?? 'sent',
      metadata: json['metadata'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'conversation_id': conversationId,
      'sender_id': senderId,
      'sender_name': senderName,
      'content': content,
      'message_type': messageType,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'status': status,
      'metadata': metadata,
    };
  }

  // Helper method to format message time
  String getFormattedTime() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(
      createdAt.year,
      createdAt.month,
      createdAt.day,
    );

    if (messageDate == today) {
      // Today - show time only
      return '${createdAt.hour.toString().padLeft(2, '0')}:${createdAt.minute.toString().padLeft(2, '0')}';
    } else if (messageDate == today.subtract(const Duration(days: 1))) {
      // Yesterday
      return 'Yesterday';
    } else {
      // Other days - show date
      return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
    }
  }

  // Helper method to check if message is from current user
  bool isFromCurrentUser(String currentUserId) {
    return senderId == currentUserId;
  }
}
