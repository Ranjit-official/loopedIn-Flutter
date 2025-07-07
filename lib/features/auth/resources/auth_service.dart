import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:loopedin/common/models/user_model.dart';
import 'package:loopedin/features/auth/resources/api_service.dart';

// Authentication result class
class AuthResult {
  final bool success;
  final String? message;
  final UserModel? user;
  final String? token;

  AuthResult({required this.success, this.message, this.user, this.token});

  factory AuthResult.success({UserModel? user, String? token}) {
    return AuthResult(success: true, user: user, token: token);
  }

  factory AuthResult.failure({required String message}) {
    return AuthResult(success: false, message: message);
  }
}

// Authentication service that integrates with the backend API
class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final ApiService _apiService = ApiService();

  // Storage keys
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';

  // In-memory storage
  String? _authToken;
  UserModel? _currentUser;

  // Initialize and load saved data
  Future<void> initialize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedToken = prefs.getString(_tokenKey);
      final savedUserData = prefs.getString(_userKey);

      if (savedToken != null && savedUserData != null) {
        _authToken = savedToken;
        _currentUser = UserModel.fromMap(json.decode(savedUserData));

        // Set the auth token for future API calls
        _apiService.setAuthToken(savedToken);

        if (kDebugMode) {
          print('AuthService: Restored saved authentication data');
          print('User: ${_currentUser?.name}');
          print('Token: ${_authToken?.substring(0, 20)}...');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('AuthService: Error loading saved data: $e');
      }
    }
  }

  // Save authentication data to SharedPreferences
  Future<void> _saveAuthData(String token, UserModel user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, token);
      await prefs.setString(_userKey, json.encode(user.toMap()));

      if (kDebugMode) {
        print('AuthService: Saved authentication data');
      }
    } catch (e) {
      if (kDebugMode) {
        print('AuthService: Error saving data: $e');
      }
    }
  }

  // Clear saved authentication data
  Future<void> _clearAuthData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tokenKey);
      await prefs.remove(_userKey);

      if (kDebugMode) {
        print('AuthService: Cleared saved authentication data');
      }
    } catch (e) {
      if (kDebugMode) {
        print('AuthService: Error clearing data: $e');
      }
    }
  }

  // Sign up method
  Future<AuthResult> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      // Validate input
      if (email.isEmpty || password.isEmpty || name.isEmpty) {
        return AuthResult.failure(message: 'All fields are required');
      }

      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
        return AuthResult.failure(message: 'Please enter a valid email');
      }

      if (password.length < 8) {
        return AuthResult.failure(
          message: 'Password must be at least 8 characters',
        );
      }

      // Call the API
      final apiResponse = await _apiService.signUp(
        email: email,
        password: password,
        name: name,
      );

      // Convert API user to app user model
      final user = _apiService.convertApiUserToUserModel(apiResponse.user);

      // Store user data and token
      _currentUser = user;
      _authToken = apiResponse.session.accessToken;

      // Set the auth token for future API calls
      _apiService.setAuthToken(apiResponse.session.accessToken);

      // Save to persistent storage
      await _saveAuthData(apiResponse.session.accessToken, user);

      if (kDebugMode) {
        print('User registered successfully: ${user.name}');
        print('Access token: ${apiResponse.session.accessToken}');
      }

      return AuthResult.success(
        user: user,
        token: apiResponse.session.accessToken,
      );
    } on DioException catch (e) {
      if (kDebugMode) {
        print('Sign up API error: ${e.message}');
      }

      String errorMessage = 'Registration failed. Please try again.';
      if (e.response?.statusCode == 409) {
        errorMessage = 'User with this email already exists.';
      } else if (e.response?.statusCode == 422) {
        errorMessage = 'Please check your input and try again.';
      } else if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage =
            'Connection timeout. Please check your internet connection.';
      }

      return AuthResult.failure(message: errorMessage);
    } catch (e) {
      if (kDebugMode) {
        print('Sign up error: $e');
      }
      return AuthResult.failure(
        message: 'Registration failed. Please try again.',
      );
    }
  }

  // Sign in method
  Future<AuthResult> signIn({
    required String email,
    required String password,
  }) async {
    try {
      // Validate input
      if (email.isEmpty || password.isEmpty) {
        return AuthResult.failure(message: 'Email and password are required');
      }

      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
        return AuthResult.failure(message: 'Please enter a valid email');
      }

      // Call the API
      final apiResponse = await _apiService.signIn(
        email: email,
        password: password,
      );

      // Convert API user to app user model
      final user = _apiService.convertApiUserToUserModel(apiResponse.user);

      // Store user data and token
      _currentUser = user;
      _authToken = apiResponse.session.accessToken;

      // Set the auth token for future API calls
      _apiService.setAuthToken(apiResponse.session.accessToken);

      // Save to persistent storage
      await _saveAuthData(apiResponse.session.accessToken, user);

      if (kDebugMode) {
        print('User signed in successfully: ${user.name}');
        print('Access token: ${apiResponse.session.accessToken}');
      }

      return AuthResult.success(
        user: user,
        token: apiResponse.session.accessToken,
      );
    } on DioException catch (e) {
      if (kDebugMode) {
        print('Sign in API error: ${e.message}');
      }

      String errorMessage = 'Login failed. Please check your credentials.';
      if (e.response?.statusCode == 401) {
        errorMessage = 'Invalid email or password.';
      } else if (e.response?.statusCode == 422) {
        errorMessage = 'Please check your input and try again.';
      } else if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage =
            'Connection timeout. Please check your internet connection.';
      }

      return AuthResult.failure(message: errorMessage);
    } catch (e) {
      if (kDebugMode) {
        print('Sign in error: $e');
      }
      return AuthResult.failure(message: 'Login failed. Please try again.');
    }
  }

  // Sign out method
  Future<AuthResult> signOut() async {
    try {
      if (_authToken != null) {
        // Call the API to sign out
        await _apiService.signOut(accessToken: _authToken!);
      }

      // Clear stored data
      _currentUser = null;
      _authToken = null;

      // Clear auth token from API service
      _apiService.clearAuthToken();

      // Clear persistent storage
      await _clearAuthData();

      if (kDebugMode) {
        print('User signed out successfully');
      }

      return AuthResult.success();
    } on DioException catch (e) {
      if (kDebugMode) {
        print('Sign out API error: ${e.message}');
      }

      // Even if API call fails, clear local data
      _currentUser = null;
      _authToken = null;
      _apiService.clearAuthToken();
      await _clearAuthData();

      return AuthResult.success();
    } catch (e) {
      if (kDebugMode) {
        print('Sign out error: $e');
      }

      // Even if there's an error, clear local data
      _currentUser = null;
      _authToken = null;
      _apiService.clearAuthToken();
      await _clearAuthData();

      return AuthResult.success();
    }
  }

  // Get current user
  Future<AuthResult> getCurrentUser() async {
    try {
      if (_currentUser != null && _authToken != null) {
        return AuthResult.success(user: _currentUser!, token: _authToken!);
      } else {
        return AuthResult.failure(message: 'No authenticated user found');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Get current user error: $e');
      }
      return AuthResult.failure(message: 'Failed to get current user');
    }
  }

  // Update user profile
  Future<AuthResult> updateUserProfile(UserModel user) async {
    try {
      _currentUser = user;

      // Update saved data
      if (_authToken != null) {
        await _saveAuthData(_authToken!, user);
      }

      if (kDebugMode) {
        print('User profile updated successfully: ${user.name}');
      }

      return AuthResult.success(user: user, token: _authToken);
    } catch (e) {
      if (kDebugMode) {
        print('Update user profile error: $e');
      }
      return AuthResult.failure(message: 'Failed to update profile');
    }
  }

  // Check if user is authenticated
  Future<bool> isAuthenticated() async {
    return _authToken != null && _currentUser != null;
  }

  // Get auth token
  Future<String?> getAuthToken() async {
    return _authToken;
  }

  // Helper method to generate mock token
  String _generateMockToken(String email) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final tokenData = {
      'email': email,
      'timestamp': timestamp,
      'exp': timestamp + (24 * 60 * 60 * 1000), // 24 hours from now
    };
    return base64.encode(utf8.encode(json.encode(tokenData)));
  }
}
