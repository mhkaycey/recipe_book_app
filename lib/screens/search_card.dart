import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:recipe_book_app/model/recipe.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;

  const RecipeCard({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                recipe.imageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image_not_supported),
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            // Title
            Text(
              recipe.title,
              style: Theme.of(context).textTheme.headlineSmall,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 8),

            // Description - Use Flexible instead of Expanded
            Flexible(
              fit:
                  FlexFit
                      .loose, // This allows the widget to take only the space it needs
              child: Text(
                recipe.description,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            const SizedBox(height: 12),

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Prep: ${recipe.cookTimeMinutes}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                ElevatedButton(
                  onPressed: () {
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
                  },
                  child: const Text('View Recipe'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
