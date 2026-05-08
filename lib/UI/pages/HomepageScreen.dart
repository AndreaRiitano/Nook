import 'package:flutter/material.dart';
import 'Explore.dart';
import 'Search.dart';
import 'Profile.dart';
import '../aspects/AppTheme.dart';

class HomepageScreen extends StatefulWidget {
  const HomepageScreen({super.key});

  @override
  State<HomepageScreen> createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final navBarColor = isDark ? const Color(0xFF333333) : Colors.white;
    final iconColor = theme.colorScheme.onSurface;

    return Scaffold(
      extendBody: true,
      backgroundColor: theme.scaffoldBackgroundColor,

      body: Stack(
        children: [
          Positioned.fill(child: _getCurrentPage()),

          Positioned(
            left: 10,
            right: 10,
            bottom: 0,
            child: Container(
              margin: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  bottom: 15 + MediaQuery.of(context).padding.bottom
              ),
              height: 55,
              decoration: BoxDecoration(
                color: navBarColor,
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  BoxShadow(
                    color: isDark ? Colors.black.withValues(alpha: 0.5) : Colors.black.withValues(alpha: 0.2),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: Icon(
                      _currentIndex == 0 ? Icons.explore_rounded : Icons.explore_outlined,
                      color: iconColor,
                    ),
                    onPressed: () {
                      setState(() { _currentIndex = 0; });
                    },
                  ),

                  IconButton(
                    icon: Icon(
                      _currentIndex == 1 ? Icons.search_rounded : Icons.search_outlined,
                      color: iconColor,
                    ),
                    onPressed: () {
                      setState(() { _currentIndex = 1; });
                    },
                  ),

                  IconButton(
                    icon: Icon(
                      _currentIndex == 2 ? Icons.person_rounded : Icons.person_outline,
                      color: iconColor,
                    ),
                    onPressed: () {
                      setState(() { _currentIndex = 2; });
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExplorePage() => const Explore();
  Widget _buildOrderPage() => const Search();
  Widget _buildProfilePage() => const Profile();

  Widget _getCurrentPage() {
    switch (_currentIndex) {
      case 0: return _buildExplorePage();
      case 1: return _buildOrderPage();
      case 2: return _buildProfilePage();
      default: return _buildExplorePage();
    }
  }
}