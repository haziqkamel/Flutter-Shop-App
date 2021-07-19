import 'package:flutter/foundation.dart';
import 'package:flutter_shop_app/models/http_exception.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  void _setFavValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toogleFavStatus(String token, String userId) async {
    final urlProducts = Uri.https(
        'flutter-shop-app-9dd56-default-rtdb.asia-southeast1.firebasedatabase.app',
        '/userFavorites/$userId/$id.json', {
      'auth': '$token',
    });
    var status = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();

    try {
      final response = await http.put(urlProducts,
          body: json.encode({
            'isFavorite': isFavorite,
          }));

      if (response.statusCode >= 400) {
        _setFavValue(status);
        throw HttpException('Could not change the product status.');
      }
    } catch (error) {
      _setFavValue(status);
    }
    status = null;
  }
}
