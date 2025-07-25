// widgets/common/responsive_navigation.dart
import 'package:flutter/material.dart';
import 'package:recipe_book_app/screens/favorite_screen.dart';
import 'package:recipe_book_app/screens/home_screen.dart';
import 'package:recipe_book_app/screens/profile_screen.dart';
import 'package:recipe_book_app/screens/recipe_list_screen.dart';
import 'package:recipe_book_app/utils/reponsive_breakpoints.dart';

class ResponsiveNavigation extends StatefulWidget {
  const ResponsiveNavigation({super.key});

  @override
  ResponsiveNavigationState createState() => ResponsiveNavigationState();
}

class ResponsiveNavigationState extends State<ResponsiveNavigation> {
  int selectedIndex = 0;

  final List<AppNavigationDestination> destinations = [
    AppNavigationDestination(
      label: 'Home',
      icon: Icons.home_outlined,
      selectedIcon: Icons.home,
      page: HomeScreen(),
    ),
    AppNavigationDestination(
      label: 'Recipes',
      icon: Icons.restaurant_outlined,
      selectedIcon: Icons.restaurant,
      page: RecipeListScreen(),
    ),
    AppNavigationDestination(
      label: 'Favorites',
      icon: Icons.favorite_outline,
      selectedIcon: Icons.favorite,
      page: FavoritesScreen(),
    ),
    AppNavigationDestination(
      label: 'Profile',
      icon: Icons.person_outline,
      selectedIcon: Icons.person,
      page: ProfileScreen(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    if (ResponsiveBreakpoints.isDesktop(context)) {
      return _buildDesktopLayout();
    } else if (ResponsiveBreakpoints.isTablet(context)) {
      return _buildTabletLayout();
    } else {
      return _buildMobileLayout();
    }
  }

  Widget _buildDesktopLayout() {
    return Scaffold(
      body: Row(
        children: [
          _buildCustomNavigationSidebar(),
          VerticalDivider(thickness: 1, width: 1),
          Expanded(child: destinations[selectedIndex].page),
        ],
      ),
    );
  }

  Widget _buildCustomNavigationSidebar() {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: Offset(2, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header/Logo Section
          Container(
            padding: EdgeInsets.all(24),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).primaryColor,
                        Theme.of(context).primaryColor.withValues(alpha: 0.7),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.restaurant_menu,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  'Recipe App',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          // Navigation Items
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 12),
              itemCount: destinations.length,
              itemBuilder: (context, index) {
                final destination = destinations[index];
                final isSelected = selectedIndex == index;

                return Container(
                  margin: EdgeInsets.only(bottom: 4),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => _onDestinationSelected(index),
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isSelected
                                  ? Theme.of(
                                    context,
                                  ).primaryColor.withValues(alpha: 0.1)
                                  : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          border:
                              isSelected
                                  ? Border.all(
                                    color: Theme.of(
                                      context,
                                    ).primaryColor.withValues(alpha: 0.2),
                                    width: 1,
                                  )
                                  : null,
                        ),
                        child: Row(
                          children: [
                            AnimatedContainer(
                              duration: Duration(milliseconds: 200),
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color:
                                    isSelected
                                        ? Theme.of(context).primaryColor
                                        : Theme.of(
                                          context,
                                        ).primaryColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                destination.icon,
                                color:
                                    isSelected
                                        ? Colors.white
                                        : Theme.of(context).primaryColor,
                                size: 20,
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                destination.label,
                                style: Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.copyWith(
                                  color:
                                      isSelected
                                          ? Theme.of(context).primaryColor
                                          : Theme.of(
                                            context,
                                          ).textTheme.bodyMedium?.color,
                                  fontWeight:
                                      isSelected
                                          ? FontWeight.w600
                                          : FontWeight.normal,
                                ),
                              ),
                            ),
                            if (isSelected)
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabletLayout() {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: selectedIndex,
            onDestinationSelected: _onDestinationSelected,
            destinations: destinations.map(_buildRailDestination).toList(),
          ),
          VerticalDivider(thickness: 1, width: 1),
          Expanded(child: destinations[selectedIndex].page),
        ],
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Scaffold(
      body: destinations[selectedIndex].page,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: _onDestinationSelected,
        destinations: destinations.map(_buildBottomDestination).toList(),
      ),
    );
  }

  NavigationRailDestination _buildRailDestination(
    AppNavigationDestination dest,
  ) {
    return NavigationRailDestination(
      icon: Icon(dest.icon),
      selectedIcon: Icon(dest.selectedIcon),
      label: Text(dest.label),
    );
  }

  NavigationDestination _buildBottomDestination(AppNavigationDestination dest) {
    return NavigationDestination(
      icon: Icon(dest.icon),
      selectedIcon: Icon(dest.selectedIcon),
      label: dest.label,
    );
  }

  void _onDestinationSelected(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
}

class AppNavigationDestination {
  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final Widget page;

  const AppNavigationDestination({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.page,
  });
}
