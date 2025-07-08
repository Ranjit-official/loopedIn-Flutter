import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:loopedin/features/chat/ui/widgets/chat_widget.dart';
import 'package:loopedin/features/auth/resources/api_service.dart';
import 'package:loopedin/features/auth/resources/user_service.dart';
import 'package:loopedin/common/models/conversation_model.dart';
import 'package:loopedin/common/models/message_model.dart';

class ChatPage extends StatefulWidget {
  final String conversationId;

  const ChatPage({super.key, required this.conversationId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ApiService _apiService = ApiService();
  final UserService _userService = UserService();

  ConversationModel? _conversation;
  bool _isLoading = true;
  String? _error;
  String? _currentUserId;
  String? _otherParticipantName;
  String? _otherParticipantTitle;

  @override
  void initState() {
    super.initState();
    _loadConversation();
  }

  Future<void> _loadConversation() async {
    try {
      if (kDebugMode) {
        print('Loading conversation with ID: ${widget.conversationId}');
      }

      // Validate conversation ID
      if (widget.conversationId.isEmpty) {
        throw Exception('Conversation ID is empty');
      }

      // Get current user ID and auth token first
      final currentUser = await _userService.getCurrentUser();
      final authToken = await _userService.getAuthToken();

      setState(() {
        _currentUserId = currentUser?.id;
      });

      // Set auth token for API calls
      if (authToken != null) {
        _apiService.setAuthToken(authToken);
      }

      // Load conversation details
      ConversationModel conversation;
      try {
        conversation = await _apiService.getConversationById(
          widget.conversationId,
        );
      } catch (apiError) {
        if (kDebugMode) {
          print('API error, creating mock conversation: $apiError');
        }
        // Create a mock conversation for testing
        conversation = ConversationModel(
          id: widget.conversationId,
          participant1Id: _currentUserId ?? 'user1',
          participant2Id: 'user2',
          participant1Name: 'Current User',
          participant2Name: 'Other User',
          participant1Title: 'Professional',
          participant2Title: 'Developer',
          createdAt: DateTime.now(),
          status: 'active',
          messages: [
            MessageModel(
              id: '1',
              conversationId: widget.conversationId,
              senderId: 'user2',
              senderName: 'Other User',
              content: 'Hello! How are you doing?',
              messageType: 'text',
              createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
              status: 'read',
            ),
            MessageModel(
              id: '2',
              conversationId: widget.conversationId,
              senderId: _currentUserId ?? 'user1',
              senderName: 'Current User',
              content: 'Hi! I\'m doing great, thanks for asking.',
              messageType: 'text',
              createdAt: DateTime.now().subtract(const Duration(minutes: 3)),
              status: 'sent',
            ),
          ],
        );
      }

      // Get other participant info
      final otherParticipant = conversation.getOtherParticipantInfo(
        _currentUserId ?? '',
      );

      setState(() {
        _conversation = conversation;
        _otherParticipantName = otherParticipant['name'] ?? 'Unknown User';
        _otherParticipantTitle = otherParticipant['title'] ?? 'Professional';
        _isLoading = false;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error loading conversation: $e');
        print('Error type: ${e.runtimeType}');
        if (e is Exception) {
          print('Exception details: ${e.toString()}');
        }
      }
      setState(() {
        _error = 'Failed to load conversation: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_ios),
          ),
          title: const Text('Loading...'),
        ),
        body: const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2563EB)),
          ),
        ),
      );
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_ios),
          ),
          title: const Text('Error'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 48,
                color: Color(0xFF6B7280),
              ),
              const SizedBox(height: 16),
              const Text(
                'Error loading conversation',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF222222),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _error!,
                style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadConversation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        titleSpacing: 0,
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFE5E7EB), width: 2),
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/user/userLogo.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _otherParticipantName ?? 'Unknown User',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF222222),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (_otherParticipantTitle != null)
                    Text(
                      _otherParticipantTitle!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Divider(height: 1.0, thickness: 1.0, color: Colors.grey[300]),
        ),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: ChatWidget(
        conversation: _conversation,
        currentUserId: _currentUserId,
      ),
    );
  }
}
