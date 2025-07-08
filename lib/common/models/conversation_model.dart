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
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json['id'] ?? '',
      participant1Id: json['participant1_id'] ?? '',
      participant2Id: json['participant2_id'] ?? '',
      participant1Name: json['participant1_name'],
      participant2Name: json['participant2_name'],
      participant1Title: json['participant1_title'],
      participant2Title: json['participant2_title'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      status: json['status'] ?? 'active',
      lastMessageAt: json['last_message_at'] != null
          ? DateTime.parse(json['last_message_at'])
          : null,
      lastMessageContent: json['last_message_content'],
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
