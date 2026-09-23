import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../providers/cart_provider.dart';
import '../widgets/ethnic_decorations.dart';
import 'home_screen.dart';
import 'categories_screen.dart';
import 'favorites_screen.dart';
import 'order_tracking_screen.dart';
import 'profile_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  final int initialIndex;

  const MainNavigationScreen({super.key, this.initialIndex = 0});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    final List<Widget> pages = [
      const HomeScreen(),
      const CategoriesScreen(),
      const FavoritesScreen(),
      const OrderTrackingScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: ZogbeTheme.kraftLight,
      body: pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: ZogbeTheme.darkBrown,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Frise décorative subtile au-dessus de la barre
              const EthnicChevronBorder(height: 8),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(
                      index: 0,
                      label: 'ACCUEIL',
                      icon: Icons.home,
                    ),
                    _buildNavItem(
                      index: 1,
                      label: 'CATÉGORIES',
                      icon: Icons.grid_view_rounded,
                    ),
                    _buildNavItem(
                      index: 2,
                      label: 'FAVORIS',
                      icon: Icons.favorite_border,
                    ),
                    _buildNavItem(
                      index: 3,
                      label: 'COMMANDES',
                      icon: Icons.shopping_bag_outlined,
                      badgeCount: cart.itemCount > 0 ? cart.itemCount : null,
                    ),
                    _buildNavItem(
                      index: 4,
                      label: 'COMPTE',
                      icon: Icons.person_outline,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required String label,
    required IconData icon,
    int? badgeCount,
  }) {
    final bool isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(
                icon,
                size: 24,
                color: isSelected ? ZogbeTheme.gariOrange : ZogbeTheme.kraftLight.withOpacity(0.65),
              ),
              if (badgeCount != null)
                Positioned(
                  top: -4,
                  right: -8,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      color: ZogbeTheme.gariOrange,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
                    child: Text(
                      '$badgeCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.w900 : FontWeight.w500,
              letterSpacing: 0.5,
              color: isSelected ? ZogbeTheme.gariOrange : ZogbeTheme.kraftLight.withOpacity(0.65),
            ),
          ),
        ],
      ),
    );
  }
}
