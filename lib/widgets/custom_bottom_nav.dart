import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/routes.dart';
import '../../core/theme/app_theme.dart';

class CustomBottomNav extends StatelessWidget {
  final String current;

  const CustomBottomNav({super.key, required this.current});

  void _navigate(BuildContext context, String route) {
    if (current != route) {
      context.go(route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _getIndex(current),
      onTap: (index) {
        final routes = [
          Routes.mood,
          Routes.home,
          Routes.progress,
          Routes.profile,
        ];
        _navigate(context, routes[index]);
      },
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.transparent,
      selectedItemColor: AppTheme.primary,
      unselectedItemColor: Colors.grey[400],
      elevation: 0,
      items: [
        _buildNavItem(Icons.emoji_emotions_outlined, 'Mood'),
        _buildNavItem(Icons.task_alt, 'Tasks'),
        _buildNavItem(Icons.trending_up, 'Stats'),
        _buildNavItem(Icons.person_outline, 'Me'),
      ],
    );
  }

  BottomNavigationBarItem _buildNavItem(IconData icon, String label) {
    return BottomNavigationBarItem(icon: Icon(icon), label: label);
  }

  int _getIndex(String route) {
    switch (route) {
      case Routes.mood:
        return 0;
      case Routes.home:
        return 1;
      case Routes.progress:
        return 2;
      case Routes.profile:
        return 3;
      default:
        return 0;
    }
  }
}
