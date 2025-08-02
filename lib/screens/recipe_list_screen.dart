import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:recipe_book_app/data/sample_data.dart';
import 'package:recipe_book_app/model/recipe.dart';
import 'package:recipe_book_app/utils/reponsive_breakpoints.dart';
import 'package:recipe_book_app/widgets/app_drawer.dart';
import 'package:recipe_book_app/widgets/common/extension/extensions.dart';

class RecipeListScreen extends StatefulWidget {
  const RecipeListScreen({super.key});

  @override
  State<RecipeListScreen> createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  final List<Recipe> _allRecipes = SampleData.featuredRecipes.toList();
  List<Recipe> _filteredRecipes = [];

  bool _showSearchField = false;
  final _searchController = TextEditingController();

  // Filter options

  String _selectedCategory = 'All';
  final List<String> _availableCategories = ['All'];

  @override
  void initState() {
    super.initState();
    _filteredRecipes = _allRecipes;
    _searchController.addListener(_onSearchChanged);

    final categories =
        _allRecipes.map((recipe) => recipe.category).toSet().toList();
    categories.sort(); // Sort alphabetically
    _availableCategories.addAll(categories);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _applyFilters();
  }

  void _applyFilters() {
    setState(() {
      _filteredRecipes =
          _allRecipes.where((recipe) {
            // Search filter
            bool matchesSearch = true;
            if (_searchController.text.isNotEmpty) {
              final searchTerm = _searchController.text.toLowerCase();
              matchesSearch =
                  recipe.title.toLowerCase().contains(searchTerm) ||
                  recipe.ingredients.any(
                    (ingredient) =>
                        ingredient.name.toLowerCase().contains(searchTerm),
                  ) ||
                  recipe.instructions.any(
                    (instruction) =>
                        instruction.toLowerCase().contains(searchTerm),
                  );
            }

            // Category filter
            bool matchesCategory =
                _selectedCategory == 'All' ||
                recipe.category == _selectedCategory;

            return matchesSearch && matchesCategory;
          }).toList();
    });
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Filter by Category'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Category:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      items:
                          _availableCategories
                              .map(
                                (category) => DropdownMenuItem(
                                  value: category,
                                  child: Text(category),
                                ),
                              )
                              .toList(),
                      onChanged: (value) {
                        setDialogState(() {
                          _selectedCategory = value!;
                          _applyFilters();
                          Navigator.pop(context);
                        });
                      },
                    ),
                    // const SizedBox(height: 16),

                    // // Show count for each category
                    // const Text(
                    //   'Recipes per category:',
                    //   style: TextStyle(fontWeight: FontWeight.bold),
                    // ),
                    // const SizedBox(height: 8),
                    // ...(_availableCategories.where((cat) => cat != 'All').map((
                    //   category,
                    // ) {
                    //   final count =
                    //       _allRecipes
                    //           .where((recipe) => recipe.category == category)
                    //           .length;
                    //   return Padding(
                    //     padding: const EdgeInsets.symmetric(vertical: 2),
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //       children: [
                    //         Text(category),
                    //         Text(
                    //           '$count recipes',
                    //           style: TextStyle(color: Colors.grey[600]),
                    //         ),
                    //       ],
                    //     ),
                    //   );
                    // })),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _clearFilters() {
    setState(() {
      _selectedCategory = 'All';
      _searchController.clear();
      _showSearchField = false;
    });
    _applyFilters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            _showSearchField
                ? SizedBox(
                  height: 40,
                  child: TextField(
                    controller: _searchController,
                    autofocus: true,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      hintText: 'Search recipes...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      suffixIcon:
                          _searchController.text.isNotEmpty
                              ? IconButton(
                                icon: const Icon(Icons.clear, size: 20),
                                onPressed: () {
                                  _searchController.clear();
                                },
                              )
                              : null,
                    ),
                  ),
                )
                : const Text('All Recipes'),
        actionsPadding: const EdgeInsets.only(right: 10),
        actions: [
          InkWell(
            onTap: () {
              setState(() {
                _showSearchField = !_showSearchField;
                if (!_showSearchField) {
                  _searchController.clear();
                }
              });
            },
            child: Icon(
              _showSearchField ? Icons.close : Icons.search,
              size: 28,
            ),
          ),
          const SizedBox(width: 8),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.filter_list, size: 28),
                onPressed: _showFilterDialog,
              ),
              if (_selectedCategory != "All")
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      drawer:
          ResponsiveBreakpoints.isMobile(context) ? const AppDrawer() : null,
      body: Column(
        children: [
          // Filter summary bar
          if (_searchController.text.isNotEmpty)
            // Results count
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Text(
                    '${_filteredRecipes.length} recipe${_filteredRecipes.length != 1 ? 's' : ''} found',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),

          // Recipe list
          Expanded(
            child:
                _filteredRecipes.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No recipes found',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Try adjusting your search or filters',
                            style: TextStyle(color: Colors.grey[500]),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _clearFilters,
                            child: const Text('Clear Filters'),
                          ),
                        ],
                      ),
                    )
                    : ListView.builder(
                      itemCount: _filteredRecipes.length,
                      itemBuilder: (context, index) {
                        final recipe = _filteredRecipes[index];

                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: CachedNetworkImageProvider(
                              recipe.imageUrl.getCorsProxyUrl(),
                            ),
                          ),
                          title: Text(recipe.title),
                          subtitle: Text(
                            '${recipe.cookTimeMinutes} min • ${recipe.difficulty}',
                          ),
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
                          },
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
