class AppConstants {
  static const String appName = 'Zògbé';
  static const String appTagline = 'Le goût du Togo, à portée de main';
  
  // Configuration réseau Django REST Framework
  // Adresse IP de la machine sur le réseau Wi-Fi local :
  static const String serverIp = '192.168.1.68';
  static const String serverHost = 'http://$serverIp:8000';
  static const String baseUrl = '$serverHost/api';
  static const String baseUrlWeb = 'http://127.0.0.1:8000/api';

  // Quartiers populaires de Lomé
  static const List<String> quartiersLome = [
    'Adjougba, Lomé',
    'Agoè-Nyivé, Lomé',
    'Bè-Kpota, Lomé',
    'Tokoin Habitat, Lomé',
    'Hedzranawoé, Lomé',
    'Nyékonakpoè, Lomé',
    'Kodjoviakopé, Lomé',
    'Cacaveli, Lomé',
    'Kégué, Lomé',
    'Avédji, Lomé',
    'Baguida, Lomé',
  ];

  // Catégories officielles
  static const List<String> categories = [
    'Pâte',
    'Riz',
    'Sauces',
    'Grillades',
    'Boissons',
  ];
}
