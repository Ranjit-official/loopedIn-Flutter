import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:loopedin/common/models/user_model.dart';
import 'package:loopedin/common/models/conversation_model.dart';

// API response models
class ApiUser {
  final String id;
  final String email;
  final String? phone;
  final DateTime? emailConfirmedAt;
  final DateTime? confirmedAt;
  final DateTime? lastSignInAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isAnonymous;

  ApiUser({
    required this.id,
    required this.email,
    this.phone,
    this.emailConfirmedAt,
    this.confirmedAt,
    this.lastSignInAt,
    required this.createdAt,
    required this.updatedAt,
    required this.isAnonymous,
  });

  factory ApiUser.fromJson(Map<String, dynamic> json) {
    return ApiUser(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      emailConfirmedAt: json['email_confirmed_at'] != null
          ? DateTime.parse(json['email_confirmed_at'])
          : null,
      confirmedAt: json['confirmed_at'] != null
          ? DateTime.parse(json['confirmed_at'])
          : null,
      lastSignInAt: json['last_sign_in_at'] != null
          ? DateTime.parse(json['last_sign_in_at'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      isAnonymous: json['is_anonymous'] ?? false,
    );
  }
}

class ApiSession {
  final String accessToken;
  final String tokenType;
  final int expiresIn;
  final int expiresAt;
  final String refreshToken;
  final ApiUser user;

  ApiSession({
    required this.accessToken,
    required this.tokenType,
    required this.expiresIn,
    required this.expiresAt,
    required this.refreshToken,
    required this.user,
  });

  factory ApiSession.fromJson(Map<String, dynamic> json) {
    return ApiSession(
      accessToken: json['access_token'] ?? '',
      tokenType: json['token_type'] ?? '',
      expiresIn: json['expires_in'] ?? 0,
      expiresAt: json['expires_at'] ?? 0,
      refreshToken: json['refresh_token'] ?? '',
      user: ApiUser.fromJson(json['user'] ?? {}),
    );
  }
}

class ApiAuthResponse {
  final String message;
  final ApiUser user;
  final ApiSession session;

  ApiAuthResponse({
    required this.message,
    required this.user,
    required this.session,
  });

  factory ApiAuthResponse.fromJson(Map<String, dynamic> json) {
    return ApiAuthResponse(
      message: json['message'] ?? '',
      user: ApiUser.fromJson(json['user'] ?? {}),
      session: ApiSession.fromJson(json['session'] ?? {}),
    );
  }
}

// API Service
class ApiService {
  static const String _baseUrl = 'http://localhost:4000/api';
  static const String _signInEndpoint = '/auth/signin/';
  static const String _signUpEndpoint = '/auth/signup/';
  static const String _signOutEndpoint = '/auth/signout/';
  static const String _conversationsEndpoint = '/chat/conversations';

  late final Dio _dio;

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    // Add interceptors for logging
    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          logPrint: (obj) => debugPrint(obj.toString()),
        ),
      );
    }
  }

  // Sign in
  Future<ApiAuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        _signInEndpoint,
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        return ApiAuthResponse.fromJson(response.data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Sign in failed',
        );
      }
    } on DioException catch (e) {
      if (kDebugMode) {
        print('Sign in API error: ${e.message}');
        print('Response data: ${e.response?.data}');
      }

      // Handle specific error cases
      if (e.response?.statusCode == 401) {
        throw DioException(
          requestOptions: e.requestOptions,
          response: e.response,
          message: 'Invalid email or password',
        );
      } else if (e.response?.statusCode == 422) {
        final data = e.response?.data;
        if (data is Map<String, dynamic>) {
          final errors = data['errors'] ?? data['message'];
          if (errors != null) {
            throw DioException(
              requestOptions: e.requestOptions,
              response: e.response,
              message: errors.toString(),
            );
          }
        }
        throw DioException(
          requestOptions: e.requestOptions,
          response: e.response,
          message: 'Invalid input data. Please check your information.',
        );
      } else if (e.type == DioExceptionType.connectionTimeout) {
        throw DioException(
          requestOptions: e.requestOptions,
          response: e.response,
          message: 'Connection timeout. Please check your internet connection.',
        );
      }

      rethrow;
    } catch (e) {
      if (kDebugMode) {
        print('Sign in error: $e');
      }
      rethrow;
    }
  }

  // Sign up
  Future<ApiAuthResponse> signUp({
    required String email,
    required String password,
    String? name,
  }) async {
    try {
      final response = await _dio.post(
        _signUpEndpoint,
        data: {
          'email': email,
          'password': password,
          if (name != null) 'name': name,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiAuthResponse.fromJson(response.data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Sign up failed',
        );
      }
    } on DioException catch (e) {
      if (kDebugMode) {
        print('Sign up API error: ${e.message}');
        print('Response data: ${e.response?.data}');
      }

      // Handle specific error cases
      if (e.response?.statusCode == 409) {
        throw DioException(
          requestOptions: e.requestOptions,
          response: e.response,
          message: 'User with this email already exists',
        );
      } else if (e.response?.statusCode == 422) {
        final data = e.response?.data;
        if (data is Map<String, dynamic>) {
          final errors = data['errors'] ?? data['message'];
          if (errors != null) {
            throw DioException(
              requestOptions: e.requestOptions,
              response: e.response,
              message: errors.toString(),
            );
          }
        }
        throw DioException(
          requestOptions: e.requestOptions,
          response: e.response,
          message: 'Invalid input data. Please check your information.',
        );
      } else if (e.type == DioExceptionType.connectionTimeout) {
        throw DioException(
          requestOptions: e.requestOptions,
          response: e.response,
          message: 'Connection timeout. Please check your internet connection.',
        );
      }

      rethrow;
    } catch (e) {
      if (kDebugMode) {
        print('Sign up error: $e');
      }
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut({required String accessToken}) async {
    try {
      await _dio.post(
        _signOutEndpoint,
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );
    } on DioException catch (e) {
      if (kDebugMode) {
        print('Sign out API error: ${e.message}');
      }
      rethrow;
    } catch (e) {
      if (kDebugMode) {
        print('Sign out error: $e');
      }
      rethrow;
    }
  }

  // Convert API user to app user model
  UserModel convertApiUserToUserModel(ApiUser apiUser) {
    return UserModel(
      id: apiUser.id,
      name: apiUser.email.split('@')[0], // Use email prefix as name
      title: '', // Will be filled during profile setup
      company: '',
      industry: '',
      experience: '',
      description: '',
      topics: [],
      angle: 0.0,
      radius: 0.0,
      color: 0xFF4285F4, // Default color
    );
  }

  // Set auth token for subsequent requests
  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  // Clear auth token
  void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
  }

  // Get all conversations
  Future<List<ConversationModel>> getConversations() async {
    try {
      final response = await _dio.get(_conversationsEndpoint);

      if (response.statusCode == 200) {
        final data = response.data;

        if (kDebugMode) {
          print('API Response type: ${data.runtimeType}');
          print('API Response data: $data');
        }

        List<dynamic> conversationsJson;

        // Handle different response formats
        if (data is List) {
          // Direct list response
          conversationsJson = data;
          if (kDebugMode) {
            print('Handling as direct list response');
          }
        } else if (data is Map<String, dynamic>) {
          // Response wrapped in an object
          if (data.containsKey('conversations')) {
            conversationsJson = data['conversations'] ?? [];
            if (kDebugMode) {
              print('Handling as conversations key response');
            }
          } else if (data.containsKey('data')) {
            conversationsJson = data['data'] ?? [];
            if (kDebugMode) {
              print('Handling as data key response');
            }
          } else if (data.containsKey('results')) {
            conversationsJson = data['results'] ?? [];
            if (kDebugMode) {
              print('Handling as results key response');
            }
          } else {
            // Single conversation object
            conversationsJson = [data];
            if (kDebugMode) {
              print('Handling as single conversation object');
            }
          }
        } else {
          conversationsJson = [];
          if (kDebugMode) {
            print('Handling as empty response');
          }
        }

        return conversationsJson
            .map((json) => ConversationModel.fromJson(json))
            .toList();
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to fetch conversations',
        );
      }
    } on DioException catch (e) {
      if (kDebugMode) {
        print('Get conversations API error: ${e.message}');
        print('Response data: ${e.response?.data}');
      }

      // Handle specific error cases
      if (e.response?.statusCode == 401) {
        throw DioException(
          requestOptions: e.requestOptions,
          response: e.response,
          message: 'Unauthorized. Please sign in again.',
        );
      } else if (e.response?.statusCode == 404) {
        throw DioException(
          requestOptions: e.requestOptions,
          response: e.response,
          message: 'No conversations found.',
        );
      } else if (e.type == DioExceptionType.connectionTimeout) {
        throw DioException(
          requestOptions: e.requestOptions,
          response: e.response,
          message: 'Connection timeout. Please check your internet connection.',
        );
      }

      rethrow;
    } catch (e) {
      if (kDebugMode) {
        print('Get conversations error: $e');
      }
      rethrow;
    }
  }

  // Get conversation by ID
  Future<ConversationModel> getConversationById(String conversationId) async {
    try {
      final response = await _dio.get(
        '$_conversationsEndpoint/$conversationId',
      );

      if (response.statusCode == 200) {
        return ConversationModel.fromJson(response.data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to fetch conversation',
        );
      }
    } on DioException catch (e) {
      if (kDebugMode) {
        print('Get conversation API error: ${e.message}');
        print('Response data: ${e.response?.data}');
      }

      // Handle specific error cases
      if (e.response?.statusCode == 401) {
        throw DioException(
          requestOptions: e.requestOptions,
          response: e.response,
          message: 'Unauthorized. Please sign in again.',
        );
      } else if (e.response?.statusCode == 404) {
        throw DioException(
          requestOptions: e.requestOptions,
          response: e.response,
          message: 'Conversation not found.',
        );
      }

      rethrow;
    } catch (e) {
      if (kDebugMode) {
        print('Get conversation error: $e');
      }
      rethrow;
    }
  }

  // Create new conversation
  Future<ConversationModel> createConversation({
    required String participant2Id,
  }) async {
    try {
      final response = await _dio.post(
        _conversationsEndpoint,
        data: {'participant2_id': participant2Id},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ConversationModel.fromJson(response.data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to create conversation',
        );
      }
    } on DioException catch (e) {
      if (kDebugMode) {
        print('Create conversation API error: ${e.message}');
        print('Response data: ${e.response?.data}');
      }

      // Handle specific error cases
      if (e.response?.statusCode == 401) {
        throw DioException(
          requestOptions: e.requestOptions,
          response: e.response,
          message: 'Unauthorized. Please sign in again.',
        );
      } else if (e.response?.statusCode == 422) {
        final data = e.response?.data;
        if (data is Map<String, dynamic>) {
          final errors = data['errors'] ?? data['message'];
          if (errors != null) {
            throw DioException(
              requestOptions: e.requestOptions,
              response: e.response,
              message: errors.toString(),
            );
          }
        }
        throw DioException(
          requestOptions: e.requestOptions,
          response: e.response,
          message: 'Invalid input data. Please check your information.',
        );
      }

      rethrow;
    } catch (e) {
      if (kDebugMode) {
        print('Create conversation error: $e');
      }
      rethrow;
    }
  }

  // Update conversation status
  Future<void> updateConversationStatus({
    required String conversationId,
    required String status,
  }) async {
    try {
      await _dio.patch(
        '$_conversationsEndpoint/$conversationId/status',
        data: {'status': status},
      );
    } on DioException catch (e) {
      if (kDebugMode) {
        print('Update conversation status API error: ${e.message}');
        print('Response data: ${e.response?.data}');
      }

      // Handle specific error cases
      if (e.response?.statusCode == 401) {
        throw DioException(
          requestOptions: e.requestOptions,
          response: e.response,
          message: 'Unauthorized. Please sign in again.',
        );
      } else if (e.response?.statusCode == 404) {
        throw DioException(
          requestOptions: e.requestOptions,
          response: e.response,
          message: 'Conversation not found.',
        );
      }

      rethrow;
    } catch (e) {
      if (kDebugMode) {
        print('Update conversation status error: $e');
      }
      rethrow;
    }
  }

  // Delete conversation
  Future<void> deleteConversation(String conversationId) async {
    try {
      await _dio.delete('$_conversationsEndpoint/$conversationId');
    } on DioException catch (e) {
      if (kDebugMode) {
        print('Delete conversation API error: ${e.message}');
        print('Response data: ${e.response?.data}');
      }

      // Handle specific error cases
      if (e.response?.statusCode == 401) {
        throw DioException(
          requestOptions: e.requestOptions,
          response: e.response,
          message: 'Unauthorized. Please sign in again.',
        );
      } else if (e.response?.statusCode == 404) {
        throw DioException(
          requestOptions: e.requestOptions,
          response: e.response,
          message: 'Conversation not found.',
        );
      }

      rethrow;
    } catch (e) {
      if (kDebugMode) {
        print('Delete conversation error: $e');
      }
      rethrow;
    }
  }
}
