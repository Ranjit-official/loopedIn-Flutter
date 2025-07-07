import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:loopedin/common/models/user_model.dart';
import 'package:loopedin/features/auth/resources/user_service.dart';

// Events
abstract class UserProfileEvent extends Equatable {
  const UserProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadUserProfile extends UserProfileEvent {}

class UpdateUserProfile extends UserProfileEvent {
  final String? name;
  final String? title;
  final String? company;
  final String? industry;
  final String? experience;
  final String? description;
  final List<String>? topics;

  const UpdateUserProfile({
    this.name,
    this.title,
    this.company,
    this.industry,
    this.experience,
    this.description,
    this.topics,
  });

  @override
  List<Object?> get props => [
    name,
    title,
    company,
    industry,
    experience,
    description,
    topics,
  ];
}

class ClearUserProfile extends UserProfileEvent {}

// States
abstract class UserProfileState extends Equatable {
  const UserProfileState();

  @override
  List<Object?> get props => [];
}

class UserProfileInitial extends UserProfileState {}

class UserProfileLoading extends UserProfileState {}

class UserProfileLoaded extends UserProfileState {
  final UserModel user;
  final double completionPercentage;
  final String completionStatus;
  final bool isComplete;

  const UserProfileLoaded({
    required this.user,
    required this.completionPercentage,
    required this.completionStatus,
    required this.isComplete,
  });

  @override
  List<Object?> get props => [
    user,
    completionPercentage,
    completionStatus,
    isComplete,
  ];
}

class UserProfileError extends UserProfileState {
  final String message;

  const UserProfileError({required this.message});

  @override
  List<Object?> get props => [message];
}

// Cubit
class UserProfileCubit extends Cubit<UserProfileState> {
  final UserService _userService;

  UserProfileCubit({UserService? userService})
    : _userService = userService ?? UserService(),
      super(UserProfileInitial());

  // Load user profile
  Future<void> loadUserProfile() async {
    emit(UserProfileLoading());

    try {
      final user = await _userService.getCurrentUser();

      if (user != null) {
        final completionPercentage = _userService
            .getProfileCompletionPercentage(user);
        final completionStatus = _userService.getProfileCompletionStatus(user);
        final isComplete = _userService.isProfileComplete(user);

        emit(
          UserProfileLoaded(
            user: user,
            completionPercentage: completionPercentage,
            completionStatus: completionStatus,
            isComplete: isComplete,
          ),
        );
      } else {
        emit(const UserProfileError(message: 'No user profile found'));
      }
    } catch (e) {
      emit(const UserProfileError(message: 'Failed to load user profile'));
    }
  }

  // Update user profile
  Future<void> updateUserProfile({
    String? name,
    String? title,
    String? company,
    String? industry,
    String? experience,
    String? description,
    List<String>? topics,
  }) async {
    emit(UserProfileLoading());

    try {
      final success = await _userService.updateUserProfile(
        name: name,
        title: title,
        company: company,
        industry: industry,
        experience: experience,
        description: description,
        topics: topics,
      );

      if (success) {
        // Reload the profile to get updated data
        await loadUserProfile();
      } else {
        emit(const UserProfileError(message: 'Failed to update profile'));
      }
    } catch (e) {
      emit(const UserProfileError(message: 'Failed to update profile'));
    }
  }

  // Clear user profile
  void clearUserProfile() {
    emit(UserProfileInitial());
  }

  // Get current user
  UserModel? get currentUser {
    if (state is UserProfileLoaded) {
      return (state as UserProfileLoaded).user;
    }
    return null;
  }

  // Get completion percentage
  double get completionPercentage {
    if (state is UserProfileLoaded) {
      return (state as UserProfileLoaded).completionPercentage;
    }
    return 0.0;
  }

  // Get completion status
  String get completionStatus {
    if (state is UserProfileLoaded) {
      return (state as UserProfileLoaded).completionStatus;
    }
    return 'Unknown';
  }

  // Check if profile is complete
  bool get isProfileComplete {
    if (state is UserProfileLoaded) {
      return (state as UserProfileLoaded).isComplete;
    }
    return false;
  }

  // Check if loading
  bool get isLoading => state is UserProfileLoading;

  // Check if profile is loaded
  bool get isLoaded => state is UserProfileLoaded;

  // Check if there's an error
  bool get hasError => state is UserProfileError;

  // Get error message
  String? get errorMessage {
    if (state is UserProfileError) {
      return (state as UserProfileError).message;
    }
    return null;
  }
}
