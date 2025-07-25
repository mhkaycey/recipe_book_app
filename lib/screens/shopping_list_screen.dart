import 'package:flutter/material.dart';
import 'package:recipe_book_app/model/recipe.dart';
import 'package:recipe_book_app/services/services.dart';
import 'package:recipe_book_app/style/app_colors.dart';

class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  ShoppingListScreenState createState() => ShoppingListScreenState();
}

class ShoppingListScreenState extends State<ShoppingListScreen> {
  List<Recipe> recipe = [];
  bool isLoading = true;
  Map<String, bool> purchasedItems = {};

  @override
  void initState() {
    super.initState();
    loadShoppingList();
  }

  Future<void> loadShoppingList() async {
    try {
      final loadShoppingList = await RecipeService().getShoppingList();
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading shopping list: $e')),
        );
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
      backgroundColor: Colors.grey[50],
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
                    return MealCard(
                      meal: recipe[index],
                      purchasedItems: purchasedItems,
                      onTogglePurchased: togglePurchased,
                    );
                  },
                ),
              ),
    );
  }
}

class MealCard extends StatelessWidget {
  final Recipe meal;
  final Map<String, bool> purchasedItems;
  final Function(String) onTogglePurchased;

  const MealCard({
    super.key,
    required this.meal,
    required this.purchasedItems,
    required this.onTogglePurchased,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Meal Header
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColor.primary,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.restaurant,
                    color: Colors.green[600],
                    size: 28,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Text(
                    meal.title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${meal.ingredients.length} items',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Ingredients List
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children:
                  meal.ingredients.map((ingredient) {
                    final ingredientKey = '${meal.id}_${ingredient.name}';
                    final isPurchased = purchasedItems[ingredientKey] ?? false;

                    return Container(
                      margin: EdgeInsets.only(bottom: 8),
                      child: InkWell(
                        onTap: () => onTogglePurchased(ingredientKey),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color:
                                isPurchased
                                    ? Colors.green[50]
                                    : Colors.grey[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color:
                                  isPurchased
                                      ? Colors.green[200]!
                                      : Colors.grey[200]!,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color:
                                      isPurchased
                                          ? Colors.green[600]
                                          : Colors.transparent,
                                  border: Border.all(
                                    color:
                                        isPurchased
                                            ? Colors.green[600]!
                                            : Colors.grey[400]!,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child:
                                    isPurchased
                                        ? Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 16,
                                        )
                                        : null,
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  ingredient.name,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color:
                                        isPurchased
                                            ? Colors.grey[600]
                                            : Colors.grey[800],
                                    decoration:
                                        isPurchased
                                            ? TextDecoration.lineThrough
                                            : null,
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green[100],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '${ingredient.amount} ${ingredient.unit}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.green[700],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
