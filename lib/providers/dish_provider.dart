import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../core/constants.dart';
import '../models/dish.dart';

class DishProvider extends ChangeNotifier {
  List<Dish> _dishes = [];
  String _selectedCategory = 'Pâte';
  String _searchQuery = '';
  bool _isLoading = false;
  String? _errorMessage;

  List<Dish> get dishes => _dishes;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  DishProvider() {
    _loadInitialMockData();
    fetchDishes();
  }

  void _loadInitialMockData() {
    _dishes = [
      Dish(
        id: 1,
        nom: 'PÂTE SAUCE GRAINE',
        description: 'Pâte maison accompagnée d\'une sauce graine savoureuse et relevée.',
        prix: 2500.0,
        categorie: 'Pâte',
        image: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=800&q=80',
        disponible: true,
      ),
      Dish(
        id: 2,
        nom: 'RIZ SAUCE ARACHIDE',
        description: 'Riz blanc servi avec une sauce arachide onctueuse et parfumée.',
        prix: 2000.0,
        categorie: 'Riz',
        image: 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?auto=format&fit=crop&w=800&q=80',
        disponible: true,
      ),
      Dish(
        id: 3,
        nom: 'AKPAN',
        description: 'Feuilles d\'akpan finement préparées avec du poisson et des épices locales.',
        prix: 1800.0,
        categorie: 'Sauces',
        image: 'https://images.unsplash.com/photo-1547592180-85f173990554?auto=format&fit=crop&w=800&q=80',
        disponible: true,
      ),
      Dish(
        id: 4,
        nom: 'POULET BRAISÉ',
        description: 'Poulet mariné et braisé à la perfection, saveur fumée et épicée.',
        prix: 3000.0,
        categorie: 'Grillades',
        image: 'https://images.unsplash.com/photo-1544025162-d76694265947?auto=format&fit=crop&w=800&q=80',
        disponible: true,
      ),
      Dish(
        id: 5,
        nom: 'PÂTE AVEC SAUCE GRAINE ET POISSON',
        description: 'Pâte onctueuse accompagnée d\'une savoureuse sauce graine et de poisson frais. Un plat traditionnel du Togo, riche en goût et en tradition.',
        prix: 4500.0,
        categorie: 'Pâte',
        image: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?auto=format&fit=crop&w=800&q=80',
        disponible: true,
      ),
      Dish(
        id: 6,
        nom: 'AYIMOLOU ROYAL',
        description: 'Riz et haricots cuits avec shito noir, œuf dur, wagashi et poisson frit.',
        prix: 2500.0,
        categorie: 'Riz',
        image: 'https://images.unsplash.com/photo-1512058564366-18510be2db19?auto=format&fit=crop&w=800&q=80',
        disponible: true,
      ),
      Dish(
        id: 7,
        nom: 'JUS DE BISSAP FRAIS',
        description: 'Boisson artisanale d\'hibiscus frais à la menthe douce.',
        prix: 800.0,
        categorie: 'Boissons',
        image: 'https://images.unsplash.com/photo-1513558161293-cdaf765ed2fd?auto=format&fit=crop&w=800&q=80',
        disponible: true,
      ),
      Dish(
        id: 8,
        nom: 'JUS DE GINGEMBRE ANANAS',
        description: 'Boisson tonifiante et fraîche au gingembre et ananas.',
        prix: 800.0,
        categorie: 'Boissons',
        image: 'https://images.unsplash.com/photo-1534353473418-4cfa6c56fd38?auto=format&fit=crop&w=800&q=80',
        disponible: true,
      ),
    ];
  }

  List<Dish> get filteredDishes {
    return _dishes.where((dish) {
      final matchesCategory = _selectedCategory == 'Tous' ||
          dish.categorie.toLowerCase() == _selectedCategory.toLowerCase();
      final matchesSearch = _searchQuery.isEmpty ||
          dish.nom.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          dish.description.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void toggleFavorite(Dish dish) {
    dish.isFavorite = !dish.isFavorite;
    notifyListeners();
  }

  Future<void> fetchDishes() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final List<String> candidateUrls = [
      kIsWeb ? '${AppConstants.baseUrlWeb}/plats/' : '${AppConstants.baseUrl}/plats/',
      'http://192.168.1.68:8000/api/plats/',
      'http://127.0.0.1:8000/api/plats/',
      'http://10.0.2.2:8000/api/plats/',
    ];

    for (final url in candidateUrls) {
      try {
        final response = await http.get(Uri.parse(url)).timeout(const Duration(milliseconds: 2500));
        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
          if (data.isNotEmpty) {
            _dishes = data.map((jsonItem) => Dish.fromJson(jsonItem)).toList();
            _isLoading = false;
            notifyListeners();
            return;
          }
        }
      } catch (e) {
        debugPrint("Tentative connexion API échouée sur $url : $e");
      }
    }

    _isLoading = false;
    notifyListeners();
  }
}
