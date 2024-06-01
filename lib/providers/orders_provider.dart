import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrdersProvider with ChangeNotifier {
  List<DocumentSnapshot> _orders = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<DocumentSnapshot> get orders => _orders;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchOrders() async {
    try {
      _isLoading = true;
      notifyListeners();

      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('ordersAdvanced')
          .get();

      _orders = snapshot.docs;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteOrder(String orderId) async {
    try {
      _isLoading = true;
      notifyListeners();

      await FirebaseFirestore.instance.collection('ordersAdvanced').doc(orderId).delete();

      _orders.removeWhere((order) => order['orderId'] == orderId);
    } catch (e) {
      // Handle the error here
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
