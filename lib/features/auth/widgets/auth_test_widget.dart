import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loopedin/features/auth/cubit/auth_cubit.dart';
import 'package:loopedin/features/auth/resources/api_service.dart';

class AuthTestWidget extends StatefulWidget {
  const AuthTestWidget({super.key});

  @override
  State<AuthTestWidget> createState() => _AuthTestWidgetState();
}

class _AuthTestWidgetState extends State<AuthTestWidget> {
  final ApiService _apiService = ApiService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  String _testResult = '';
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Auth API Test'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            setState(() {
              _testResult = 'Error: ${state.message}';
              _isLoading = false;
            });
          } else if (state is Authenticated) {
            setState(() {
              _testResult =
                  'Success! User: ${state.user.name}, Token: ${state.token.substring(0, 20)}...';
              _isLoading = false;
            });
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Test inputs
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name (for signup)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),

              // Test buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _testSignIn,
                      child: const Text('Test Sign In'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _testSignUp,
                      child: const Text('Test Sign Up'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isLoading ? null : _testDirectApi,
                child: const Text('Test Direct API Call'),
              ),
              const SizedBox(height: 24),

              // Test API calls directly
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    _testResult = 'Testing API...';
                  });

                  try {
                    final response = await _apiService.signIn(
                      email: 'invalid@test.com',
                      password: 'wrongpassword',
                    );
                    setState(() {
                      _testResult = 'API Success: ${response.message}';
                    });
                  } catch (e) {
                    setState(() {
                      _testResult = 'API Error: $e';
                    });
                  }
                },
                child: Text('Test Invalid Login (API)'),
              ),
              SizedBox(height: 10),

              // Test with empty credentials
              ElevatedButton(
                onPressed: () {
                  context.read<AuthCubit>().signIn(email: '', password: '');
                },
                child: Text('Test Empty Credentials'),
              ),
              SizedBox(height: 10),

              // Test with invalid email format
              ElevatedButton(
                onPressed: () {
                  context.read<AuthCubit>().signIn(
                    email: 'invalid-email',
                    password: 'password123',
                  );
                },
                child: Text('Test Invalid Email Format'),
              ),

              // Loading indicator
              if (_isLoading) const Center(child: CircularProgressIndicator()),

              const SizedBox(height: 16),

              // Test results
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Test Results:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _testResult.isEmpty ? 'No test run yet' : _testResult,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Current auth state
              BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue[200]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Current Auth State:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          state.runtimeType.toString(),
                          style: const TextStyle(fontSize: 14),
                        ),
                        if (state is Authenticated) ...[
                          const SizedBox(height: 8),
                          Text('User: ${state.user.name}'),
                          Text('Token: ${state.token.substring(0, 30)}...'),
                        ],
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _testSignIn() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() {
        _testResult = 'Please enter email and password';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _testResult = 'Testing sign in...';
    });

    context.read<AuthCubit>().signIn(
      email: _emailController.text,
      password: _passwordController.text,
    );
  }

  void _testSignUp() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() {
        _testResult = 'Please enter email and password';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _testResult = 'Testing sign up...';
    });

    context.read<AuthCubit>().signUp(
      email: _emailController.text,
      password: _passwordController.text,
      name: _nameController.text.isNotEmpty
          ? _nameController.text
          : _emailController.text.split('@')[0],
    );
  }

  void _testDirectApi() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() {
        _testResult = 'Please enter email and password';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _testResult = 'Testing direct API call...';
    });

    try {
      final response = await _apiService.signUp(
        email: _emailController.text,
        password: _passwordController.text,
        name: _nameController.text.isNotEmpty ? _nameController.text : null,
      );

      setState(() {
        _testResult =
            'Direct API Success!\n'
            'Message: ${response.message}\n'
            'User ID: ${response.user.id}\n'
            'Email: ${response.user.email}\n'
            'Token: ${response.session.accessToken.substring(0, 30)}...';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _testResult = 'Direct API Error: $e';
        _isLoading = false;
      });
    }
  }
}
