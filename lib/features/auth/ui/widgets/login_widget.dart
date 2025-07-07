import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:loopedin/common/custom_button.dart';
import 'package:loopedin/common/custom_loading_widget.dart';
import 'package:loopedin/features/auth/ui/pages/login_page.dart';
import 'package:loopedin/features/auth/cubit/auth_cubit.dart';
import 'package:loopedin/features/home/ui/pages/home_page.dart';
import 'package:flutter/foundation.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _emailFieldKey = GlobalKey<FormBuilderFieldState>();
  final _passwordFieldKey = GlobalKey<FormBuilderFieldState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (kDebugMode) {
          print('LoginWidget: Received state: ${state.runtimeType}');
        }

        if (state is AuthError) {
          if (kDebugMode) {
            print(
              'LoginWidget: Showing error SnackBar with message: ${state.message}',
            );
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 4),
            ),
          );
        } else if (state is Authenticated) {
          if (kDebugMode) {
            print('LoginWidget: User authenticated, navigating to home');
          }
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        }
      },
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                Text(
                  'Sign In',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 20),
                FormBuilder(
                  key: _formKey,
                  child: Column(
                    children: [
                      FormBuilderTextField(
                        name: 'email',
                        key: _emailFieldKey,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey.shade300,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey.shade300,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blue,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red, width: 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                            errorText: 'Email is required',
                          ),
                          FormBuilderValidators.email(
                            errorText: 'Please enter a valid email',
                          ),
                        ]),
                      ),
                      SizedBox(height: 20),
                      FormBuilderTextField(
                        name: 'password',
                        key: _passwordFieldKey,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey.shade300,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey.shade300,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blue,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red, width: 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                            errorText: 'Password is required',
                          ),
                          FormBuilderValidators.minLength(
                            6,
                            errorText: 'Password must be at least 6 characters',
                          ),
                        ]),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                CustomButton(
                  name: isLoading ? "" : "Sign In",
                  onPressed: isLoading
                      ? null
                      : () {
                          if (_formKey.currentState!.saveAndValidate()) {
                            final formData = _formKey.currentState!.value;
                            final email = formData['email'] as String;
                            final password = formData['password'] as String;

                            context.read<AuthCubit>().signIn(
                              email: email,
                              password: password,
                            );
                          }
                        },
                  child: isLoading
                      ? const SmallLoadingWidget(size: 20, color: Colors.white)
                      : null,
                ),
                SizedBox(height: 20),
                RichText(
                  text: TextSpan(
                    style: TextStyle(color: Colors.grey),
                    children: [
                      TextSpan(text: 'New to Loopin? '),
                      TextSpan(
                        text: 'Sign up',
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const LoginPage(isLoginPage: false),
                              ),
                            );
                          },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
