# Back4App Assignment

A cross-platform Flutter project created as part of a lab assignment. The app integrates with [Back4App](https://www.back4app.com/) to demonstrate authentication and database operations using Flutter.

## 🚀 Features

- ✅ User authentication (Sign up, Login, Logout) via Back4App (Parse).
- ✅ Forgot Password, Reset Password, and Change Password functionalities.
- ✅ Real-time database operations using Parse SDK.
- ✅ Expense management: Create, Read, Update, and Delete (CRUD) operations.
- ✅ Cross-platform support: Android, iOS, Web, Windows, Linux, macOS.
- ✅ Clean, scalable Flutter project structure.
- ✅ Includes basic UI and asset support (`assets/logo.png`).

## 📁 Project Structure

```
back4app_assignment/
│
├── lib/                # Main Dart source code
├── assets/             # Static assets (e.g., images)
├── android/            # Android-specific configs
├── ios/                # iOS-specific configs
├── linux/              # Linux-specific configs
├── macos/              # macOS-specific configs
├── windows/            # Windows-specific configs
├── web/                # Web-specific configs
├── test/               # Unit and widget tests
└── pubspec.yaml        # Project metadata and dependencies
```

## 🛠️ Getting Started

### ✅ Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (channel `stable`)
- Platform-specific tools:
  - Android Studio (for Android)
  - Xcode (for iOS/macOS)
  - Chrome (for Web)
  - Visual Studio (for Windows)

### 📦 Setup Instructions

1. **Clone the repository:**

   ```bash
   git clone <repository-url>
   cd back4app_assignment
   ```

2. **Install dependencies:**

   ```bash
   flutter pub get
   ```

3. **Configure Back4App:**

   - Create a free account at [Back4App](https://www.back4app.com/).
   - Create a new app and note the Application ID and Client Key.
   - Update your initialization code (usually in `main.dart`) with your credentials.

4. **Run the application:**

   ```bash
   flutter run
   ```

## 📦 Build Commands

Build the app for your target platform:

- **Android**:
  ```bash
  flutter build apk
  ```
- **iOS**:
  ```bash
  flutter build ios
  ```
- **Web**:
  ```bash
  flutter build web
  ```
- **Windows**:
  ```bash
  flutter build windows
  ```
- **Linux**:
  ```bash
  flutter build linux
  ```
- **macOS**:
  ```bash
  flutter build macos
  ```

## 🧪 Testing

Run all unit and widget tests:

```bash
flutter test
```

## 📚 Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Back4App Docs](https://www.back4app.com/docs)
- [Parse Flutter SDK](https://docs.parseplatform.org/flutter/guide/)

## 📄 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

> Feel free to customize this `README.md` based on your actual app behavior, design choices, and future enhancements.
