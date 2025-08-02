import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:recipe_book_app/model/ingredient_info.dart';
import 'package:recipe_book_app/style/app_colors.dart';

extension SnackBarExtension on BuildContext {
  void showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColor.primary,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

extension NutritionInfoExtension on NutritionInfo {
  List<Map<String, String>> toList() {
    return [
      {'name': 'Calories', 'value': '$calories', 'unit': 'kcal'},
      {'name': 'Protein', 'value': '$protein', 'unit': 'g'},
      {'name': 'Carbs', 'value': '$carbs', 'unit': 'g'},
      {'name': 'Fat', 'value': '$fat', 'unit': 'g'},
      {'name': 'Fiber', 'value': '$fiber', 'unit': 'g'},
      {'name': 'Sugar', 'value': '$sugar', 'unit': 'g'},
      {'name': 'Sodium', 'value': '$sodium', 'unit': 'mg'},
    ];
  }
}

extension CorsStringExtension on String {
  String getCorsProxyUrl() {
    if (kIsWeb) {
      return 'https://corsproxy.io/?${Uri.encodeComponent(this)}';
    }
    return this; // Return original URL for mobile
  }
}
