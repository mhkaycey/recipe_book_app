import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:recipe_book_app/data/sample_data.dart';
import 'package:recipe_book_app/model/recipe.dart';
import 'package:recipe_book_app/services/services.dart';
import 'package:recipe_book_app/utils/reponsive_breakpoints.dart';
import 'package:recipe_book_app/widgets/app_drawer.dart';
import 'package:recipe_book_app/widgets/common/badge.dart';
import 'package:recipe_book_app/widgets/recipe/responsive_recipe_grid.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final RecipeService _recipeService = RecipeService();
  bool _showSearchField = false;
  final _controller = TextEditingController();
  // Timer? _debounce;
  List<Recipe> searchResults = [];

  List<String> _categories = [];
  bool _categoriesLoading = true;
  String? _categoriesError;

  Future<void> _loadCategories() async {
    try {
      final categories = await _recipeService.getCategories();
      if (mounted) {
        setState(() {
          _categories = categories;
          _categoriesLoading = false;
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _categoriesError = 'Failed to load categories';
          _categoriesLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    _recipeService.getShoppingList();
    _loadCategories();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      drawer: ResponsiveBreakpoints.isMobile(context) ? AppDrawer() : null,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          spacing: 32,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroSection(context),
            _buildQuickCategories(context),

            _buildFeaturedRecipes(context),

            _buildRecentlyViewed(context),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title:
          _showSearchField
              ? SizedBox(
                height: 40,
                child: TextField(
                  controller: _controller,
                  autofocus: true,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    hintText: 'Search recipes...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                  ),

                  onSubmitted: (value) {
                    if (value.isNotEmpty) {
                      Navigator.pushNamed(context, '/search', arguments: value);
                    }
                  },
                ),
              )
              : Text('Recipe Book'),
      actionsPadding: EdgeInsets.only(right: 10),
      actions: [
        InkWell(
          onTap:
              () => setState(() {
                _showSearchField = !_showSearchField;
                if (!_showSearchField) {
                  _controller.clear();
                }
              }),
          child: Icon(_showSearchField ? Icons.close : Icons.search),
        ),

        SimpleBadge(
          showBadge: true,
          value: _recipeService.shopList.length.toString(),
          color: Colors.red,
          child: IconButton(
            icon: Icon(Icons.shopping_cart_outlined),
            onPressed: () => _navigateToShoppingList(context),
          ),
        ),
      ],
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Container(
      height: ResponsiveBreakpoints.isMobile(context) ? 230 : 300,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.orange[400]!, Colors.deepOrange[600]!],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to Recipe Book',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Discover amazing recipes for every occasion',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.white.withValues(alpha: 0.9),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _exploreRecipes(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.orange[600],
              ),
              child: Text('Explore Recipes'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedRecipes(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Featured Recipes',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () => _viewAllRecipes(context),
              child: Text('View All'),
            ),
          ],
        ),
        SizedBox(height: 16),

        ResponsiveRecipeGrid(
          recipes: SampleData.featuredRecipes,
          maxItems: ResponsiveBreakpoints.isMobile(context) ? 4 : 6,
        ),
      ],
    );
  }

  Widget _buildRecentlyViewed(BuildContext context) {
    // Placeholder for recently viewed section
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recently Viewed',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12),
        Text(
          'You have not viewed any recipes yet.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildQuickCategories(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Categories',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        if (_categoriesLoading)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(),
            ),
          )
        else if (_categoriesError != null)
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  _categoriesError!,
                  style: TextStyle(color: Colors.red[600]),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _categoriesLoading = true;
                      _categoriesError = null;
                    });
                    _loadCategories();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          )
        else
          _buildCategoryChips(),
      ],
    );
  }

  Widget _buildCategoryChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children:
            _categories.asMap().entries.map((entry) {
              final index = entry.key;
              final category = entry.value;

              return Padding(
                padding: EdgeInsets.only(
                  left: index == 0 ? 0 : 8,
                  right: index == _categories.length - 1 ? 0 : 4,
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/recipesBycategory',
                      arguments: category,
                    );
                    log('Navigating to category: $category');
                  },
                  child: Chip(
                    label: Text(
                      category,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),

                    side: BorderSide(color: Colors.orange[200]!, width: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }

  void _navigateToShoppingList(BuildContext context) {
    // Navigate to shopping list
    Navigator.pushNamed(context, '/shopping-list');
  }

  void _exploreRecipes(BuildContext context) {
    // Navigate to recipe list

    Navigator.pushNamed(context, '/recipes');
  }

  void _viewAllRecipes(BuildContext context) {
    // Navigate to all recipes
    Navigator.pushNamed(context, '/recipes');
  }
}
