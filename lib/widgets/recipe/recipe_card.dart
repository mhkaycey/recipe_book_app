import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:recipe_book_app/model/recipe.dart';
import 'package:recipe_book_app/services/services.dart';
import 'package:recipe_book_app/utils/reponsive_breakpoints.dart';

// ignore: must_be_immutable
class ResponsiveRecipeCard extends StatefulWidget {
  final Recipe recipe;
  final VoidCallback? onTap;
  final VoidCallback? onFavorite;
  bool isFavorite;

  ResponsiveRecipeCard({
    super.key,
    required this.recipe,
    this.onTap,
    this.onFavorite,
    this.isFavorite = false,
  });

  @override
  State<ResponsiveRecipeCard> createState() => _ResponsiveRecipeCardState();
}

class _ResponsiveRecipeCardState extends State<ResponsiveRecipeCard> {
  @override
  void initState() {
    super.initState();
    RecipeService().isFavorite(widget.recipe.id).then((isFav) {
      setState(() {
        widget.isFavorite = isFav;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImage(
              context,
              height:
                  ResponsiveBreakpoints.isMobile(context)
                      ? 300
                      : ResponsiveBreakpoints.isTablet(context)
                      ? 150
                      : 300,
            ),

            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      widget.recipe.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Description
                    Expanded(
                      child: Text(
                        widget.recipe.description,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Time and Difficulty
                    Row(
                      spacing: 12,
                      children: [
                        _buildInfoChip(
                          icon: Icons.timer,
                          label: '${widget.recipe.totalTimeMinutes}min',
                          color: Colors.blue,
                        ),

                        _buildInfoChip(
                          icon: Icons.people,
                          label: '${widget.recipe.servings}',
                          color: Colors.green,
                        ),
                        const Spacer(),
                        _buildRating(),
                      ],
                    ),
                    // Quick meal indicator and dietary tags
                    if (widget.recipe.isQuickMeal ||
                        widget.recipe.isVegetarian ||
                        widget.recipe.isVegan ||
                        widget.recipe.isGlutenFree)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Wrap(
                          spacing: 4,
                          children: [
                            if (widget.recipe.isQuickMeal)
                              _buildTag('Quick', Colors.green[600]!),
                            if (widget.recipe.isVegan)
                              _buildTag('Vegan', Colors.green[700]!),
                            if (!widget.recipe.isVegan &&
                                widget.recipe.isVegetarian)
                              _buildTag('Vegetarian', Colors.green[600]!),
                            if (widget.recipe.isGlutenFree)
                              _buildTag('GF', Colors.orange[600]!),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context, {required double height}) {
    return Stack(
      children: [
        Container(
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            image: DecorationImage(
              image: CachedNetworkImageProvider(widget.recipe.imageUrl),

              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(top: 8, right: 8, child: _buildFavoriteButton()),
        Positioned(bottom: 8, left: 8, child: _buildDifficultyBadge()),
      ],
    );
  }

  Widget _buildRating() {
    return Row(
      children: [
        Icon(Icons.star, color: Colors.amber, size: 16),
        SizedBox(width: 4),
        Text(
          widget.recipe.rating.toStringAsFixed(1),
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildFavoriteButton() {
    return InkWell(
      onTap: () {
        RecipeService().addFavourite(widget.recipe.id);
        setState(() {
          widget.isFavorite = !widget.isFavorite;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          shape: BoxShape.circle,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: 40, minHeight: 40),
          child: Icon(
            widget.isFavorite ? Icons.favorite : Icons.favorite_border,
            color: widget.isFavorite ? Colors.red : Colors.grey[600],
          ),
        ),
      ),
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 10,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildDifficultyBadge() {
    Color badgeColor;
    switch (widget.recipe.difficulty.toLowerCase()) {
      case 'easy':
        badgeColor = Colors.green;
        break;
      case 'medium':
        badgeColor = Colors.orange;
        break;
      case 'hard':
        badgeColor = Colors.red;
        break;
      default:
        badgeColor = Colors.grey;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        widget.recipe.difficulty.toUpperCase(),
        style: TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
