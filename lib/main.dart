import 'package:flutter/material.dart';
import 'package:recipe_book_app/routes/routes_gen.dart';
import 'package:recipe_book_app/style/theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  static final GlobalKey<MyAppState> appKey = GlobalKey<MyAppState>();
  const MyApp({super.key, Key? appKey});

  @override
  State<MyApp> createState() => MyAppState();

  static MyAppState? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_MyAppInherited>()
        ?.appState;
  }
}

class MyAppState extends State<MyApp> {
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _MyAppInherited(
      appState: this,
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,

        initialRoute: '/',
        onGenerateRoute: RouteGenerator.generateRoute,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class _MyAppInherited extends InheritedWidget {
  final MyAppState appState;

  const _MyAppInherited({required this.appState, required super.child});

  @override
  bool updateShouldNotify(_MyAppInherited oldWidget) {
    return oldWidget.appState != appState;
  }
}
