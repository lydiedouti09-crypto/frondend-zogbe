import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../providers/dish_provider.dart';
import '../widgets/dish_card.dart';
import 'dish_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dishProvider = context.watch<DishProvider>();
    final favoriteDishes = dishProvider.dishes.where((d) => d.isFavorite).toList();

    return Scaffold(
      backgroundColor: ZogbeTheme.kraftLight,
      appBar: AppBar(
        title: Text(
          'Mes Favoris',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w900,
            color: ZogbeTheme.darkBrown,
            fontSize: 24,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: favoriteDishes.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDE8D0),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.favorite_border, size: 54, color: ZogbeTheme.redOilBrown),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Aucun plat en favoris',
                    style: GoogleFonts.outfit(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: ZogbeTheme.darkBrown,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Appuyez sur le cœur 🤍 sur un plat pour le retrouver ici.',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      color: ZogbeTheme.darkBrown.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.68,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
              ),
              itemCount: favoriteDishes.length,
              itemBuilder: (context, index) {
                final dish = favoriteDishes[index];
                return DiamondDishCard(
                  dish: dish,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => DishDetailScreen(dish: dish)),
                    );
                  },
                );
              },
            ),
    );
  }
}
