import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'screens/login_screen.dart';

/// The entry point of the Flutter application.
///
/// Initializes the app, loads environment variables, sets up the Parse/Back4App connection,
/// and runs the main app widget.
Future<void> main() async {
  // Ensure Flutter bindings are initialized before running any async code
  WidgetsFlutterBinding.ensureInitialized();
  // Load environment variables from the `.env` file
  await dotenv.load();

  // ───  Initialize Back4App / Parse  ───────────────────────────────────
  await Parse().initialize(
    dotenv.env['PARSE_APP_ID']!,
    dotenv.env['PARSE_SERVER_URL']!,
    clientKey: dotenv.env['PARSE_CLIENT_KEY']!,
    debug: true,
    autoSendSessionId: true,
  );
  // ──────────────────────────────────────────────────────────────────────

  // Run the main app widget
  runApp(const MyApp());
}

/// The root widget of the application.
///
/// Configures the app's theme and sets the [LoginScreen] as the initial route.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  /// Builds the MaterialApp with a custom theme and the LoginScreen as the home route.
  Widget build(BuildContext context) => MaterialApp(
    title: 'ExpensePro',
    theme: ThemeData(
      primaryColor: Colors.deepPurple,
      primarySwatch: Colors.deepPurple,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.deepPurple,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Colors.deepPurple,
          textStyle: const TextStyle(fontSize: 14),
        ),
      ),
    ),
    home: const LoginScreen(),
  );
}
