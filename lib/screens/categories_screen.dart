import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../providers/dish_provider.dart';
import '../widgets/dish_card.dart';
import 'dish_detail_screen.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  String? _selectedCategoryFilter;

  final List<Map<String, dynamic>> _categoriesList = [
    {
      'name': 'Pâte',
      'label': 'Pâtes Traditionnelles',
      'desc': 'Akoumé, Djenkoumé, Pâte de maïs avec sauces graine',
      'icon': Icons.soup_kitchen,
      'image': 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=600&q=80',
      'color': const Color(0xFFE0822D),
    },
    {
      'name': 'Riz',
      'label': 'Riz & Ayimolou',
      'desc': 'Ayimolou royal, Riz au gras togolais parfumé',
      'icon': Icons.rice_bowl,
      'image': 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?auto=format&fit=crop&w=600&q=80',
      'color': const Color(0xFF8B2622),
    },
    {
      'name': 'Sauces',
      'label': 'Sauces Togolaises',
      'desc': 'Gboma dessi, sauce arachide, sauce graine',
      'icon': Icons.local_dining,
      'image': 'https://images.unsplash.com/photo-1547592180-85f173990554?auto=format&fit=crop&w=600&q=80',
      'color': const Color(0xFF2E633B),
    },
    {
      'name': 'Grillades',
      'label': 'Grillades & Viandes',
      'desc': 'Poulet bicyclette braisé, pintade, brochettes',
      'icon': Icons.kebab_dining,
      'image': 'https://images.unsplash.com/photo-1544025162-d76694265947?auto=format&fit=crop&w=600&q=80',
      'color': const Color(0xFF4A2A22),
    },
    {
      'name': 'Boissons',
      'label': 'Boissons & Jus Frais',
      'desc': 'Jus de Bissap maison, Gingembre ananas frais',
      'icon': Icons.local_drink,
      'image': 'https://images.unsplash.com/photo-1513558161293-cdaf765ed2fd?auto=format&fit=crop&w=600&q=80',
      'color': const Color(0xFF1E3A8A),
    },
  ];

  @override
  Widget build(BuildContext context) {
    final dishProvider = context.watch<DishProvider>();

    if (_selectedCategoryFilter != null) {
      final categoryDishes = dishProvider.dishes.where((d) =>
          d.categorie.toLowerCase() == _selectedCategoryFilter!.toLowerCase()
      ).toList();

      return Scaffold(
        backgroundColor: ZogbeTheme.kraftLight,
        appBar: AppBar(
          title: Text(
            _selectedCategoryFilter!,
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.bold,
              color: ZogbeTheme.darkBrown,
              fontSize: 22,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: ZogbeTheme.darkBrown),
            onPressed: () => setState(() => _selectedCategoryFilter = null),
          ),
        ),
        body: categoryDishes.isEmpty
            ? Center(
                child: Text(
                  'Aucun plat dans cette catégorie pour l\'instant.',
                  style: GoogleFonts.plusJakartaSans(color: ZogbeTheme.darkBrown, fontWeight: FontWeight.bold),
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
                itemCount: categoryDishes.length,
                itemBuilder: (context, index) {
                  final dish = categoryDishes[index];
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

    return Scaffold(
      backgroundColor: ZogbeTheme.kraftLight,
      appBar: AppBar(
        title: Text(
          'Nos Catégories',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w900,
            color: ZogbeTheme.darkBrown,
            fontSize: 24,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _categoriesList.length,
        itemBuilder: (context, index) {
          final cat = _categoriesList[index];
          final count = dishProvider.dishes.where((d) => d.categorie.toLowerCase() == cat['name'].toString().toLowerCase()).length;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategoryFilter = cat['name'];
              });
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                image: DecorationImage(
                  image: NetworkImage(cat['image']),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.48),
                    BlendMode.darken,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Icon(cat['icon'], color: ZogbeTheme.gariOrange, size: 22),
                              const SizedBox(width: 8),
                              Text(
                                cat['label'],
                                style: GoogleFonts.outfit(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            cat['desc'],
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11.5,
                              color: Colors.white.withOpacity(0.85),
                            ),
                            maxLines: 2,
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: ZogbeTheme.gariOrange,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '$count plats disponibles',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 18),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
