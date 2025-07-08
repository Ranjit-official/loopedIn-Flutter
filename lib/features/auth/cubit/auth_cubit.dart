import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:loopedin/common/models/user_model.dart';
import 'package:loopedin/features/auth/resources/auth_service.dart';

// Events
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class SignInRequested extends AuthEvent {
  final String email;
  final String password;

  const SignInRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class SignUpRequested extends AuthEvent {
  final String email;
  final String password;
  final String name;

  const SignUpRequested({
    required this.email,
    required this.password,
    required this.name,
  });

  @override
  List<Object?> get props => [email, password, name];
}

class SignOutRequested extends AuthEvent {}

class AuthCheckRequested extends AuthEvent {}

class UpdateProfileRequested extends AuthEvent {
  final UserModel user;

  const UpdateProfileRequested({required this.user});

  @override
  List<Object?> get props => [user];
}

// States
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final UserModel user;
  final String token;

  const Authenticated({required this.user, required this.token});

  @override
  List<Object?> get props => [user, token];
}

class Unauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object?> get props => [message];
}

// Cubit
class AuthCubit extends Cubit<AuthState> {
  final AuthService _authService;

  AuthCubit({AuthService? authService})
    : _authService = authService ?? AuthService(),
      super(AuthInitial()) {
    // Initialize and load saved authentication data
    _initializeAuth();
  }

  // Initialize authentication service and load saved data
  Future<void> _initializeAuth() async {
    if (kDebugMode) {
      print('AuthCubit: Initializing authentication service');
    }

    try {
      await _authService.initialize();

      // Check if user is already authenticated
      final isAuthenticated = await _authService.isAuthenticated();

      if (isAuthenticated) {
        if (kDebugMode) {
          print('AuthCubit: User is already authenticated, restoring session');
        }

        final result = await _authService.getCurrentUser();
        if (result.success && result.user != null && result.token != null) {
          emit(Authenticated(user: result.user!, token: result.token!));
        } else {
          emit(Unauthenticated());
        }
      } else {
        if (kDebugMode) {
          print('AuthCubit: No saved authentication found');
        }
        emit(Unauthenticated());
      }
    } catch (e) {
      if (kDebugMode) {
        print('AuthCubit: Error initializing auth: $e');
      }
      emit(Unauthenticated());
    }
  }

  // Sign in
  Future<void> signIn({required String email, required String password}) async {
    emit(AuthLoading());

    if (kDebugMode) {
      print('AuthCubit: Starting sign in for email: $email');
    }

    try {
      final result = await _authService.signIn(
        email: email,
        password: password,
      );

      if (kDebugMode) {
        print(
          'AuthCubit: Sign in result - success: ${result.success}, message: ${result.message}',
        );
      }

      if (result.success && result.user != null && result.token != null) {
        if (kDebugMode) {
          print('AuthCubit: Sign in successful, emitting Authenticated state');
        }
        emit(Authenticated(user: result.user!, token: result.token!));
      } else {
        if (kDebugMode) {
          print(
            'AuthCubit: Sign in failed, emitting AuthError state with message: ${result.message}',
          );
        }
        emit(AuthError(message: result.message ?? 'Sign in failed'));
      }
    } catch (e) {
      if (kDebugMode) {
        print('AuthCubit: Unexpected error during sign in: $e');
      }
      emit(AuthError(message: 'An unexpected error occurred: $e'));
    }
  }

  // Sign up
  Future<void> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    emit(AuthLoading());

    try {
      final result = await _authService.signUp(
        email: email,
        password: password,
        name: name,
      );

      if (result.success && result.user != null && result.token != null) {
        emit(Authenticated(user: result.user!, token: result.token!));
      } else {
        emit(AuthError(message: result.message ?? 'Sign up failed'));
      }
    } catch (e) {
      emit(AuthError(message: 'An unexpected error occurred'));
    }
  }

  // Sign out
  Future<void> signOut() async {
    emit(AuthLoading());

    try {
      final result = await _authService.signOut();

      if (result.success) {
        emit(Unauthenticated());
      } else {
        emit(AuthError(message: result.message ?? 'Sign out failed'));
      }
    } catch (e) {
      emit(AuthError(message: 'An unexpected error occurred'));
    }
  }

  // Check authentication status
  Future<void> checkAuthStatus() async {
    emit(AuthLoading());

    try {
      final isAuthenticated = await _authService.isAuthenticated();

      if (isAuthenticated) {
        final result = await _authService.getCurrentUser();
        if (result.success && result.user != null && result.token != null) {
          emit(Authenticated(user: result.user!, token: result.token!));
        } else {
          emit(Unauthenticated());
        }
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(Unauthenticated());
    }
  }

  // Update user profile
  Future<void> updateProfile(UserModel user) async {
    emit(AuthLoading());

    try {
      final result = await _authService.updateUserProfile(user);

      if (result.success && result.user != null) {
        // Get the current token
        final token = await _authService.getAuthToken();
        if (token != null) {
          emit(Authenticated(user: result.user!, token: token));
        } else {
          emit(AuthError(message: 'Failed to get authentication token'));
        }
      } else {
        emit(AuthError(message: result.message ?? 'Profile update failed'));
      }
    } catch (e) {
      emit(AuthError(message: 'An unexpected error occurred'));
    }
  }

  // Clear error state
  void clearError() {
    if (state is AuthError) {
      emit(Unauthenticated());
    }
  }

  // Get current user (if authenticated)
  UserModel? get currentUser {
    if (state is Authenticated) {
      return (state as Authenticated).user;
    }
    return null;
  }

  // Get current token (if authenticated)
  String? get currentToken {
    if (state is Authenticated) {
      return (state as Authenticated).token;
    }
    return null;
  }

  // Check if user is authenticated
  bool get isAuthenticated => state is Authenticated;

  // Check if loading
  bool get isLoading => state is AuthLoading;
}
