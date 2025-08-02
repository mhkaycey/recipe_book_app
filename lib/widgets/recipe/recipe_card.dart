import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:recipe_book_app/model/recipe.dart';
import 'package:recipe_book_app/services/services.dart';
import 'package:recipe_book_app/utils/reponsive_breakpoints.dart';
import 'package:recipe_book_app/widgets/common/extension/extensions.dart';

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
      if (mounted) {
        setState(() {
          widget.isFavorite = isFav;
        });
      }
    });
  }

  // Enhanced responsive dimensions
  double _getImageHeight(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;

    if (ResponsiveBreakpoints.isMobile(context)) {
      // Mobile: Use percentage of screen width for consistent aspect ratio
      return screenWidth * 0.6; // 60% of screen width
    } else if (ResponsiveBreakpoints.isTablet(context)) {
      // Tablet: Balanced height considering both width and screen size
      return screenWidth > 600 ? 180 : 160;
    } else {
      // Desktop: Fixed height but responsive to screen size
      return screenHeight > 800 ? 220 : 180;
    }
  }

  double _getCardPadding(BuildContext context) {
    if (ResponsiveBreakpoints.isMobile(context)) {
      return 8.0;
    } else if (ResponsiveBreakpoints.isTablet(context)) {
      return 12.0;
    } else {
      return 16.0;
    }
  }

  double _getTitleFontSize(BuildContext context) {
    if (ResponsiveBreakpoints.isMobile(context)) {
      return 14.0;
    } else if (ResponsiveBreakpoints.isTablet(context)) {
      return 16.0;
    } else {
      return 18.0;
    }
  }

  double _getDescriptionFontSize(BuildContext context) {
    if (ResponsiveBreakpoints.isMobile(context)) {
      return 11.0;
    } else if (ResponsiveBreakpoints.isTablet(context)) {
      return 12.0;
    } else {
      return 13.0;
    }
  }

  double _getIconSize(BuildContext context) {
    if (ResponsiveBreakpoints.isMobile(context)) {
      return 12.0;
    } else if (ResponsiveBreakpoints.isTablet(context)) {
      return 14.0;
    } else {
      return 16.0;
    }
  }

  double _getChipFontSize(BuildContext context) {
    if (ResponsiveBreakpoints.isMobile(context)) {
      return 10.0;
    } else if (ResponsiveBreakpoints.isTablet(context)) {
      return 11.0;
    } else {
      return 12.0;
    }
  }

  int _getMaxTitleLines(BuildContext context) {
    return ResponsiveBreakpoints.isMobile(context) ? 2 : 1;
  }

  int _getMaxDescriptionLines(BuildContext context) {
    if (ResponsiveBreakpoints.isMobile(context)) {
      return 3;
    } else if (ResponsiveBreakpoints.isTablet(context)) {
      return 2;
    } else {
      return 2;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cardPadding = _getCardPadding(context);
    final isLargeScreen = !ResponsiveBreakpoints.isMobile(context);

    return Card(
      elevation: isLargeScreen ? 6 : 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,

          children: [
            _buildImage(context),
            Flexible(
              fit: FlexFit.tight,
              child: Padding(
                padding: EdgeInsets.all(
                  cardPadding * (isLargeScreen ? 1.5 : 1.0),
                ).copyWith(bottom: cardPadding * 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title with responsive sizing
                    Text(
                      widget.recipe.title,
                      style: TextStyle(
                        fontSize: _getTitleFontSize(context),
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: _getMaxTitleLines(context),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: cardPadding * 0.3),

                    // Description with responsive sizing
                    Expanded(
                      flex: ResponsiveBreakpoints.isMobile(context) ? 2 : 1,
                      child: Text(
                        widget.recipe.description,
                        style: TextStyle(
                          fontSize: _getDescriptionFontSize(context),
                          color: Colors.grey[600],
                        ),
                        maxLines: _getMaxDescriptionLines(context),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    SizedBox(height: cardPadding * 0.5),

                    // Responsive info row
                    _buildInfoRow(context),
                    SizedBox(height: cardPadding * 0.5),
                    // Dietary tags with responsive layout
                    if (_hasDietaryTags())
                      Padding(
                        padding: EdgeInsets.only(top: cardPadding * 0.3),
                        child: _buildDietaryTags(context),
                      ),
                    SizedBox(height: cardPadding * 1),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    final imageHeight = _getImageHeight(context);
    final isMobile = ResponsiveBreakpoints.isMobile(context);

    return Stack(
      children: [
        Container(
          padding: EdgeInsets.zero,
          height: imageHeight,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            child: CachedNetworkImage(
              imageUrl: widget.recipe.imageUrl.getCorsProxyUrl(),
              fit: BoxFit.cover,
              placeholder:
                  (context, url) => Container(
                    color: Colors.grey[200],
                    child: Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
              errorWidget:
                  (context, url, error) => Container(
                    color: Colors.grey[200],
                    child: Icon(
                      Icons.image_not_supported,
                      color: Colors.grey[400],
                      size: isMobile ? 40 : 50,
                    ),
                  ),
            ),
          ),
        ),
        Positioned(
          top: isMobile ? 6 : 8,
          right: isMobile ? 6 : 8,
          child: _buildFavoriteButton(context),
        ),
        Positioned(
          bottom: isMobile ? 6 : 8,
          left: isMobile ? 6 : 8,
          child: _buildDifficultyBadge(context),
        ),
      ],
    );
  }

  Widget _buildInfoRow(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.isMobile(context);

    if (isMobile) {
      // Stack info chips vertically on mobile if needed
      return Column(
        spacing: 12,
        children: [
          Row(
            children: [
              _buildInfoChip(
                context: context,
                icon: Icons.timer,
                label: '${widget.recipe.totalTimeMinutes}min',
                color: Colors.blue,
              ),
              SizedBox(width: 8),
              _buildInfoChip(
                context: context,
                icon: Icons.people,
                label: '${widget.recipe.servings}',
                color: Colors.green,
              ),
              Spacer(),
              _buildRating(context),
            ],
          ),
        ],
      );
    } else {
      // Horizontal layout for tablet and desktop
      return Row(
        children: [
          _buildInfoChip(
            context: context,
            icon: Icons.timer,
            label: '${widget.recipe.totalTimeMinutes}min',
            color: Colors.blue,
          ),
          SizedBox(width: 12),
          _buildInfoChip(
            context: context,
            icon: Icons.people,
            label: '${widget.recipe.servings}',
            color: Colors.green,
          ),
          Spacer(),
          _buildRating(context),
        ],
      );
    }
  }

  Widget _buildRating(BuildContext context) {
    final iconSize = _getIconSize(context);
    final fontSize = _getChipFontSize(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.star, color: Colors.amber, size: iconSize),
        SizedBox(width: 2),
        Text(
          widget.recipe.rating.toStringAsFixed(1),
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: fontSize),
        ),
      ],
    );
  }

  Widget _buildFavoriteButton(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.isMobile(context);
    final size = isMobile ? 36.0 : 40.0;
    final iconSize = isMobile ? 20.0 : 24.0;

    return InkWell(
      onTap: () {
        RecipeService().addFavourite(widget.recipe.id);
        if (mounted) {
          setState(() {
            widget.isFavorite = !widget.isFavorite;
          });
        }
      },
      borderRadius: BorderRadius.circular(size / 2),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          widget.isFavorite ? Icons.favorite : Icons.favorite_border,
          color: widget.isFavorite ? Colors.red : Colors.grey[600],
          size: iconSize,
        ),
      ),
    );
  }

  bool _hasDietaryTags() {
    return widget.recipe.isQuickMeal ||
        widget.recipe.isVegetarian ||
        widget.recipe.isVegan ||
        widget.recipe.isGlutenFree;
  }

  Widget _buildDietaryTags(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.isMobile(context);

    return Wrap(
      spacing: isMobile ? 3 : 4,
      runSpacing: isMobile ? 2 : 3,
      children: [
        if (widget.recipe.isQuickMeal)
          _buildTag(context, 'Quick', Colors.green[600]!),
        if (widget.recipe.isVegan)
          _buildTag(context, 'Vegan', Colors.green[700]!),
        if (!widget.recipe.isVegan && widget.recipe.isVegetarian)
          _buildTag(context, 'Vegetarian', Colors.green[600]!),
        if (widget.recipe.isGlutenFree)
          _buildTag(context, 'GF', Colors.orange[600]!),
      ],
    );
  }

  Widget _buildTag(BuildContext context, String text, Color color) {
    final isMobile = ResponsiveBreakpoints.isMobile(context);
    final fontSize = isMobile ? 9.0 : 10.0;
    final padding = isMobile ? 6.0 : 8.0;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: padding, vertical: 3),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildDifficultyBadge(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.isMobile(context);
    final fontSize = isMobile ? 9.0 : 10.0;
    final padding = isMobile ? 6.0 : 8.0;

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
      padding: EdgeInsets.symmetric(horizontal: padding, vertical: 3),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Text(
        widget.recipe.difficulty.toUpperCase(),
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildInfoChip({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color color,
  }) {
    final isMobile = ResponsiveBreakpoints.isMobile(context);
    final iconSize = _getIconSize(context);
    final fontSize = _getChipFontSize(context);
    final padding = isMobile ? 6.0 : 8.0;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: padding, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: iconSize, color: color),
          SizedBox(width: 3),
          Text(
            label,
            style: TextStyle(
              fontSize: fontSize,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
