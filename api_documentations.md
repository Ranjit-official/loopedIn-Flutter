# LoopIn API Documentation

This document provides a comprehensive overview of all API endpoints and realtime channels used in the LoopIn application. It explains their purpose, usage, request/response structure, authentication, and how to implement them in a Flutter application.

---

## Table of Contents

1. [Authentication APIs](#authentication-apis)
2. [User Profile & Data APIs](#user-profile--data-apis)
3. [Chat APIs](#chat-apis)
4. [Supabase Realtime APIs](#supabase-realtime-apis)
5. [Local Asset APIs](#local-asset-apis)

---

## 1. Authentication APIs

### 1.1 Sign Up

- **Purpose:** Register a new user.
- **Endpoint:** `/api/auth/signup`
- **Method:** POST
- **Authentication:** None
- **Request Body:**
  ```json
  {
    "email": "user@example.com",
    "password": "yourPassword"
  }
  ```
- **Response:**
  ```json
  {
    "user": { ... },
    "session": { ... }
  }
  ```
- **Flutter Example:**
  ```dart
  final response = await http.post(
    Uri.parse('$baseUrl/api/auth/signup'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'email': email, 'password': password}),
  );
  ```
- **Notes:** Use this to create a new account.

### 1.2 Sign In

- **Purpose:** Authenticate a user and obtain a session token.
- **Endpoint:** `/api/auth/signin`
- **Method:** POST
- **Authentication:** None
- **Request Body:**
  ```json
  {
    "email": "user@example.com",
    "password": "yourPassword"
  }
  ```
- **Response:**
  ```json
  {
    "user": { ... },
    "session": { ... }
  }
  ```
- **Flutter Example:**
  ```dart
  final response = await http.post(
    Uri.parse('$baseUrl/api/auth/signin'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'email': email, 'password': password}),
  );
  ```
- **Notes:** Store the session token for authenticated requests.

### 1.3 Sign Out

- **Purpose:** Log out the current user.
- **Endpoint:** `/api/auth/signout`
- **Method:** POST
- **Authentication:** Bearer token
- **Headers:**
  ```
  Authorization: Bearer <access_token>
  ```
- **Flutter Example:**
  ```dart
  final response = await http.post(
    Uri.parse('$baseUrl/api/auth/signout'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    },
  );
  ```

### 1.4 Validate Session

- **Purpose:** Check if a session token is valid.
- **Endpoint:** `/api/auth/validate-session`
- **Method:** GET
- **Authentication:** Bearer token
- **Flutter Example:**
  ```dart
  final response = await http.get(
    Uri.parse('$baseUrl/api/auth/validate-session'),
    headers: {'Authorization': 'Bearer $accessToken'},
  );
  ```

### 1.5 Check Onboarding Status

- **Purpose:** Check if the user has completed onboarding.
- **Endpoint:** `/api/auth/onboarding-status`
- **Method:** GET
- **Authentication:** Bearer token
- **Flutter Example:**
  ```dart
  final response = await http.get(
    Uri.parse('$baseUrl/api/auth/onboarding-status'),
    headers: {'Authorization': 'Bearer $accessToken'},
  );
  ```

### 1.6 Update Profile

- **Purpose:** Update user profile information.
- **Endpoint:** `/api/auth/update_profile`
- **Method:** POST
- **Authentication:** Bearer token
- **Request Body:**
  ```json
  {
    // profile fields
  }
  ```
- **Flutter Example:**
  ```dart
  final response = await http.post(
    Uri.parse('$baseUrl/api/auth/update_profile'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    },
    body: jsonEncode(profileData),
  );
  ```

---

## 2. User Profile & Data APIs

### 2.1 Get My Anonymized Data

- **Purpose:** Retrieve anonymized data for the current user.
- **Endpoint:** `/api/auth/my-anonymized-data`
- **Method:** GET
- **Authentication:** Bearer token
- **Flutter Example:**
  ```dart
  final response = await http.get(
    Uri.parse('$baseUrl/api/auth/my-anonymized-data'),
    headers: {'Authorization': 'Bearer $accessToken'},
  );
  ```

### 2.2 Get Users' Anonymized Data

- **Purpose:** Retrieve anonymized data for multiple users.
- **Endpoint:** `/api/auth/users-anonymized-data`
- **Method:** POST
- **Authentication:** Bearer token
- **Request Body:**
  ```json
  {
    "user_ids": ["id1", "id2", ...]
  }
  ```
- **Flutter Example:**
  ```dart
  final response = await http.post(
    Uri.parse('$baseUrl/api/auth/users-anonymized-data'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    },
    body: jsonEncode({'user_ids': userIds}),
  );
  ```

### 2.3 Get Users' Profile Data

- **Purpose:** Retrieve profile data for multiple users.
- **Endpoint:** `/api/auth/users-profile-data`
- **Method:** POST
- **Authentication:** Bearer token
- **Request Body:**
  ```json
  {
    "user_ids": ["id1", "id2", ...]
  }
  ```
- **Flutter Example:**
  ```dart
  final response = await http.post(
    Uri.parse('$baseUrl/api/auth/users-profile-data'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    },
    body: jsonEncode({'user_ids': userIds}),
  );
  ```

---

## 3. Chat APIs

### 3.1 Create Conversation

- **Purpose:** Start a new chat conversation.
- **Endpoint:** `/api/chat/conversations`
- **Method:** POST
- **Authentication:** Bearer token
- **Request Body:**
  ```json
  {
    // conversation creation fields
  }
  ```
- **Flutter Example:**
  ```dart
  final response = await http.post(
    Uri.parse('$baseUrl/api/chat/conversations'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    },
    body: jsonEncode(conversationData),
  );
  ```

### 3.2 Get All Conversations

- **Purpose:** Retrieve all conversations for the user.
- **Endpoint:** `/api/chat/conversations`
- **Method:** GET
- **Authentication:** Bearer token
- **Flutter Example:**
  ```dart
  final response = await http.get(
    Uri.parse('$baseUrl/api/chat/conversations'),
    headers: {'Authorization': 'Bearer $accessToken'},
  );
  ```

### 3.3 Get Conversation by ID

- **Purpose:** Retrieve a specific conversation and its messages.
- **Endpoint:** `/api/chat/conversations/{conversationId}`
- **Method:** GET
- **Authentication:** Bearer token
- **Flutter Example:**
  ```dart
  final response = await http.get(
    Uri.parse('$baseUrl/api/chat/conversations/$conversationId'),
    headers: {'Authorization': 'Bearer $accessToken'},
  );
  ```

### 3.4 Send Message

- **Purpose:** Send a message in a conversation.
- **Endpoint:** `/api/chat/messages`
- **Method:** POST
- **Authentication:** Bearer token
- **Request Body:**
  ```json
  {
    // message fields
  }
  ```
- **Flutter Example:**
  ```dart
  final response = await http.post(
    Uri.parse('$baseUrl/api/chat/messages'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    },
    body: jsonEncode(messageData),
  );
  ```

### 3.5 Update Conversation Status

- **Purpose:** Update the status of a conversation (e.g., ended, trust, etc.).
- **Endpoint:** `/api/chat/conversations/{conversationId}/status`
- **Method:** PATCH
- **Authentication:** Bearer token
- **Request Body:**
  ```json
  {
    "status": "ended"
  }
  ```
- **Flutter Example:**
  ```dart
  final response = await http.patch(
    Uri.parse('$baseUrl/api/chat/conversations/$conversationId/status'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    },
    body: jsonEncode({'status': status}),
  );
  ```

### 3.6 Delete Conversation

- **Purpose:** Delete a conversation.
- **Endpoint:** `/api/chat/conversations/{conversationId}`
- **Method:** DELETE
- **Authentication:** Bearer token
- **Flutter Example:**
  ```dart
  final response = await http.delete(
    Uri.parse('$baseUrl/api/chat/conversations/$conversationId'),
    headers: {'Authorization': 'Bearer $accessToken'},
  );
  ```

---

## 4. Supabase Realtime APIs

### 4.1 Presence Channel (`online_users`)

- **Purpose:** Track and receive real-time updates about online users.
- **Channel Name:** `online_users`
- **Events:**
  - `presence.sync` (initial sync)
  - `presence.join` (user joined)
  - `presence.leave` (user left)
  - `broadcast.user_busy_status` (user busy status)
  - `broadcast.chat_request` (chat request)
  - `broadcast.chat_response` (chat response)
- **Flutter Implementation:**
  - Use [supabase_flutter](https://pub.dev/packages/supabase_flutter) package.
  - Example:
    ```dart
    final supabase = Supabase.instance.client;
    final channel = supabase.channel('online_users',
      opts: RealtimeChannelConfig(
        presence: RealtimePresenceConfig(key: userId),
        broadcast: RealtimeBroadcastConfig(self: false),
      ),
    );
    channel.on('presence', ChannelFilter(event: 'sync'), (payload, [ref]) {
      // Handle sync event
    });
    channel.subscribe();
    ```
- **Notes:** Use this channel to show online users and handle presence events.

### 4.2 Chat Channel (`chat_{user1}_{user2}`)

- **Purpose:** Real-time chat between two users.
- **Channel Name:** `chat_{user1}_{user2}`
- **Events:**
  - `broadcast.message` (new message)
  - `broadcast.user_left` (user left chat)
  - `broadcast.user_typing` (typing indicator)
  - `broadcast.message_delivered` (delivery receipt)
  - `broadcast.message_seen` (read receipt)
  - `broadcast.conversation_status_updated` (status change)
- **Flutter Implementation:**
  - Example:
    ```dart
    final channel = supabase.channel('chat_${user1}_$user2',
      opts: RealtimeChannelConfig(broadcast: RealtimeBroadcastConfig(self: false)),
    );
    channel.on('broadcast', ChannelFilter(event: 'message'), (payload, [ref]) {
      // Handle new message
    });
    channel.subscribe();
    ```
- **Notes:** Use this channel for all real-time chat features.

---

## 5. Local Asset APIs

### 5.1 Audio Files

- **Purpose:** Play notification sounds for chat events.
- **Endpoints:**
  - `/new-req.mp3`
  - `/new-message.mp3`
  - `/msg-sent.mp3`
- **Flutter Implementation:**
  - Use [audioplayers](https://pub.dev/packages/audioplayers) or [just_audio](https://pub.dev/packages/just_audio).
  - Example:
    ```dart
    final player = AudioPlayer();
    await player.play(AssetSource('assets/new-message.mp3'));
    ```
- **Notes:** Place audio files in your Flutter project's `assets/` directory and update `pubspec.yaml`.

---

# General Notes

- All REST APIs require the `Authorization: Bearer <access_token>` header after login.
- Handle errors and authentication failures gracefully in your Flutter app.
- For Supabase Realtime, see the [supabase_flutter documentation](https://supabase.com/docs/guides/realtime).
- For more details on request/response structures, refer to your backend API documentation or inspect network traffic.

---

**This documentation covers every API used in the LoopIn project and provides clear guidance for implementing them in Flutter.**

---

Here’s how you can fetch online users and conversation history using your API/services:

---

### 1. **Online Users**

- You do not currently have a direct API call for fetching online users in your `ApiService` or `UserService`.
- You will need to add a method in your API service (e.g., `ApiService`) to fetch online users from your backend (e.g., `/users/online`).

### 2. **Conversation History**

- Similarly, there is no direct API call for conversation history in your current codebase.
- You will need to add a method in your API service (e.g., `ApiService`) to fetch conversation history (e.g., `/conversations/history`).

---

## **What to Do Next**

### A. Add API Methods

**In `lib/features/auth/resources/api_service.dart`:**

```dart
<code_block_to_apply_changes_from>
```

_(You’ll need to define a `Conversation` model if you don’t have one yet.)_

---

### B. Use These Methods in Your Homepage

- Use a `FutureBuilder` or state management (Cubit/Bloc/Provider) to call these methods and display the results in your UI.

---

**Would you like me to:**

1. Add the API methods for you (with placeholder endpoints)?
2. Refactor your homepage to use `FutureBuilder` to display real online users and conversation history?

Let me know your preference, and I’ll proceed!
