import '../core/constants.dart';

class DishOption {
  final String id;
  final String nom;
  final String description;
  final double prix;
  final String image;
  bool isSelected;

  DishOption({
    required this.id,
    required this.nom,
    required this.description,
    required this.prix,
    required this.image,
    this.isSelected = false,
  });

  DishOption copyWith({bool? isSelected}) {
    return DishOption(
      id: id,
      nom: nom,
      description: description,
      prix: prix,
      image: image,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}

class Dish {
  final int id;
  final String nom;
  final String description;
  final double prix;
  final String categorie;
  final String image;
  final bool disponible;
  bool isFavorite;
  final List<DishOption> options;

  Dish({
    required this.id,
    required this.nom,
    required this.description,
    required this.prix,
    required this.categorie,
    required this.image,
    this.disponible = true,
    this.isFavorite = false,
    List<DishOption>? options,
  }) : options = options ?? [
    DishOption(
      id: 'opt_piment',
      nom: 'Piment',
      description: 'Sauce piquante',
      prix: 300.0,
      image: 'https://images.unsplash.com/photo-1588165171080-c89acfa5a259?auto=format&fit=crop&w=200&q=80',
    ),
    DishOption(
      id: 'opt_poisson',
      nom: 'Poisson en plus',
      description: 'Poisson frais en plus',
      prix: 1500.0,
      image: 'https://images.unsplash.com/photo-1544025162-d76694265947?auto=format&fit=crop&w=200&q=80',
    ),
    DishOption(
      id: 'opt_gari',
      nom: 'Gari',
      description: 'Gari (farine de manioc)',
      prix: 200.0,
      image: 'https://images.unsplash.com/photo-1586201375761-83865001e31c?auto=format&fit=crop&w=200&q=80',
    ),
  ];

  factory Dish.fromJson(Map<String, dynamic> json) {
    String img = (json['image'] ?? '').toString().trim();
    if (img.startsWith('/media/')) {
      img = '${AppConstants.serverHost}$img';
    } else if (img.isEmpty) {
      img = 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=800&q=80';
    }

    return Dish(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      nom: json['nom'] ?? '',
      description: json['description'] ?? '',
      prix: double.tryParse(json['prix']?.toString() ?? '0') ?? 0.0,
      categorie: json['categorie'] ?? 'Plats',
      image: img,
      disponible: json['disponible'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'description': description,
      'prix': prix,
      'categorie': categorie,
      'image': image,
      'disponible': disponible,
    };
  }

  String get formattedPrice {
    // Format "2 500 FCFA" ou "4.500 FCFA"
    String priceInt = prix.toInt().toString();
    if (priceInt.length > 3) {
      String formatted = '${priceInt.substring(0, priceInt.length - 3)} ${priceInt.substring(priceInt.length - 3)}';
      return '$formatted FCFA';
    }
    return '$priceInt FCFA';
  }
}
