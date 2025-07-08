import 'package:loopedin/common/models/user_model.dart';
import 'package:loopedin/features/auth/resources/auth_service.dart';

// User service that provides business logic for user operations
class UserService {
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal();

  final AuthService _authService = AuthService();

  // Get current user profile
  Future<UserModel?> getCurrentUser() async {
    try {
      final result = await _authService.getCurrentUser();
      return result.success ? result.user : null;
    } catch (e) {
      return null;
    }
  }

  // Update user profile
  Future<bool> updateUserProfile({
    String? name,
    String? title,
    String? company,
    String? industry,
    String? experience,
    String? description,
    List<String>? topics,
  }) async {
    try {
      final currentUser = await getCurrentUser();
      if (currentUser == null) {
        return false;
      }

      // Create updated user model
      final updatedUser = UserModel(
        id: currentUser.id,
        name: name ?? currentUser.name,
        title: title ?? currentUser.title,
        company: company ?? currentUser.company,
        industry: industry ?? currentUser.industry,
        experience: experience ?? currentUser.experience,
        description: description ?? currentUser.description,
        topics: topics ?? currentUser.topics,
        angle: currentUser.angle,
        radius: currentUser.radius,
        color: currentUser.color,
      );

      final result = await _authService.updateUserProfile(updatedUser);
      return result.success;
    } catch (e) {
      return false;
    }
  }

  // Check if user is authenticated
  Future<bool> isAuthenticated() async {
    try {
      return await _authService.isAuthenticated();
    } catch (e) {
      return false;
    }
  }

  // Sign out user
  Future<bool> signOut() async {
    try {
      final result = await _authService.signOut();
      return result.success;
    } catch (e) {
      return false;
    }
  }

  // Get user's authentication token
  Future<String?> getAuthToken() async {
    try {
      return await _authService.getAuthToken();
    } catch (e) {
      return null;
    }
  }

  // Validate user profile completeness
  bool isProfileComplete(UserModel user) {
    return user.name.isNotEmpty &&
        user.title.isNotEmpty &&
        user.company.isNotEmpty &&
        user.industry.isNotEmpty &&
        user.experience.isNotEmpty &&
        user.description.isNotEmpty &&
        user.topics.isNotEmpty;
  }

  // Get profile completion percentage
  double getProfileCompletionPercentage(UserModel user) {
    int completedFields = 0;
    int totalFields =
        7; // name, title, company, industry, experience, description, topics

    if (user.name.isNotEmpty) completedFields++;
    if (user.title.isNotEmpty) completedFields++;
    if (user.company.isNotEmpty) completedFields++;
    if (user.industry.isNotEmpty) completedFields++;
    if (user.experience.isNotEmpty) completedFields++;
    if (user.description.isNotEmpty) completedFields++;
    if (user.topics.isNotEmpty) completedFields++;

    return completedFields / totalFields;
  }

  // Get profile completion status
  String getProfileCompletionStatus(UserModel user) {
    final percentage = getProfileCompletionPercentage(user);

    if (percentage == 1.0) {
      return 'Complete';
    } else if (percentage >= 0.7) {
      return 'Almost Complete';
    } else if (percentage >= 0.4) {
      return 'Partially Complete';
    } else {
      return 'Incomplete';
    }
  }
}
