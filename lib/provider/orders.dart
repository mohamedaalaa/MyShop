import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'Auth.dart';
import 'cart.dart';

class OrderItems with ChangeNotifier {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItems({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItems> _orders = [];

  List<OrderItems> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = 'https://myshop-d80c6-default-rtdb.firebaseio.com/orders.json?auth=${Auth.token}';
    Uri myUri = Uri.parse(url);
    var time = DateTime.now();
    try {
      var response = await http.post(myUri,
          body: json.encode({
            'amount': total,
            'products': cartProducts
                .map((e) => {
                      'id': e.id,
                      'title': e.title,
                      'quantity': e.quantity,
                      'price': e.price,
                    })
                .toList(),
            'dateTime': time.toIso8601String(),
          }));
      _orders.insert(
        0,
        OrderItems(
          id: json.decode(response.body)['name'],
          amount: total,
          products: cartProducts,
          dateTime: time,
        ),
      );
    } catch (error) {
      throw error;
    }
    notifyListeners();
  }

  Future<void> fetchAndSetOrders() async {
    final url = 'https://myshop-d80c6-default-rtdb.firebaseio.com/orders.json?auth=${Auth.token}';
    Uri myUri = Uri.parse(url);
    var response = await http.get(myUri);
    //print(json.decode(response.body));
    List<OrderItems> _loadedProducts = [];
    final extractedData = json.decode(response.body) as Map<dynamic, dynamic>;
    if(extractedData=={}){
      return;
    }
    extractedData.forEach((key, value) {
      _loadedProducts.add(OrderItems(id: key, amount: value['amount'],
          products: (value['products']as List<dynamic>).map((e) =>
              CartItem(id: e['id'], title: e['title'], quantity: e['quantity'],
                  price: e['price'])).toList() ,
        dateTime: DateTime.parse(value['dateTime']),),);
    }
    );
    _orders=_loadedProducts;
    notifyListeners();
  }
}
