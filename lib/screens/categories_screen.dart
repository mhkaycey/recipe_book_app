import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:recipe_book_app/model/recipe.dart';
import 'package:recipe_book_app/services/services.dart';

class CategoryRecipesScreen extends StatefulWidget {
  final String category;

  const CategoryRecipesScreen({super.key, required this.category});

  @override
  CategoryRecipesScreenState createState() => CategoryRecipesScreenState();
}

class CategoryRecipesScreenState extends State<CategoryRecipesScreen> {
  late Future<List<Recipe>> _recipesFuture;
  final RecipeService _recipeService = RecipeService();

  @override
  void initState() {
    super.initState();
    // Assuming you have a method to get recipes by category
    _recipesFuture = _recipeService.getRecipesByCategory(widget.category);
    log('Fetching recipes for category: ${widget.category}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.category} Recipes')),
      body: FutureBuilder<List<Recipe>>(
        future: _recipesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, size: 64, color: Colors.red),
                  SizedBox(height: 16),
                  Text('Failed to load recipes'),
                  SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _recipesFuture = _recipeService.getRecipesByCategory(
                          widget.category,
                        );
                      });
                    },
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          } else {
            final recipes = snapshot.data ?? [];
            if (recipes.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.restaurant, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text('No recipes found in ${widget.category}'),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: recipes.length,
              itemBuilder: (context, index) {
                final recipe = recipes[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child:
                            recipe.imageUrl.isNotEmpty
                                ? CachedNetworkImage(
                                  imageUrl: recipe.imageUrl,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                )
                                : Container(
                                  width: 80,
                                  height: 80,
                                  color: Colors.grey[300],
                                  child: Icon(Icons.restaurant, size: 40),
                                ),
                      ),
                      // SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.errorContainer,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(8),
                              bottomRight: Radius.circular(8),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 4,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  recipe.title,
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                SizedBox(height: 4),
                                Text(
                                  '${recipe.cookTimeMinutes} min | ${recipe.servings} servings',
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Icon(Icons.arrow_forward_ios, size: 16),
                      // SizedBox(width: 8),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
