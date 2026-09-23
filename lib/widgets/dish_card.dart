import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme.dart';
import '../models/dish.dart';
import 'ethnic_decorations.dart';

class DiamondDishCard extends StatelessWidget {
  final Dish dish;
  final VoidCallback onTap;

  const DiamondDishCard({
    super.key,
    required this.dish,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFEFE6D5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: ZogbeTheme.kraftBorder, width: 1),
          boxShadow: [
            BoxShadow(
              color: ZogbeTheme.darkBrown.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Cadre décoratif losange / ethnique pour l'image
            Center(
              child: SizedBox(
                width: 125,
                height: 125,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Décoration coins tribaux
                    Transform.rotate(
                      angle: 0.785398, // 45 degrés
                      child: Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          color: const Color(0xFFD39855),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    // Image dans un conteneur arrondi ou losange
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        dish.image,
                        width: 115,
                        height: 115,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 115,
                          height: 115,
                          color: ZogbeTheme.darkBrownMedium,
                          child: const Icon(Icons.restaurant, color: ZogbeTheme.kraftLight, size: 40),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),

            // 2. Nom du plat
            Text(
              dish.nom.toUpperCase(),
              style: GoogleFonts.outfit(
                fontSize: 14,
                fontWeight: FontWeight.w900,
                color: ZogbeTheme.darkBrown,
                height: 1.1,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),

            // 3. Description courte
            Text(
              dish.description,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10.5,
                color: ZogbeTheme.darkBrown.withOpacity(0.75),
                height: 1.2,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),

            // 4. Ligne inférieure : Badge Prix + Badge DISPO
            Row(
              children: [
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: PriceTicketBadge(price: dish.formattedPrice),
                  ),
                ),
                const SizedBox(width: 4),
                DispoBadge(isDispo: dish.disponible, compact: true),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
