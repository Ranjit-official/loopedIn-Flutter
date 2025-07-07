import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:loopedin/common/models/user_model.dart';

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
}
