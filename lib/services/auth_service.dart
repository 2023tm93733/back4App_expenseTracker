import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

/// Service class for handling user authentication operations.
///
/// Provides static methods for user login, signup, and logout using Parse backend.
class AuthService {
  /// Logs in a user with the provided username and password.
  ///
  /// Throws an [Exception] if the login fails, with a message from the backend or a default message.
  ///
  /// [username]: The user's username.
  /// [password]: The user's password.
  static Future<void> login(String username, String password) async {
    final resp = await ParseUser(username, password, null).login();
    if (!resp.success) {
      throw Exception(resp.error?.message ?? 'Login failed');
    }
  }

  /// Registers a new user with the provided username, password, and email.
  ///
  /// Throws an [Exception] if the signup fails, with a message from the backend or a default message.
  ///
  /// [username]: The user's desired username.
  /// [password]: The user's desired password.
  /// [email]: The user's email address.
  static Future<void> signup(
    String username,
    String password,
    String email,
  ) async {
    final resp = await ParseUser(username, password, email).signUp();
    if (!resp.success) {
      throw Exception(resp.error?.message ?? 'Signup failed');
    }
  }

  /// Logs out the currently authenticated user.
  ///
  /// If no user is logged in, this method does nothing.
  static Future<void> logout() async {
    final user = await ParseUser.currentUser() as ParseUser?;
    if (user != null) {
      await user.logout();
    }
  }
}
