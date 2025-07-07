import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:loopedin/common/models/user_model.dart';

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

// User repository interface
abstract class UserRepository {
  Future<AuthResult> signUp({
    required String email,
    required String password,
    required String name,
  });

  Future<AuthResult> signIn({required String email, required String password});

  Future<AuthResult> signOut();

  Future<AuthResult> getCurrentUser();

  Future<AuthResult> updateUserProfile(UserModel user);

  Future<bool> isAuthenticated();

  Future<String?> getAuthToken();

  Future<void> saveAuthToken(String token);

  Future<void> clearAuthToken();
}

// Implementation of user repository
class UserRepositoryImpl implements UserRepository {
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'current_user';

  @override
  Future<AuthResult> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

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

      // Simulate successful registration
      final user = UserModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        title: '',
        company: '',
        industry: '',
        experience: '',
        description: '',
        topics: [],
        angle: 0.0,
        radius: 0.0,
        color: 0xFF4285F4, // Google Blue
      );

      // Generate mock token
      final token = _generateMockToken(email);

      // Save user data locally
      await _saveUserData(user, token);

      if (kDebugMode) {
        print('User registered successfully: ${user.name}');
      }

      return AuthResult.success(user: user, token: token);
    } catch (e) {
      if (kDebugMode) {
        print('Sign up error: $e');
      }
      return AuthResult.failure(
        message: 'Registration failed. Please try again.',
      );
    }
  }

  @override
  Future<AuthResult> signIn({
    required String email,
    required String password,
  }) async {
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      // Validate input
      if (email.isEmpty || password.isEmpty) {
        return AuthResult.failure(message: 'Email and password are required');
      }

      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
        return AuthResult.failure(message: 'Please enter a valid email');
      }

      // Simulate authentication check
      // In a real app, this would validate against your backend
      if (password.length < 6) {
        return AuthResult.failure(message: 'Invalid credentials');
      }

      // Simulate successful login
      final user = UserModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: email.split('@')[0], // Use email prefix as name
        title: 'Software Engineer',
        company: 'Tech Company',
        industry: 'Technology',
        experience: '2-5 years',
        description: 'Passionate about building scalable software solutions.',
        topics: ['Technology', 'Sports', 'Travel'],
        angle: 0.0,
        radius: 0.0,
        color: 0xFF4285F4,
      );

      // Generate mock token
      final token = _generateMockToken(email);

      // Save user data locally
      await _saveUserData(user, token);

      if (kDebugMode) {
        print('User signed in successfully: ${user.name}');
      }

      return AuthResult.success(user: user, token: token);
    } catch (e) {
      if (kDebugMode) {
        print('Sign in error: $e');
      }
      return AuthResult.failure(
        message: 'Login failed. Please check your credentials.',
      );
    }
  }

  @override
  Future<AuthResult> signOut() async {
    try {
      // Clear local storage
      await clearAuthToken();

      if (kDebugMode) {
        print('User signed out successfully');
      }

      return AuthResult.success();
    } catch (e) {
      if (kDebugMode) {
        print('Sign out error: $e');
      }
      return AuthResult.failure(message: 'Sign out failed');
    }
  }

  @override
  Future<AuthResult> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_userKey);
      final token = prefs.getString(_tokenKey);

      if (userJson == null || token == null) {
        return AuthResult.failure(message: 'No authenticated user found');
      }

      final userMap = json.decode(userJson) as Map<String, dynamic>;
      final user = UserModel.fromMap(userMap);

      return AuthResult.success(user: user, token: token);
    } catch (e) {
      if (kDebugMode) {
        print('Get current user error: $e');
      }
      return AuthResult.failure(message: 'Failed to get current user');
    }
  }

  @override
  Future<AuthResult> updateUserProfile(UserModel user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = json.encode(user.toMap());
      await prefs.setString(_userKey, userJson);

      if (kDebugMode) {
        print('User profile updated successfully: ${user.name}');
      }

      return AuthResult.success(user: user);
    } catch (e) {
      if (kDebugMode) {
        print('Update user profile error: $e');
      }
      return AuthResult.failure(message: 'Failed to update profile');
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_tokenKey);
      return token != null;
    } catch (e) {
      if (kDebugMode) {
        print('Check authentication error: $e');
      }
      return false;
    }
  }

  @override
  Future<String?> getAuthToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_tokenKey);
    } catch (e) {
      if (kDebugMode) {
        print('Get auth token error: $e');
      }
      return null;
    }
  }

  @override
  Future<void> saveAuthToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, token);
    } catch (e) {
      if (kDebugMode) {
        print('Save auth token error: $e');
      }
    }
  }

  @override
  Future<void> clearAuthToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tokenKey);
      await prefs.remove(_userKey);
    } catch (e) {
      if (kDebugMode) {
        print('Clear auth token error: $e');
      }
    }
  }

  // Helper methods
  Future<void> _saveUserData(UserModel user, String token) async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = json.encode(user.toMap());

    await prefs.setString(_userKey, userJson);
    await prefs.setString(_tokenKey, token);
  }

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

// Singleton instance
class UserRepositoryProvider {
  static final UserRepository _instance = UserRepositoryImpl();

  static UserRepository get instance => _instance;
}
