import 'package:flutter/material.dart';
import 'package:back4app_assignment/screens/login_screen.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import '../widgets/app_banner.dart';

/// Screen for users to request a password reset link via email.
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

/// State class for ForgotPasswordScreen handling form input and submission.
class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  /// Key to identify the form and validate its input.
  final _formKey = GlobalKey<FormState>();

  /// Controller for the email input field.
  final _emailCtrl = TextEditingController();

  /// Indicates whether a password reset request is in progress.
  bool _loading = false;

  /// Stores error message to display if password reset fails.
  String? _error;

  /// Submits the password reset request if the form is valid.
  /// Sends a reset link to the provided email if it exists.
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
    });

    final user = ParseUser(null, null, _emailCtrl.text.trim());
    final resp = await user.requestPasswordReset();

    setState(() => _loading = false);
    if (resp.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('If that email exists, a reset link has been sent.'),
        ),
      );
      Navigator.of(context).pop();
    } else {
      setState(() => _error = resp.error?.message ?? 'Something went wrong');
    }
  }

  @override
  /// Disposes the email controller when the widget is removed from the widget tree.
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  @override
  /// Builds the ForgotPasswordScreen UI including form and buttons.
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const AppBanner(title: 'Forgot Password'),
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
                          'Reset Your Password',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _emailCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Email Address',
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator:
                              (v) =>
                                  v != null && v.contains('@')
                                      ? null
                                      : 'Enter valid email',
                        ),
                        if (_error != null) ...[
                          const SizedBox(height: 12),
                          Text(
                            _error!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ],
                        const SizedBox(height: 16),
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
                                    : const Text('Send Reset Link'),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed:
                                  () => Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (_) => const LoginScreen(),
                                    ),
                                  ),
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
