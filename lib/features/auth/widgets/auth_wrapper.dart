import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loopedin/features/auth/cubit/auth_cubit.dart';
import 'package:loopedin/features/auth/ui/pages/login_page.dart';
import 'package:loopedin/features/home/ui/pages/home_page.dart';
import 'package:loopedin/common/custom_loading_widget.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    // Listen to auth state changes to know when initialization is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authCubit = context.read<AuthCubit>();
      authCubit.stream.listen((state) {
        if (!_isInitialized &&
            (state is Authenticated || state is Unauthenticated)) {
          setState(() {
            _isInitialized = true;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (kDebugMode) {
          print('AuthWrapper: Received state: ${state.runtimeType}');
        }

        if (state is AuthError) {
          if (kDebugMode) {
            print(
              'AuthWrapper: Showing error SnackBar with message: ${state.message}',
            );
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 4),
            ),
          );
        }
      },
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (kDebugMode) {
            print(
              'AuthWrapper: Building UI for state: ${state.runtimeType}, initialized: $_isInitialized',
            );
          }

          // Show loading only during sign in/out operations, not during initialization
          if (state is AuthLoading && _isInitialized) {
            return const Scaffold(
              body: CustomLoadingWidget(size: 120, message: 'Loading...'),
            );
          }

          // Show loading during initialization
          if (!_isInitialized) {
            return const Scaffold(
              body: CustomLoadingWidget(size: 120, message: 'Initializing...'),
            );
          }

          if (state is Authenticated) {
            return const HomePage();
          } else {
            return const LoginPage();
          }
        },
      ),
    );
  }
}
