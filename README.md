# Recipe Book App

A beautiful and intuitive recipe management application built with Flutter/Dart. Organize your favorite recipes, discover new dishes, and enhance your cooking experience with this feature-rich mobile app.

## Features

- 📱 Cross-platform mobile app (iOS & Android)
- 🍳 Add, edit, and delete recipes
- 📸 Photo support for recipes
- 🔍 Search and filter recipes
- 📋 Ingredient lists and step-by-step instructions
- ⭐ Favorite recipes functionality
- 🏷️ Category-based organization
- ⏱️ Cooking time and difficulty tracking
- 📱 Responsive design for all screen sizes

## Screenshots

*Add your app screenshots here*

## Prerequisites

Before you begin, ensure you have the following installed on your machine:

- **Flutter SDK** (3.0.0 or higher) - [Installation Guide](https://docs.flutter.dev/get-started/install)
- **Dart SDK** (included with Flutter)
- **Android Studio** or **VS Code** with Flutter extensions
- **Xcode** (for iOS development - macOS only)
- **Git**

### Platform-specific requirements:

**For Android:**
- Android Studio with Android SDK
- Android device or emulator

**For iOS:**
- Xcode 14.0 or higher
- iOS Simulator or physical iOS device
- CocoaPods (usually installed with Xcode)

## Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/mhkaycey/recipe_book_app
cd recipe-book-app
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Platform Setup

#### For iOS (macOS only):
```bash
cd ios
pod install
cd ..
```

#### For Android:
No additional setup required if Android Studio is properly configured.

### 4. Run the App

```bash
# Run on connected device or emulator
flutter run

# Run on specific platform
flutter run -d ios
flutter run -d android

# Run in release mode
flutter run --release
```

## Development Setup

### Environment Configuration

1. Create a `.env` file in the root directory (if using environment variables):
```
API_BASE_URL=your_api_url_here
DATABASE_NAME=recipe_book.db
```

2. Configure your IDE:

#### VS Code:
- Install the Flutter extension
- Install the Dart extension
- Use `Ctrl+Shift+P` and run "Flutter: Select Device"

#### Android Studio:
- Install Flutter and Dart plugins
- Configure Flutter SDK path in settings
- Create AVD for testing

### 5. Database Setup (if applicable)

If your app uses a local database:

```bash
flutter packages pub run build_runner build
```

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
│   ├── recipe.dart
│   └── ingredient.dart
├── screens/                  # UI screens
│   ├── home_screen.dart
│   ├── recipe_detail_screen.dart
│   └── etc
├── widgets/                  # Reusable widgets
│   ├── recipe_card.dart
│   └── ingredient_list.dart
├── services/                 # Business logic
│   ├──service.dart
├── style/                    # Utility functions
│   └── app_color.dart
|   └── theme.dart
└── assets/                   # Images, fonts, etc.
    ├── images/
    └── fonts/
```

## Available Scripts

```bash
# Install dependencies
flutter pub get

# Run the app
flutter run

# Build for production
flutter build apk --release    # Android APK
flutter build ios --release    # iOS build

# Run tests
flutter test

# Analyze code
flutter analyze

# Format code
dart format .

# Clean build files
flutter clean
```

## Building for Production

### Android APK:
```bash
flutter build apk --release
```
The APK will be available at: `build/app/outputs/flutter-apk/app-release.apk`

### Android App Bundle:
```bash
flutter build appbundle --release
```

### iOS:
```bash
flutter build ios --release
```
Then open `ios/Runner.xcworkspace` in Xcode to archive and distribute.

## Testing

Run the test suite:

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run integration tests
flutter drive --target=test_driver/app.dart
```

## Dependencies

Key packages used in this project:

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  shared_preferences: ^2.2.0 # Local storage
  intl: ^0.20.2 # DateTime
  cached_network_image: ^3.2.3 # Image caching

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^2.0.0
  build_runner: ^2.4.6
```

## Troubleshooting

### Common Issues:

1. **"Flutter command not found"**
   - Ensure Flutter is added to your PATH
   - Restart your terminal/IDE

2. **"CocoaPods not installed" (iOS)**
   ```bash
   sudo gem install cocoapods
   ```

3. **"Android license status unknown"**
   ```bash
   flutter doctor --android-licenses
   ```

4. **Build failures after updating dependencies**
   ```bash
   flutter clean
   flutter pub get
   cd ios && pod install && cd ..  # iOS only
   ```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request


## Contact

Your Name - kelechimark041@gmail.com

Project Link: [https://github.com/mhkaycey/recipe_book_app](https://github.com/mhkaycey/recipe_book_app)



---

**Happy Cooking! 👨‍🍳👩‍🍳**