import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../core/constants.dart';
import '../providers/dish_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/zogbe_logo.dart';
import '../widgets/dish_card.dart';
import 'dish_detail_screen.dart';
import 'cart_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dishProvider = context.watch<DishProvider>();
    final cartProvider = context.watch<CartProvider>();
    final authProvider = context.watch<AuthProvider>();

    final dishes = dishProvider.filteredDishes;

    return Scaffold(
      backgroundColor: ZogbeTheme.kraftLight,
      body: SafeArea(
        child: Column(
          children: [
            // 1. Top Bar : Logo + Localisation + Panier
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Logo Zògbé
                  const ZogbeLogo(size: 38, showText: true),

                  // Sélecteur de quartier
                  GestureDetector(
                    onTap: () => _showQuartierDialog(context, authProvider),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.location_on, color: ZogbeTheme.darkBrown, size: 20),
                        const SizedBox(width: 4),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Quartier',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: ZogbeTheme.darkBrown.withOpacity(0.7),
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  authProvider.selectedQuartier,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: ZogbeTheme.darkBrown,
                                  ),
                                ),
                                const Icon(Icons.keyboard_arrow_down, color: ZogbeTheme.darkBrown, size: 16),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Sac de shopping avec badge
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CartScreen()),
                      );
                    },
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: ZogbeTheme.darkBrown,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.shopping_bag_outlined, color: ZogbeTheme.kraftLight, size: 22),
                        ),
                        if (cartProvider.itemCount > 0)
                          Positioned(
                            top: -4,
                            right: -4,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: ZogbeTheme.gariOrange,
                                shape: BoxShape.circle,
                              ),
                              constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                              child: Text(
                                '${cartProvider.itemCount}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // 2. Barre de recherche
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFFBF7EE),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: ZogbeTheme.darkBrown.withOpacity(0.3), width: 1),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: ZogbeTheme.darkBrown, size: 22),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        onChanged: (val) => dishProvider.setSearchQuery(val),
                        style: GoogleFonts.plusJakartaSans(
                          color: ZogbeTheme.darkBrown,
                          fontSize: 14,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Rechercher un plat, un ingrédient...',
                          hintStyle: GoogleFonts.plusJakartaSans(
                            color: ZogbeTheme.darkBrown.withOpacity(0.55),
                            fontSize: 13.5,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // 3. Catégories horizontales
            SizedBox(
              height: 72,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: [
                  _buildCategoryPill(
                    context: context,
                    title: 'Pâte',
                    icon: Icons.soup_kitchen,
                    isSelected: dishProvider.selectedCategory == 'Pâte',
                    onTap: () => dishProvider.setCategory('Pâte'),
                  ),
                  _buildCategoryPill(
                    context: context,
                    title: 'Riz',
                    icon: Icons.rice_bowl,
                    isSelected: dishProvider.selectedCategory == 'Riz',
                    onTap: () => dishProvider.setCategory('Riz'),
                  ),
                  _buildCategoryPill(
                    context: context,
                    title: 'Sauces',
                    icon: Icons.local_dining,
                    isSelected: dishProvider.selectedCategory == 'Sauces',
                    onTap: () => dishProvider.setCategory('Sauces'),
                  ),
                  _buildCategoryPill(
                    context: context,
                    title: 'Grillades',
                    icon: Icons.kebab_dining,
                    isSelected: dishProvider.selectedCategory == 'Grillades',
                    onTap: () => dishProvider.setCategory('Grillades'),
                  ),
                  _buildCategoryPill(
                    context: context,
                    title: 'Boissons',
                    icon: Icons.local_drink,
                    isSelected: dishProvider.selectedCategory == 'Boissons',
                    onTap: () => dishProvider.setCategory('Boissons'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 6),

            // 4. Grille de plats (2 colonnes)
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => dishProvider.fetchDishes(),
                color: ZogbeTheme.gariOrange,
                backgroundColor: ZogbeTheme.kraftLight,
                child: dishes.isEmpty
                    ? ListView(
                        children: [
                          SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.search_off, size: 48, color: ZogbeTheme.darkBrown),
                                const SizedBox(height: 8),
                                Text(
                                  'Aucun plat trouvé dans cette catégorie',
                                  style: GoogleFonts.plusJakartaSans(
                                    color: ZogbeTheme.darkBrown,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.65,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                        ),
                        itemCount: dishes.length,
                        itemBuilder: (context, index) {
                          final dish = dishes[index];
                          return DiamondDishCard(
                            dish: dish,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DishDetailScreen(dish: dish),
                                ),
                              );
                            },
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryPill({
    required BuildContext context,
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? ZogbeTheme.gariOrange : const Color(0xFFEFE6D5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? ZogbeTheme.gariOrange : ZogbeTheme.kraftBorder,
            width: 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: ZogbeTheme.gariOrange.withOpacity(0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  )
                ]
              : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 26,
              color: isSelected ? Colors.white : ZogbeTheme.darkBrown,
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected ? Colors.white : ZogbeTheme.darkBrown,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showQuartierDialog(BuildContext context, AuthProvider auth) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: ZogbeTheme.kraftLight,
        title: Text(
          'Choisir votre quartier de livraison',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: ZogbeTheme.darkBrown),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: AppConstants.quartiersLome.length,
            itemBuilder: (ctx, i) {
              final q = AppConstants.quartiersLome[i];
              final isCur = q == auth.selectedQuartier;
              return ListTile(
                leading: const Icon(Icons.location_on, color: ZogbeTheme.gariOrange),
                title: Text(
                  q,
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: isCur ? FontWeight.bold : FontWeight.normal,
                    color: ZogbeTheme.darkBrown,
                  ),
                ),
                trailing: isCur ? const Icon(Icons.check, color: ZogbeTheme.accentGreen) : null,
                onTap: () {
                  auth.setQuartier(q);
                  Navigator.pop(ctx);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
