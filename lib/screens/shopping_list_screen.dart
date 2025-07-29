import 'package:flutter/material.dart';
import 'package:recipe_book_app/model/recipe.dart';
import 'package:recipe_book_app/services/services.dart';
import 'package:recipe_book_app/style/app_colors.dart';
import 'package:recipe_book_app/widgets/common/extension/extensions.dart';
import 'package:recipe_book_app/widgets/shopping_list_card.dart';

class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  ShoppingListScreenState createState() => ShoppingListScreenState();
}

class ShoppingListScreenState extends State<ShoppingListScreen> {
  List<Recipe> recipe = [];
  bool isLoading = true;
  Map<String, bool> purchasedItems = {};
  final RecipeService _recipeService = RecipeService();

  @override
  void initState() {
    super.initState();
    loadShoppingList();
  }

  Future<void> loadShoppingList() async {
    try {
      final loadShoppingList = await _recipeService.getShoppingList();
      setState(() {
        recipe = loadShoppingList;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (context.mounted) {
        // ignore: use_build_context_synchronously
        context.showErrorSnackBar('Error loading shopping list: $e');
      }
    }
  }

  void removeFromShoppingList(BuildContext context, String recipeId) async {
    try {
      await _recipeService.removeFromShoppingList(recipeId);
      await loadShoppingList();
    } catch (e) {
      if (context.mounted) {
        context.showErrorSnackBar('Error removing item: $e');
      }
    }
  }

  void togglePurchased(String ingredientKey) {
    setState(() {
      purchasedItems[ingredientKey] = !(purchasedItems[ingredientKey] ?? false);
    });
  }

  int get totalItems {
    return recipe.fold(0, (sum, meal) => sum + meal.ingredients.length);
  }

  int get purchasedCount {
    return purchasedItems.values.where((purchased) => purchased).length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Shopping List',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),

        elevation: 0,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '$purchasedCount/$totalItems',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
      body:
          isLoading
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Colors.green[600]),
                    SizedBox(height: 16),
                    Text(
                      'Loading your shopping list...',
                      style: TextStyle(color: Colors.grey[600], fontSize: 16),
                    ),
                  ],
                ),
              )
              : recipe.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_cart_outlined,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No meals found',
                      style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                    ),
                  ],
                ),
              )
              : RefreshIndicator(
                onRefresh: loadShoppingList,
                color: AppColor.primary,
                child: ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: recipe.length,
                  itemBuilder: (context, index) {
                    return ShoppingRecipeCard(
                      recipe: recipe[index],
                      purchasedItems: purchasedItems,
                      onTogglePurchased: togglePurchased,
                      onRemoveFromShoppingList:
                          () =>
                              removeFromShoppingList(context, recipe[index].id),
                    );
                  },
                ),
              ),
    );
  }
}
