import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:loopedin/common/models/user_model.dart';
import 'package:loopedin/features/auth/resources/user_repository.dart';

// Events
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
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

class SignInRequested extends AuthEvent {
  final String email;
  final String password;

  const SignInRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
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

// Bloc
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserRepository _userRepository;

  AuthBloc({UserRepository? userRepository})
    : _userRepository = userRepository ?? UserRepositoryProvider.instance,
      super(AuthInitial()) {
    on<SignUpRequested>(_onSignUpRequested);
    on<SignInRequested>(_onSignInRequested);
    on<SignOutRequested>(_onSignOutRequested);
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<UpdateProfileRequested>(_onUpdateProfileRequested);
  }

  Future<void> _onSignUpRequested(
    SignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final result = await _userRepository.signUp(
        email: event.email,
        password: event.password,
        name: event.name,
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

  Future<void> _onSignInRequested(
    SignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final result = await _userRepository.signIn(
        email: event.email,
        password: event.password,
      );

      if (result.success && result.user != null && result.token != null) {
        emit(Authenticated(user: result.user!, token: result.token!));
      } else {
        emit(AuthError(message: result.message ?? 'Sign in failed'));
      }
    } catch (e) {
      emit(AuthError(message: 'An unexpected error occurred'));
    }
  }

  Future<void> _onSignOutRequested(
    SignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final result = await _userRepository.signOut();

      if (result.success) {
        emit(Unauthenticated());
      } else {
        emit(AuthError(message: result.message ?? 'Sign out failed'));
      }
    } catch (e) {
      emit(AuthError(message: 'An unexpected error occurred'));
    }
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final isAuthenticated = await _userRepository.isAuthenticated();

      if (isAuthenticated) {
        final result = await _userRepository.getCurrentUser();
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

  Future<void> _onUpdateProfileRequested(
    UpdateProfileRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final result = await _userRepository.updateUserProfile(event.user);

      if (result.success && result.user != null) {
        // Get the current token
        final token = await _userRepository.getAuthToken();
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
}
