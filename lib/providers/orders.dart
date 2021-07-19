import 'package:flutter/foundation.dart';
import 'package:flutter_shop_app/providers/cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderItem {
  final String id;
  final double amount;
  final DateTime dateTime;
  final List<CartItem> products;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.dateTime,
    @required this.products,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String authToken;
  final String userId;

  Orders(this.authToken, this.userId, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final urlOrder = Uri.https(
        'flutter-shop-app-9dd56-default-rtdb.asia-southeast1.firebasedatabase.app',
        '/orders/$userId.json',
        {'auth': '$authToken'});
    try {
      final response = await http.get(urlOrder);
      final List<OrderItem> loadedOrders = [];
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      extractedData.forEach((id, data) {
        loadedOrders.add(
          OrderItem(
            id: id,
            amount: data['amount'],
            dateTime: DateTime.parse(data['dateTime']),
            products: (data['product'] as List<dynamic>)
                .map((item) => CartItem(
                      id: item['id'],
                      title: item['title'],
                      quantity: item['quantity'],
                      price: item['price'],
                    ))
                .toList(),
          ),
        );
      });
      _orders = loadedOrders.reversed
          .toList(); //reversing orders list fetch from server
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final urlOrder = Uri.https(
        'flutter-shop-app-9dd56-default-rtdb.asia-southeast1.firebasedatabase.app',
        '/orders/$userId.json', {
      'auth': '$authToken',
    });
    final timestamp = DateTime.now();

    try {
      final response = await http.post(
        urlOrder,
        body: json.encode({
          'amount': total,
          'dateTime': timestamp.toIso8601String(),
          'product': cartProducts
              .map((cp) => {
                    'id': cp.id,
                    'title': cp.title,
                    'quantity': cp.quantity,
                    'price': cp.price,
                  })
              .toList(),
        }),
      );
      _orders.insert(
        0,
        OrderItem(
            id: json.decode(response.body)['name'],
            amount: total,
            dateTime: timestamp,
            products: cartProducts),
      );
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }
}
