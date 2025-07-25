import 'package:flutter/material.dart';
import 'package:recipe_book_app/model/recipe.dart';
import 'package:recipe_book_app/screens/search_card.dart';
import 'package:recipe_book_app/services/services.dart';

class SearchResultsScreen extends StatefulWidget {
  final String query;

  const SearchResultsScreen({super.key, required this.query});

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  late Future<List<Recipe>> _results;
  final RecipeService _recipeService = RecipeService();

  @override
  void initState() {
    super.initState();
    _results = _recipeService.searchRecipes(widget.query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Results for "${widget.query}"')),
      body: FutureBuilder<List<Recipe>>(
        future: _results,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No recipes found.'));
          }

          final recipes = snapshot.data!;
          // return Expanded(
          //   child: ListView.builder(
          //     itemCount: recipes.length,
          //     shrinkWrap: true,

          //     itemBuilder: (context, index) {
          //       return ResponsiveRecipeCard(recipe: recipes[index]);
          //     },
          //   ),
          // );
          // If you want to use List.generate with a Column:
          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                recipes.length,
                (index) => RecipeCard(recipe: recipes[index]),
              ),
            ),
          );
        },
      ),
    );
  }
}
