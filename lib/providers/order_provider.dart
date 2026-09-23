import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../core/constants.dart';
import '../models/order.dart';
import '../models/cart_item.dart';

class OrderProvider extends ChangeNotifier {
  final List<OrderModel> _orders = [];
  OrderModel? _currentOrder;
  bool _isLoading = false;
  Timer? _pollingTimer;

  List<OrderModel> get orders => _orders;
  OrderModel? get currentOrder => _currentOrder;
  bool get isLoading => _isLoading;

  Future<bool> createOrder(List<CartItem> cartItems) async {
    _isLoading = true;
    notifyListeners();

    final String url = kIsWeb ? '${AppConstants.baseUrlWeb}/commandes/' : '${AppConstants.baseUrl}/commandes/';

    final payload = {
      'items': cartItems.map((item) => {
        'plat': item.dish.id,
        'quantite': item.quantity,
      }).toList(),
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(payload),
      ).timeout(const Duration(seconds: 4));

      if (response.statusCode == 201) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        _currentOrder = OrderModel.fromJson(data);
        _orders.insert(0, _currentOrder!);
        startOrderPolling(_currentOrder!.id);
        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      debugPrint("API offline ou erreur, création locale : $e");
    }

    // Fallback local en simulation si le backend n'est pas joignable
    _currentOrder = OrderModel(
      id: DateTime.now().millisecondsSinceEpoch % 10000,
      statut: 'en_preparation',
      statutDisplay: 'En préparation',
      dateCreation: DateTime.now(),
      total: cartItems.fold(0.0, (sum, i) => sum + i.totalPrice),
      lignes: cartItems.map((i) => OrderLine(
        id: 1,
        plat: i.dish,
        quantite: i.quantity,
        prixUnitaire: i.unitPrice,
        sousTotal: i.totalPrice,
      )).toList(),
    );
    _orders.insert(0, _currentOrder!);
    _simulateProgress();
    _isLoading = false;
    notifyListeners();
    return true;
  }

  void startOrderPolling(int orderId) {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(const Duration(seconds: 8), (timer) async {
      final String url = kIsWeb ? '${AppConstants.baseUrlWeb}/commandes/$orderId/' : '${AppConstants.baseUrl}/commandes/$orderId/';
      try {
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          final data = json.decode(utf8.decode(response.bodyBytes));
          _currentOrder = OrderModel.fromJson(data);
          notifyListeners();
          if (_currentOrder!.statut == 'recuperee') {
            timer.cancel();
          }
        }
      } catch (e) {
        debugPrint("Erreur polling : $e");
      }
    });
  }

  void _simulateProgress() {
    Future.delayed(const Duration(seconds: 8), () {
      if (_currentOrder != null && _currentOrder!.statut == 'en_preparation') {
        _currentOrder = OrderModel(
          id: _currentOrder!.id,
          statut: 'prete',
          statutDisplay: 'Prête',
          dateCreation: _currentOrder!.dateCreation,
          total: _currentOrder!.total,
          lignes: _currentOrder!.lignes,
        );
        notifyListeners();

        Future.delayed(const Duration(seconds: 10), () {
          if (_currentOrder != null && _currentOrder!.statut == 'prete') {
            _currentOrder = OrderModel(
              id: _currentOrder!.id,
              statut: 'recuperee',
              statutDisplay: 'Récupérée / Livrée',
              dateCreation: _currentOrder!.dateCreation,
              total: _currentOrder!.total,
              lignes: _currentOrder!.lignes,
            );
            notifyListeners();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }
}
