import 'package:flutter/material.dart';
import 'package:recipe_book_app/screens/categories_screen.dart';
import 'package:recipe_book_app/screens/favorite_screen.dart';
import 'package:recipe_book_app/screens/home_screen.dart';
import 'package:recipe_book_app/screens/profile_screen.dart';
import 'package:recipe_book_app/screens/recipe_details.dart';
import 'package:recipe_book_app/screens/recipe_list_screen.dart';
import 'package:recipe_book_app/screens/search_result.dart';
import 'package:recipe_book_app/screens/settings_screen.dart';
import 'package:recipe_book_app/screens/shopping_list_screen.dart';
import 'package:recipe_book_app/widgets/common/responsive_navigation.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // The mail sorting facility - decides where each "letter" should go
    switch (settings.name) {
      case '/':
        return _buildRoute(ResponsiveNavigation(), settings);
      case '/home':
        return _buildRoute(HomeScreen(), settings);

      case '/recipes':
        return _buildRoute(RecipeListScreen(), settings);

      case '/recipe-detail':
        // Check if we have the required information
        if (settings.arguments is Map<String, dynamic>) {
          final args = settings.arguments as Map<String, dynamic>;

          // Validate required data
          if (args.containsKey('recipeId') && args.containsKey('recipeData')) {
            return _buildRoute(RecipeDetailPage(), settings);
          }
        }
        // If data is missing, show an error
        return _buildErrorRoute('Recipe data is required');

      case '/favorites':
        return _buildRoute(FavoritesScreen(), settings);

      case '/profile':
        return _buildRoute(ProfileScreen(), settings);
      case '/search':
        if (settings.arguments is String) {
          final query = settings.arguments as String;
          return _buildRoute(SearchResultsScreen(query: query), settings);
        }
        return _buildErrorRoute('Recipe data is required');

      case '/settings':
        return _buildRoute(SettingsScreen(), settings);
      case '/recipesBycategory':
        if (settings.arguments is String) {
          final category = settings.arguments as String;
          return _buildRoute(
            CategoryRecipesScreen(category: category),
            settings,
          );
        }
        return _buildErrorRoute('Recipe data is required');
      case '/shopping-list':
        return _buildRoute(ShoppingListScreen(), settings);

      default:
        return _buildErrorRoute('Page not found: ${settings.name}');
    }
  }

  static Route<dynamic> _buildRoute(Widget page, RouteSettings settings) {
    return MaterialPageRoute(builder: (context) => page, settings: settings);
  }

  static Route<dynamic> _buildErrorRoute(String message) {
    return MaterialPageRoute(
      builder:
          (context) => Scaffold(
            appBar: AppBar(title: Text('Error')),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red),
                  SizedBox(height: 16),
                  Text(
                    'Oops! Something went wrong',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed:
                        () => Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/',
                          (route) => false,
                        ),
                    child: Text('Go Home'),
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
