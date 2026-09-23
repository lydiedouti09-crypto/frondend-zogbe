import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../providers/order_provider.dart';
import '../widgets/zogbe_logo.dart';
import '../widgets/ethnic_decorations.dart';
import 'main_navigation_screen.dart';

class OrderTrackingScreen extends StatelessWidget {
  const OrderTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderProvider = context.watch<OrderProvider>();
    final order = orderProvider.currentOrder;

    return Scaffold(
      backgroundColor: ZogbeTheme.kraftLight,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 1. Top Bar : Menu + Logo + Cloche de notification
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.menu, color: ZogbeTheme.darkBrown, size: 28),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
                        );
                      },
                    ),
                    const ZogbeLogo(
                      size: 32,
                      vertical: true,
                      showFlame: true,
                      subtitle: 'Le goût du Togo',
                    ),
                    IconButton(
                      icon: const Icon(Icons.notifications_outlined, color: ZogbeTheme.darkBrown, size: 26),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // 2. Titre "◇ Suivi de commande ◇"
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Transform.rotate(
                    angle: 0.785398,
                    child: Container(width: 8, height: 8, color: ZogbeTheme.darkBrown),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Suivi de commande',
                    style: GoogleFonts.outfit(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: ZogbeTheme.darkBrown,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Transform.rotate(
                    angle: 0.785398,
                    child: Container(width: 8, height: 8, color: ZogbeTheme.darkBrown),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const DiamondSeparator(width: 80),

              const SizedBox(height: 16),

              // 3. Section Illustration & Étapes en losanges
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Colonne de gauche : Losanges d'étapes
                    SizedBox(
                      width: 110,
                      child: Column(
                        children: [
                          _buildDiamondStep(
                            icon: Icons.soup_kitchen_outlined,
                            label: 'En préparation',
                            color: const Color(0xFF437A5B),
                            isActive: true,
                          ),
                          Container(width: 2, height: 26, color: const Color(0xFF437A5B)),
                          _buildDiamondStep(
                            icon: Icons.check,
                            label: 'Prête',
                            color: const Color(0xFF2E633B),
                            isActive: order?.statut == 'prete' || order?.statut == 'recuperee',
                          ),
                          Container(width: 2, height: 26, color: ZogbeTheme.gariOrange),
                          _buildDiamondStep(
                            icon: Icons.shopping_bag_outlined,
                            label: 'Récupérée',
                            color: ZogbeTheme.gariOrange,
                            isActive: order?.statut == 'recuperee',
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 8),

                    // Colonne de droite : Illustration du jeune garçon togolais avec le bol Zògbé
                    Expanded(
                      child: Center(
                        child: SizedBox(
                          height: 230,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.network(
                                  'https://images.unsplash.com/photo-1544717305-2782549b5136?auto=format&fit=crop&w=600&q=80',
                                  height: 210,
                                  width: 190,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    height: 200,
                                    width: 170,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFDCC8AA),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: const Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.person, size: 60, color: ZogbeTheme.darkBrown),
                                        Text('Livreur Zògbé', style: TextStyle(fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 12,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: ZogbeTheme.darkBrown,
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(color: ZogbeTheme.gariOrange, width: 1.5),
                                  ),
                                  child: Text(
                                    'Zògbé Express',
                                    style: GoogleFonts.outfit(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // 4. Bandeau Temps estimé & Quartier
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFE6D5),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: ZogbeTheme.kraftBorder),
                  ),
                  child: Row(
                    children: [
                      // Temps estimé
                      Expanded(
                        child: Row(
                          children: [
                            const Icon(Icons.access_time, color: ZogbeTheme.darkBrown, size: 28),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Temps estimé',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11,
                                    color: ZogbeTheme.darkBrown.withOpacity(0.7),
                                  ),
                                ),
                                Text(
                                  '18-25 min',
                                  style: GoogleFonts.outfit(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                    color: ZogbeTheme.darkBrown,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      Container(width: 1, height: 36, color: ZogbeTheme.darkBrown.withOpacity(0.2)),
                      const SizedBox(width: 12),

                      // Quartier
                      Expanded(
                        child: Row(
                          children: [
                            const Icon(Icons.location_on, color: ZogbeTheme.darkBrown, size: 28),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Quartier',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 11,
                                      color: ZogbeTheme.darkBrown.withOpacity(0.7),
                                    ),
                                  ),
                                  Text(
                                    'Adidogomé',
                                    style: GoogleFonts.outfit(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: ZogbeTheme.darkBrown,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    'En face de l\'école...',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 10,
                                      color: ZogbeTheme.darkBrown.withOpacity(0.65),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // 5. Bloc Récapitulatif de votre commande
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFE6D5),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: ZogbeTheme.kraftBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Transform.rotate(
                            angle: 0.785398,
                            child: Container(width: 6, height: 6, color: ZogbeTheme.darkBrown),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Récapitulatif de votre commande',
                            style: GoogleFonts.outfit(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: ZogbeTheme.darkBrown,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Article
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=200&q=80',
                              width: 54,
                              height: 54,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Assiette Zogbé',
                                  style: GoogleFonts.outfit(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: ZogbeTheme.darkBrown,
                                  ),
                                ),
                                Text(
                                  'Foufou, sauce aubergine, poisson, piment, salade',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 10.5,
                                    color: ZogbeTheme.darkBrown.withOpacity(0.7),
                                  ),
                                  maxLines: 2,
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '3 500 FCFA',
                            style: GoogleFonts.outfit(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: ZogbeTheme.darkBrown,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),
                      Container(height: 1, color: ZogbeTheme.darkBrown.withOpacity(0.15)),
                      const SizedBox(height: 8),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Sous-total', style: GoogleFonts.plusJakartaSans(fontSize: 13, color: ZogbeTheme.darkBrown)),
                          Text('3 500 FCFA', style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.w600, color: ZogbeTheme.darkBrown)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Frais de livraison', style: GoogleFonts.plusJakartaSans(fontSize: 13, color: ZogbeTheme.darkBrown)),
                          Text('500 FCFA', style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.w600, color: ZogbeTheme.darkBrown)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total',
                            style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: ZogbeTheme.darkBrown),
                          ),
                          Text(
                            '4 000 FCFA',
                            style: GoogleFonts.outfit(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: ZogbeTheme.darkBrown,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // 6. Grand bouton vert "Contacter le livreur"
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Appel du livreur : +228 90 00 00 00 en cours...')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5A6B4E), // Vert olive / Kaki de la maquette
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.phone, color: Colors.white, size: 22),
                        const SizedBox(width: 8),
                        Text(
                          'Contacter le livreur',
                          style: GoogleFonts.outfit(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // 7. Mention de confiance
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.verified_user_outlined, size: 16, color: ZogbeTheme.darkBrown),
                  const SizedBox(width: 6),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Merci pour votre confiance',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: ZogbeTheme.darkBrown,
                        ),
                      ),
                      Text(
                        'Le goût du Togo, jusqu’à votre porte.',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          color: ZogbeTheme.darkBrown.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDiamondStep({
    required IconData icon,
    required String label,
    required Color color,
    required bool isActive,
  }) {
    return Column(
      children: [
        Transform.rotate(
          angle: 0.785398, // 45 degrés pour former le losange exact
          child: Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.4),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Transform.rotate(
                angle: -0.785398, // Redresser l'icône
                child: Icon(icon, color: Colors.white, size: 24),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: isActive ? ZogbeTheme.darkBrown : Colors.grey,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
