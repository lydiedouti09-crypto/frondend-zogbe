import 'dish.dart';

class OrderLine {
  final int id;
  final Dish plat;
  final int quantite;
  final double prixUnitaire;
  final double sousTotal;

  OrderLine({
    required this.id,
    required this.plat,
    required this.quantite,
    required this.prixUnitaire,
    required this.sousTotal,
  });

  factory OrderLine.fromJson(Map<String, dynamic> json) {
    return OrderLine(
      id: json['id'] ?? 0,
      plat: Dish.fromJson(json['plat'] ?? {}),
      quantite: json['quantite'] ?? 1,
      prixUnitaire: double.tryParse(json['prix_unitaire']?.toString() ?? '0') ?? 0.0,
      sousTotal: double.tryParse(json['sous_total']?.toString() ?? '0') ?? 0.0,
    );
  }
}

class OrderModel {
  final int id;
  final String statut;
  final String statutDisplay;
  final DateTime dateCreation;
  final double total;
  final List<OrderLine> lignes;

  OrderModel({
    required this.id,
    required this.statut,
    required this.statutDisplay,
    required this.dateCreation,
    required this.total,
    required this.lignes,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    var lignesList = (json['lignes'] as List? ?? [])
        .map((l) => OrderLine.fromJson(l))
        .toList();

    return OrderModel(
      id: json['id'] ?? 0,
      statut: json['statut'] ?? 'en_preparation',
      statutDisplay: json['statut_display'] ?? 'En préparation',
      dateCreation: json['dateCreation'] != null
          ? DateTime.tryParse(json['dateCreation']) ?? DateTime.now()
          : DateTime.now(),
      total: double.tryParse(json['total']?.toString() ?? '0') ?? 0.0,
      lignes: lignesList,
    );
  }

  String get formattedTotal {
    String priceInt = total.toInt().toString();
    if (priceInt.length > 3) {
      String formatted = '${priceInt.substring(0, priceInt.length - 3)} ${priceInt.substring(priceInt.length - 3)}';
      return '$formatted FCFA';
    }
    return '$priceInt FCFA';
  }
}
