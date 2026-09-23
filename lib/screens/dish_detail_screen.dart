import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../models/dish.dart';
import '../providers/cart_provider.dart';
import '../widgets/ethnic_decorations.dart';
import 'cart_screen.dart';

class DishDetailScreen extends StatefulWidget {
  final Dish dish;

  const DishDetailScreen({super.key, required this.dish});

  @override
  State<DishDetailScreen> createState() => _DishDetailScreenState();
}

class _DishDetailScreenState extends State<DishDetailScreen> {
  int _portionCount = 1;
  late List<DishOption> _options;

  @override
  void initState() {
    super.initState();
    // Cloner les options pour que les sélections soient locales à cet écran
    _options = widget.dish.options.map((opt) => opt.copyWith()).toList();
  }

  double get _calculatedTotalPrice {
    double base = widget.dish.prix;
    double optionsTotal = _options
        .where((opt) => opt.isSelected)
        .fold(0.0, (sum, opt) => sum + opt.prix);
    return (base + optionsTotal) * _portionCount;
  }

  String _formatPrice(double amount) {
    String priceInt = amount.toInt().toString();
    if (priceInt.length > 3) {
      String formatted = '${priceInt.substring(0, priceInt.length - 3)}.${priceInt.substring(priceInt.length - 3)}';
      return '$formatted FCFA';
    }
    return '$priceInt FCFA';
  }

  void _onAddToCart() {
    final selectedOpts = _options.where((o) => o.isSelected).toList();
    context.read<CartProvider>().addItem(
      widget.dish,
      quantity: _portionCount,
      options: selectedOpts,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: ZogbeTheme.darkBrown,
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: ZogbeTheme.gariOrange),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '${widget.dish.nom} ajouté au panier !',
                style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        action: SnackBarAction(
          label: 'VOIR PANIER',
          textColor: ZogbeTheme.gariOrange,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CartScreen()),
            );
          },
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ZogbeTheme.kraftLight,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Grande Photo Hero avec boutons flottants
            Stack(
              children: [
                Container(
                  height: 320,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(widget.dish.image),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.5),
                          Colors.transparent,
                          ZogbeTheme.kraftLight.withOpacity(0.9),
                        ],
                        stops: const [0.0, 0.6, 1.0],
                      ),
                    ),
                  ),
                ),

                // Bouton Retour
                Positioned(
                  top: 45,
                  left: 16,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.65),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.arrow_back, color: Colors.white, size: 18),
                          const SizedBox(width: 6),
                          Text(
                            'Retour',
                            style: GoogleFonts.plusJakartaSans(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Bouton Favori
                Positioned(
                  top: 45,
                  right: 16,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        widget.dish.isFavorite = !widget.dish.isFavorite;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.65),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        widget.dish.isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: widget.dish.isFavorite ? ZogbeTheme.redOilBrown : Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // 2. Contenu Détail
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Titre du plat + Badge Disponible
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          widget.dish.nom.toUpperCase(),
                          style: GoogleFonts.outfit(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            color: ZogbeTheme.darkBrown,
                            height: 1.15,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const DispoBadge(isDispo: true, compact: false),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Prix en grand
                  Text(
                    _formatPrice(_calculatedTotalPrice),
                    style: GoogleFonts.outfit(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: ZogbeTheme.gariOrange,
                      letterSpacing: -0.5,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Description
                  Text(
                    widget.dish.description,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13.5,
                      color: ZogbeTheme.darkBrown.withOpacity(0.85),
                      height: 1.45,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Section PORTION
                  Text(
                    'PORTION',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      color: ZogbeTheme.darkBrown,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      // Bouton Moins
                      GestureDetector(
                        onTap: () {
                          if (_portionCount > 1) {
                            setState(() => _portionCount--);
                          }
                        },
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: const BoxDecoration(
                            color: ZogbeTheme.darkBrown,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.remove, color: Colors.white, size: 20),
                        ),
                      ),
                      const SizedBox(width: 18),
                      // Chiffre
                      Text(
                        '$_portionCount',
                        style: GoogleFonts.outfit(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: ZogbeTheme.darkBrown,
                        ),
                      ),
                      const SizedBox(width: 18),
                      // Bouton Plus
                      GestureDetector(
                        onTap: () {
                          setState(() => _portionCount++);
                        },
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: const BoxDecoration(
                            color: ZogbeTheme.darkBrown,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.add, color: Colors.white, size: 20),
                        ),
                      ),
                      const SizedBox(width: 24),
                      // Indicateur portion
                      Row(
                        children: [
                          const Icon(Icons.soup_kitchen_outlined, color: ZogbeTheme.darkBrown, size: 20),
                          const SizedBox(width: 6),
                          Text(
                            '$_portionCount portion${_portionCount > 1 ? 's' : ''}',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: ZogbeTheme.darkBrown,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Ligne de séparation chevron dorée
                  const EthnicChevronBorder(height: 14),

                  const SizedBox(height: 18),

                  // Section OPTIONS
                  Text(
                    'OPTIONS',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      color: ZogbeTheme.darkBrown,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Liste des suppléments
                  ..._options.map((option) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: option.isSelected ? const Color(0xFFFDE8D0) : const Color(0xFFEFE5D3),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: option.isSelected ? ZogbeTheme.gariOrange : ZogbeTheme.kraftBorder,
                          width: 1.2,
                        ),
                      ),
                      child: Row(
                        children: [
                          // Miniature
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              option.image,
                              width: 48,
                              height: 48,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                width: 48,
                                height: 48,
                                color: ZogbeTheme.darkBrownMedium,
                                child: const Icon(Icons.lunch_dining, color: Colors.white, size: 24),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),

                          // Textes
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  option.nom,
                                  style: GoogleFonts.outfit(
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.bold,
                                    color: ZogbeTheme.darkBrown,
                                  ),
                                ),
                                Text(
                                  option.description,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11,
                                    color: ZogbeTheme.darkBrown.withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Prix du supplément
                          Text(
                            '+${option.prix.toInt()} FCFA',
                            style: GoogleFonts.outfit(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w800,
                              color: ZogbeTheme.gariOrange,
                            ),
                          ),
                          const SizedBox(width: 10),

                          // Bouton d'ajout / sélection
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                option.isSelected = !option.isSelected;
                              });
                            },
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: option.isSelected ? ZogbeTheme.gariOrange : ZogbeTheme.darkBrown,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                option.isSelected ? Icons.check : Icons.add,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),

                  const SizedBox(height: 18),

                  // Grand Bouton AJOUTER AU PANIER
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _onAddToCart,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ZogbeTheme.gariOrange,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 24),
                          const SizedBox(width: 10),
                          Text(
                            'AJOUTER AU PANIER',
                            style: GoogleFonts.outfit(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.5,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Mention livraison estimée
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.access_time, color: ZogbeTheme.darkBrown, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          'Livraison estimée : 30–45 min',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: ZogbeTheme.darkBrown,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Frise ethnique en bas
                  const EthnicChevronBorder(height: 20),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
