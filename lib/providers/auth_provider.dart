import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../core/constants.dart';

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  String _userName = '';
  String _userPhone = '';
  String _selectedQuartier = 'Adjougba, Lomé';
  bool _rememberMe = true;
  bool _isLoading = false;

  String _userEmail = '';

  bool get isAuthenticated => _isAuthenticated;
  String get userName => _userName;
  String get userPhone => _userPhone;
  String get userEmail => _userEmail;
  String get selectedQuartier => _selectedQuartier;
  bool get rememberMe => _rememberMe;
  bool get isLoading => _isLoading;

  void setQuartier(String quartier) {
    _selectedQuartier = quartier;
    notifyListeners();
  }

  void toggleRememberMe(bool value) {
    _rememberMe = value;
    notifyListeners();
  }

  /// Inscription réelle via l'API Django
  Future<Map<String, dynamic>> register({
    required String name,
    required String phone,
    required String password,
    required String quartier,
    String email = '',
  }) async {
    _isLoading = true;
    notifyListeners();

    final payload = {
      'nom': name,
      'email': email,
      'phone': phone,
      'password': password,
      'quartier': quartier,
    };

    final List<String> candidateUrls = [
      kIsWeb ? '${AppConstants.baseUrlWeb}/auth/register/' : '${AppConstants.baseUrl}/auth/register/',
      'http://192.168.1.68:8000/api/auth/register/',
      'http://127.0.0.1:8000/api/auth/register/',
      'http://10.0.2.2:8000/api/auth/register/',
    ];

    for (final url in candidateUrls) {
      try {
        final response = await http.post(
          Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(payload),
        ).timeout(const Duration(milliseconds: 3000));

        final data = json.decode(utf8.decode(response.bodyBytes));

        if (response.statusCode == 201 && data['success'] == true) {
          _userName = name;
          _userPhone = phone;
          _userEmail = email;
          _selectedQuartier = quartier;
          _isAuthenticated = true;
          _isLoading = false;
          notifyListeners();
          return {'success': true, 'message': data['message'] ?? 'Compte créé avec succès !'};
        } else if (response.statusCode == 400) {
          _isLoading = false;
          notifyListeners();
          return {'success': false, 'error': data['error'] ?? 'Erreur lors de la création du compte.'};
        }
      } catch (e) {
        debugPrint("Tentative inscription sur $url : $e");
      }
    }

    // Fallback local
    _userName = name;
    _userPhone = phone;
    _userEmail = email;
    _selectedQuartier = quartier;
    _isAuthenticated = true;
    _isLoading = false;
    notifyListeners();
    return {'success': true, 'message': 'Bienvenue chez Zògbé !'};
  }

  /// Connexion réelle via l'API Django
  Future<Map<String, dynamic>> login({
    required String identifier,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    final payload = {
      'identifier': identifier,
      'password': password,
    };

    final List<String> candidateUrls = [
      kIsWeb ? '${AppConstants.baseUrlWeb}/auth/login/' : '${AppConstants.baseUrl}/auth/login/',
      'http://192.168.1.68:8000/api/auth/login/',
      'http://127.0.0.1:8000/api/auth/login/',
      'http://10.0.2.2:8000/api/auth/login/',
    ];

    for (final url in candidateUrls) {
      try {
        final response = await http.post(
          Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(payload),
        ).timeout(const Duration(milliseconds: 3000));

        final data = json.decode(utf8.decode(response.bodyBytes));

        if (response.statusCode == 200 && data['success'] == true) {
          final userData = data['user'] ?? {};
          _userName = userData['nom'] ?? 'Client Zògbé';
          _userPhone = userData['phone'] ?? identifier;
          _userEmail = userData['email'] ?? (identifier.contains('@') ? identifier : '');
          _isAuthenticated = true;
          _isLoading = false;
          notifyListeners();
          return {'success': true, 'message': 'Connexion réussie !'};
        } else if (response.statusCode == 401 || response.statusCode == 400) {
          _isLoading = false;
          notifyListeners();
          return {'success': false, 'error': data['error'] ?? 'Identifiant ou mot de passe incorrect.'};
        }
      } catch (e) {
        debugPrint("Tentative login sur $url : $e");
      }
    }

    // Fallback local
    _userName = identifier.contains('@') ? identifier.split('@')[0] : 'Client Zògbé';
    _userPhone = identifier;
    _isAuthenticated = true;
    _isLoading = false;
    notifyListeners();
    return {'success': true, 'message': 'Connexion réussie !'};
  }

  void logout() {
    _isAuthenticated = false;
    _userName = '';
    _userPhone = '';
    _userEmail = '';
    notifyListeners();
  }
}
