import 'package:recipe_book_app/data/sample_data.dart';
import 'package:recipe_book_app/model/recipe.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecipeService {
  static final RecipeService _instance = RecipeService._internal();
  factory RecipeService() => _instance;
  RecipeService._internal();

  static const String _favoritesKey = 'myFavorites';
  static const String _shoppingListKey = 'shoppingList';
  // static const String _recentlyViewedKey = 'recentlyViewed';
  final List<Recipe> _favourites = [];
  final List<Recipe> _shoppingList = [];
  List<Recipe> get shopList => _shoppingList;

  Future<List<Recipe>> addToShoppingList(Recipe recipe) async {
    final prefs = await SharedPreferences.getInstance();
    if (!_shoppingList.contains(recipe)) {
      _shoppingList.add(recipe);
      List<String> shoppingListIds = _shoppingList.map((r) => r.id).toList();
      await prefs.setStringList(_shoppingListKey, shoppingListIds);
    }
    return List.from(_shoppingList);
  }

  Future<List<Recipe>> getShoppingList() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> shoppingListIds = prefs.getStringList(_shoppingListKey) ?? [];
    _shoppingList.clear();
    for (String id in shoppingListIds) {
      var recipe = await getRecipeById(id);
      if (recipe != null) {
        _shoppingList.add(recipe);
      }
    }
    return List.from(_shoppingList);
  }

  Future<void> removeFromShoppingList(String recipeId) async {
    final prefs = await SharedPreferences.getInstance();
    _shoppingList.removeWhere((recipe) => recipe.id == recipeId);
    List<String> shoppingListIds = _shoppingList.map((r) => r.id).toList();
    await prefs.setStringList('shoppingList', shoppingListIds);
  }

  Future<void> clearShoppingList() async {
    final prefs = await SharedPreferences.getInstance();
    _shoppingList.clear();
    await prefs.remove('shoppingList');
  }

  Future<List<Recipe>> getRecentlyViewed() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> recentlyViewedIds =
        prefs.getStringList('recentlyViewed') ?? [];
    List<Recipe> recentlyViewedRecipes = [];
    for (String id in recentlyViewedIds) {
      var recipe = await getRecipeById(id);
      if (recipe != null) {
        recentlyViewedRecipes.add(recipe);
      }
    }
    return recentlyViewedRecipes;
  }

  Future<void> addRecentlyViewed(String recipeId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> recentlyViewedIds =
        prefs.getStringList('recentlyViewed') ?? [];

    recentlyViewedIds.remove(recipeId);

    recentlyViewedIds.insert(0, recipeId);

    if (recentlyViewedIds.length > 10) {
      recentlyViewedIds = recentlyViewedIds.sublist(0, 10);
    }

    await prefs.setStringList('recentlyViewed', recentlyViewedIds);
  }

  Future<void> clearRecentlyViewed() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('recentlyViewed');
  }

  Future<List<Recipe>> getFavourites() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favoriteIds = prefs.getStringList(_favoritesKey) ?? [];
    _favourites.clear();
    for (String id in favoriteIds) {
      var recipe = await getRecipeById(id);
      if (recipe != null) {
        _favourites.add(recipe);
      }
    }
    return List.from(_favourites);
  }

  Future<void> addFavourite(String recipeId) async {
    final prefs = await SharedPreferences.getInstance();
    var recipe = await getRecipeById(recipeId);
    if (recipe != null && !_favourites.contains(recipe)) {
      // Retrieve the current list of favorite IDs
      List<String> favoriteIds = prefs.getStringList(_favoritesKey) ?? [];
      favoriteIds.add(recipe.id);
      await prefs.setStringList(_favoritesKey, favoriteIds);
    }
  }

  Future<Recipe?> getRecipeById(String recipeId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var favoriteIds = prefs.getStringList(_favoritesKey) ?? [];
      if (favoriteIds.contains(recipeId)) {
        // If the recipe is in favorites, return it
        return SampleData.featuredRecipes.firstWhere(
          (recipe) => recipe.id == recipeId,
        );
      }
      return SampleData.featuredRecipes.firstWhere(
        (recipe) => recipe.id == recipeId,
      );
    } catch (e) {
      return null;
    }
  }

  Future<void> removeFavourite(String recipeId) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> favoriteIds = prefs.getStringList(_favoritesKey) ?? [];
    if (favoriteIds.contains(recipeId)) {
      favoriteIds.remove(recipeId);
      await prefs.setStringList(_favoritesKey, favoriteIds);
    }
    _favourites.removeWhere((recipe) => recipe.id == recipeId);
  }

  Future<List<Recipe>> searchRecipes(String queryParam) async {
    if (queryParam.isEmpty) {
      return SampleData.featuredRecipes;
    }
    final lowercaseQuery = queryParam.toLowerCase();

    return SampleData.featuredRecipes.where((recipe) {
      final lowercaseTitle = recipe.title.toLowerCase();
      final lowercaseDescription = recipe.description.toLowerCase();
      final lowercaseCategory = recipe.category.toLowerCase();

      final lowercaseIngredients = recipe.ingredients.any(
        (ingredient) => ingredient.name.toLowerCase().contains(lowercaseQuery),
      );

      return lowercaseTitle.contains(lowercaseQuery) ||
          lowercaseDescription.contains(lowercaseQuery) ||
          lowercaseIngredients ||
          lowercaseCategory.contains(lowercaseQuery);
    }).toList();
  }

  Future<List<Recipe>> getRecipesByCategory(String category) async {
    return SampleData.featuredRecipes
        .where((recipe) => recipe.category == category)
        .toList();
  }

  Future<List<String>> getCategories() async {
    return SampleData.featuredRecipes
        .map((recipe) => recipe.category)
        .toSet()
        .toList();
  }

  Future<bool> isFavorite(String recipeId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_favoritesKey) ?? [];
    return favorites.contains(recipeId);
  }
}
