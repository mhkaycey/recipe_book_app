import 'package:flutter/material.dart';
import 'package:recipe_book_app/model/recipe.dart';
import 'package:recipe_book_app/style/app_colors.dart';

class ShoppingRecipeCard extends StatefulWidget {
  final Recipe recipe;
  final Map<String, bool> purchasedItems;
  final Function(String) onTogglePurchased;
  final Function() onRemoveFromShoppingList;

  const ShoppingRecipeCard({
    super.key,
    required this.recipe,
    required this.purchasedItems,
    required this.onTogglePurchased,
    required this.onRemoveFromShoppingList,
  });

  @override
  State<ShoppingRecipeCard> createState() => _ShoppingRecipeCardState();
}

class _ShoppingRecipeCardState extends State<ShoppingRecipeCard> {
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
                    color: Theme.of(context).primaryColor,
                    size: 28,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Text(
                    widget.recipe.title,
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
                    '${widget.recipe.ingredients.length} items',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                IconButton(
                  onPressed: widget.onRemoveFromShoppingList,
                  tooltip: 'Remove from Shopping List',
                  icon: Icon(Icons.delete_outline, color: Colors.white),
                ),
              ],
            ),
          ),
          // Ingredients List
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children:
                  widget.recipe.ingredients.map((ingredient) {
                    final ingredientKey =
                        '${widget.recipe.id}_${ingredient.name}';
                    final isPurchased =
                        widget.purchasedItems[ingredientKey] ?? false;

                    return Container(
                      margin: EdgeInsets.only(bottom: 8),
                      child: InkWell(
                        onTap: () => widget.onTogglePurchased(ingredientKey),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color:
                                isPurchased
                                    ? Colors.green[50]
                                    : Colors.transparent,

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
