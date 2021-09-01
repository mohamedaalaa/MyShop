import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier{
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavourite=false,

  });

  Future<void> toggleFavourite(String id,String token, String userId) async{
    var _oldStatus=isFavourite;
    isFavourite=!isFavourite;
    notifyListeners();
      final url =
          'https://myshop-d80c6-default-rtdb.firebaseio.com/userFavorites/$userId/products/$id.json?auth=$token';
    Uri myUri = Uri.parse(url);
    try {
      var response = await http.put(myUri, body: json.encode(
        isFavourite,
      ));
      if(response.statusCode>=400){
        toggleFavErrors(_oldStatus);
      }
    }catch(error){
     toggleFavErrors(_oldStatus);
    }
  }

  void toggleFavErrors(bool _oldStatus) {
    isFavourite=_oldStatus;
    notifyListeners();
  }


}

