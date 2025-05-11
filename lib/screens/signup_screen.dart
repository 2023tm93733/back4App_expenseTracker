// lib/screens/signup_screen.dart

import 'package:flutter/material.dart';
import '../widgets/app_banner.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';
import 'login_screen.dart';

/// A screen that allows users to create a new account.
///
/// This screen features a form for users to enter their username, email, and password.
/// Upon successful submission, the user is redirected to the home screen.
/// If an error occurs during signup, an error message is displayed.
class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

/// The state class for [SignupScreen].
///
/// Manages form state, user input, and signup submission.
class _SignupScreenState extends State<SignupScreen> {
  /// Key to manage form state and validation.
  final _formKey = GlobalKey<FormState>();

  /// Controller for the username input field.
  final _usernameCtrl = TextEditingController();

  /// Controller for the email input field.
  final _emailCtrl = TextEditingController();

  /// Controller for the password input field.
  final _passwordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();

  /// Whether the signup process is in progress.
  bool _loading = false;

  /// Error message to display if signup fails.
  String? _error;

  /// Handles the signup form submission.
  ///
  /// Validates the form, sends the signup request, and manages navigation and error states.
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await AuthService.signup(
        _usernameCtrl.text.trim(),
        _passwordCtrl.text,
        _emailCtrl.text.trim(),
      );
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const AppBanner(title: 'Create Your Account'),
          Expanded(
            child: Center(
              child: Card(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Sign Up',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _emailCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Email Address',
                          ),
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (value) {
                            final username = value.split('@').first;
                            _usernameCtrl.text = username;
                          },
                          validator:
                              (v) =>
                                  v != null && v.contains('@')
                                      ? null
                                      : 'Enter valid email',
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _usernameCtrl,
                          readOnly: true,
                          decoration: const InputDecoration(
                            labelText: 'Username (auto-generated)',
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _passwordCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                          ),
                          obscureText: true,
                          validator:
                              (v) =>
                                  v != null && v.length >= 6
                                      ? null
                                      : 'Min 6 characters',
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _confirmPasswordCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Confirm Password',
                          ),
                          obscureText: true,
                          validator:
                              (v) =>
                                  v == _passwordCtrl.text
                                      ? null
                                      : 'Passwords do not match',
                        ),
                        if (_error != null) ...[
                          const SizedBox(height: 12),
                          Text(
                            _error!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ],
                        const SizedBox(height: 16),
                        // full-width Sign Up button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _loading ? null : _submit,
                            child:
                                _loading
                                    ? const SizedBox(
                                      height: 16,
                                      width: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                    : const Text('Sign Up'),
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Back to Login link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (_) => const LoginScreen(),
                                  ),
                                );
                              },
                              child: const Text('Back to Login'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
