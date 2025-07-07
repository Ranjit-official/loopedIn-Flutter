# Authentication System Documentation

This document explains how to use the authentication system in the Loopin app.

## Overview

The authentication system consists of several components:

1. **AuthService** - Main authentication service that handles sign in, sign up, and sign out
2. **ApiService** - Handles HTTP requests to the backend API
3. **UserService** - Provides business logic for user operations
4. **AuthWrapper** - Widget that checks authentication status and routes users
5. **AuthCubit** - State management for authentication using BLoC pattern
6. **UserProfileCubit** - State management for user profile operations

## API Endpoints

The system connects to your backend API at `http://localhost:4000/api`:

- **Sign In**: `POST /auth/signin/`
- **Sign Up**: `POST /auth/signup/`
- **Sign Out**: `POST /auth/signout/`

### Signup API Response

The signup endpoint returns the same structure as signin:

```json
{
  "message": "User Created Successfully",
  "user": {
    "id": "user-id",
    "email": "user@example.com",
    "email_confirmed_at": "2025-07-05T07:01:08.427861229Z",
    "created_at": "2025-07-05T07:01:08.392692Z",
    "updated_at": "2025-07-05T07:01:08.444208Z",
    "is_anonymous": false
  },
  "session": {
    "access_token": "jwt-token",
    "token_type": "bearer",
    "expires_in": 3600,
    "expires_at": 1751702468,
    "refresh_token": "refresh-token"
  }
}
```

## Usage Examples

### Basic Authentication

```dart
import 'package:loopedin/features/auth/resources/auth_service.dart';

final authService = AuthService();

// Sign in
final result = await authService.signIn(
  email: 'user@example.com',
  password: 'password123',
);

if (result.success) {
  print('User signed in: ${result.user?.name}');
  print('Token: ${result.token}');
} else {
  print('Error: ${result.message}');
}

// Sign up
final signUpResult = await authService.signUp(
  email: 'newuser@example.com',
  password: 'password123',
  name: 'New User',
);

// Sign out
final signOutResult = await authService.signOut();

// Check if user is authenticated
final isAuthenticated = await authService.isAuthenticated();

// Get current user
final currentUserResult = await authService.getCurrentUser();
```

### Using UserService

```dart
import 'package:loopedin/features/auth/resources/user_service.dart';

final userService = UserService();

// Get current user
final user = await userService.getCurrentUser();

// Update user profile
final success = await userService.updateUserProfile(
  name: 'Updated Name',
  title: 'Software Engineer',
  company: 'Tech Corp',
  industry: 'Technology',
  experience: '2-5 years',
  description: 'Passionate developer',
  topics: ['Technology', 'Sports', 'Travel'],
);

// Check profile completion
if (user != null) {
  final isComplete = userService.isProfileComplete(user);
  final percentage = userService.getProfileCompletionPercentage(user);
  final status = userService.getProfileCompletionStatus(user);
}
```

### Using AuthWrapper

The `AuthWrapper` widget automatically checks authentication status and routes users:

```dart
import 'package:loopedin/features/auth/widgets/auth_wrapper.dart';

// In your main.dart
MaterialApp(
  home: const AuthWrapper(),
)
```

### Using AuthCubit

The authentication system uses Cubit for state management:

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loopedin/features/auth/cubit/auth_cubit.dart';

// In your widget
BlocBuilder<AuthCubit, AuthState>(
  builder: (context, state) {
    if (state is AuthLoading) {
      return CircularProgressIndicator();
    } else if (state is Authenticated) {
      return HomePage();
    } else if (state is Unauthenticated) {
      return LoginPage();
    } else if (state is AuthError) {
      return Text('Error: ${state.message}');
    }
    return LoginPage();
  },
);

// Call cubit methods
context.read<AuthCubit>().signIn(
  email: 'user@example.com',
  password: 'password123',
);

// Check authentication status
final isAuthenticated = context.read<AuthCubit>().isAuthenticated;
final currentUser = context.read<AuthCubit>().currentUser;
```

### Using UserProfileCubit

For user profile management:

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loopedin/features/auth/cubit/user_profile_cubit.dart';

// In your widget
BlocBuilder<UserProfileCubit, UserProfileState>(
  builder: (context, state) {
    if (state is UserProfileLoading) {
      return CircularProgressIndicator();
    } else if (state is UserProfileLoaded) {
      return ProfileWidget(user: state.user);
    } else if (state is UserProfileError) {
      return Text('Error: ${state.message}');
    }
    return Text('No profile data');
  },
);

// Load user profile
context.read<UserProfileCubit>().loadUserProfile();

// Update user profile
context.read<UserProfileCubit>().updateUserProfile(
  name: 'New Name',
  title: 'Software Engineer',
  company: 'Tech Corp',
  // ... other fields
);

// Check profile completion
final completionPercentage = context.read<UserProfileCubit>().completionPercentage;
final isComplete = context.read<UserProfileCubit>().isProfileComplete;
```

## API Response Structure

The API returns responses in this format:

```json
{
  "message": "Sign in successful",
  "user": {
    "id": "user-id",
    "email": "user@example.com",
    "phone": "",
    "email_confirmed_at": "2025-07-04T05:05:34.321914Z",
    "confirmed_at": "2025-07-04T05:05:34.321914Z",
    "last_sign_in_at": "2025-07-05T05:57:06.264575223Z",
    "created_at": "2025-07-04T05:05:34.306609Z",
    "updated_at": "2025-07-05T05:57:06.27069Z",
    "is_anonymous": false
  },
  "session": {
    "access_token": "jwt-token",
    "token_type": "bearer",
    "expires_in": 3600,
    "expires_at": 1751698626,
    "refresh_token": "refresh-token",
    "user": { ... }
  }
}
```

## Error Handling

The system handles various error scenarios:

- **401 Unauthorized**: Invalid credentials (sign in)
- **409 Conflict**: User already exists (sign up)
- **422 Unprocessable Entity**: Invalid input data
- **Connection Timeout**: Network issues
- **General Errors**: Unexpected errors

### Testing

You can test the authentication system using the `AuthTestWidget`:

```dart
import 'package:loopedin/features/auth/widgets/auth_test_widget.dart';

// Navigate to test widget
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const AuthTestWidget()),
);
```

The test widget allows you to:

- Test sign in functionality
- Test sign up functionality
- Test direct API calls
- View current authentication state
- See detailed error messages

## Security Notes

- Access tokens are stored in memory (for demo purposes)
- In production, use secure storage like `flutter_secure_storage`
- Tokens are automatically included in API requests
- The system handles token expiration gracefully

## Dependencies

Make sure these dependencies are in your `pubspec.yaml`:

```yaml
dependencies:
  dio: ^5.4.0
  http: ^1.1.0
  shared_preferences: ^2.2.2
  flutter_bloc: ^8.1.5
  equatable: ^2.0.5
```

## Next Steps

1. **Secure Storage**: Replace in-memory storage with secure storage
2. **Token Refresh**: Implement automatic token refresh
3. **Profile API**: Add endpoints for user profile management
4. **Social Auth**: Add social authentication providers
5. **Biometric Auth**: Add biometric authentication support
