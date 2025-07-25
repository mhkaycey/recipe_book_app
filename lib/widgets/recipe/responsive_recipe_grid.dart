import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:recipe_book_app/model/recipe.dart';
import 'package:recipe_book_app/utils/reponsive_breakpoints.dart';
import 'package:recipe_book_app/widgets/recipe/recipe_card.dart';

class ResponsiveRecipeGrid extends StatelessWidget {
  final List<Recipe> recipes;
  final int? maxItems;
  final Function(Recipe)? onRecipeTap;

  const ResponsiveRecipeGrid({
    super.key,
    required this.recipes,
    this.maxItems,
    this.onRecipeTap,
  });

  @override
  Widget build(BuildContext context) {
    final displayedRecipes =
        maxItems != null ? recipes.take(maxItems!).toList() : recipes;

    final crossAxisCount = ResponsiveBreakpoints.getColumns(context);
    final aspectRatio = ResponsiveBreakpoints.isMobile(context) ? 0.75 : 0.8;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: aspectRatio,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: displayedRecipes.length,
      itemBuilder: (context, index) {
        final recipe = displayedRecipes[index];
        return ResponsiveRecipeCard(
          recipe: recipe,

          onTap: () {
            log("Navigating to detail for: ${recipe.title}");
            Navigator.pushNamed(
              context,
              '/recipe-detail',
              arguments: {
                'recipeId': recipe.id,
                'recipeName': recipe.title,
                'recipeData': recipe,
              },
            );
            // onRecipeTap?.call(recipe);
          },
        );
      },
    );
  }
}
