import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:recipe_book_app/data/sample_data.dart';
import 'package:recipe_book_app/model/recipe.dart';

class RecipeListScreen extends StatelessWidget {
  final List<Recipe> recipes = SampleData.featuredRecipes.toList();

  RecipeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('All Recipes')),
      body: ListView.builder(
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          final recipe = recipes[index];

          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(recipe.imageUrl),
            ),
            title: Text(recipe.title),
            subtitle: Text(
              '${recipe.cookTimeMinutes} min • ${recipe.difficulty}',
            ),
            onTap: () {
              log("Navigating to detail for: ${recipe.title}");
              // Send data when navigating - like writing an address on an envelope
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
          );
        },
      ),
    );
  }
}
