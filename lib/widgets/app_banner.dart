import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';

/// A banner widget for the app, typically used at the top of screens.
///
/// Displays a logo, title, and optional action widget. Tapping the logo navigates
/// to the home screen if logged in, or the login screen otherwise.
class AppBanner extends StatelessWidget {
  /// The title to display in the banner.
  final String title;

  /// An optional widget (e.g., button) displayed on the right side of the banner.
  final Widget? action;

  /// Creates an [AppBanner].
  ///
  /// [title]: The title to display in the banner.
  /// [action]: An optional widget to display on the right side of the banner.
  const AppBanner({Key? key, required this.title, this.action})
    : super(key: key);

  /// Handles the logo tap event.
  ///
  /// Checks if the user is logged in, then navigates to the home screen if logged in,
  /// or the login screen otherwise.
  Future<void> _onLogoTap(BuildContext context) async {
    final parseUser = await ParseUser.currentUser() as ParseUser?;
    final isLoggedIn = parseUser?.sessionToken != null;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => isLoggedIn ? const HomeScreen() : const LoginScreen(),
      ),
      (route) => false,
    );
  }

  @override
  /// Builds the banner UI with logo, title, and optional action widget.
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        color: Theme.of(context).primaryColor,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => _onLogoTap(context),
              child: Image.asset('assets/logo.png', width: 40, height: 40),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(color: Colors.white),
              ),
            ),
            if (action != null) action!, // Render the optional action widget
          ],
        ),
      ),
    );
  }
}
