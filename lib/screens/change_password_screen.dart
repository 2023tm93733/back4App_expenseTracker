import 'package:back4app_assignment/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import '../services/auth_service.dart';
import '../widgets/app_banner.dart';

/// Screen for allowing users to change their account password.
///
/// This screen presents a form for entering the current password, new password,
/// and confirmation of the new password. Upon validation, it re-authenticates
/// the user, updates the password, and logs the user out for security.
class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

/// State class for ChangePasswordScreen, handling form input and submission logic.
class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  /// Key to identify the form and validate its input.
  final _formKey = GlobalKey<FormState>();

  /// Controller for the current password input field.
  final _currentCtrl = TextEditingController();

  /// Controller for the new password input field.
  final _newCtrl = TextEditingController();

  /// Controller for the confirm new password input field.
  final _confirmCtrl = TextEditingController();

  /// Indicates whether a password change request is in progress.
  bool _loading = false;

  /// Stores error message to display if password change fails.
  String? _error;

  /// Submits the password change request if the form is valid.
  ///
  /// Re-authenticates the user with the current password, then updates the password
  /// to the new value. On success, logs the user out and navigates to the home screen.
  Future<void> _change() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
    });

    // Re-authenticate the user with the current password
    final currentUser = await ParseUser.currentUser() as ParseUser?;
    if (currentUser == null) {
      setState(() => _loading = false);
      return;
    }
    final loginResp =
        await ParseUser(currentUser.username!, _currentCtrl.text, null).login();

    if (!loginResp.success) {
      setState(() {
        _loading = false;
        _error = 'Current password is incorrect';
      });
      return;
    }

    // Update the password
    currentUser.set('password', _newCtrl.text);
    final saveResp = await currentUser.save();
    setState(() => _loading = false);

    if (saveResp.success) {
      await AuthService.logout();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password changed. Please log in again.')),
      );
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    } else {
      setState(() => _error = saveResp.error?.message ?? 'Failed to update');
    }
  }

  @override
  /// Disposes of all text controllers when the widget is removed from the widget tree.
  void dispose() {
    _currentCtrl.dispose();
    _newCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  @override
  /// Builds the ChangePasswordScreen UI including form and buttons.
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const AppBanner(title: 'Change Password'),
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
                          'Update Your Password',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _currentCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Current Password',
                          ),
                          obscureText: true,
                          validator:
                              (v) =>
                                  v != null && v.isNotEmpty
                                      ? null
                                      : 'Enter current password',
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _newCtrl,
                          decoration: const InputDecoration(
                            labelText: 'New Password',
                          ),
                          obscureText: true,
                          validator: (v) {
                            if (v == null || v.length < 6)
                              return 'Min 6 characters';
                            if (v == _currentCtrl.text)
                              return 'New password must differ from current';
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _confirmCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Confirm Password',
                          ),
                          obscureText: true,
                          validator:
                              (v) =>
                                  v == _newCtrl.text
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
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _loading ? null : _change,
                            child:
                                _loading
                                    ? const SizedBox(
                                      height: 16,
                                      width: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                    : const Text('Change Password'),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Cancel'),
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
