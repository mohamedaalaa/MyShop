import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:my_shop/models/HttpException.dart';
import 'package:my_shop/provider/Auth.dart';
import 'package:my_shop/provider/product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];
    Auth auth=new Auth();
  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((element) => element.isFavourite == true).toList();
  }

  Product findProductById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> addProduct(Product value) async {
    final url =
        'https://myshop-d80c6-default-rtdb.firebaseio.com/products.json?auth=${Auth.token}';
    Uri myUri = Uri.parse(url);

    try {
      final response = await http.post(
        myUri,
        body: json.encode(
          {
            'title': value.title,
            'description': value.description,
            'price': value.price,
            'imageUrl': value.imageUrl,
            'isFavorite': value.isFavourite
          },
        ),
      );
      final productData = Product(
        id: json.decode(response.body)['name'],
        title: value.title,
        price: value.price,
        description: value.description,
        imageUrl: value.imageUrl,
      );
      _items.add(productData);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchAndSetProducts() async {
    print(Auth.token);
    final url =
        'https://myshop-d80c6-default-rtdb.firebaseio.com/products.json?auth=${Auth.token}';
    Uri myUri = Uri.parse(url);

    try {
      final response = await http.get(myUri);
      print(json.decode(response.body));
      final extractedData = json.decode(response.body) as Map<String , dynamic>;
      if(extractedData == {}){
        return;
      }
      final url1 =
          'https://myshop-d80c6-default-rtdb.firebaseio.com/userFavorites/${Auth.userId}.json?auth=${Auth.token}';
      Uri myUri1 = Uri.parse(url1);
      final favoriteItems=await http.get(myUri1);
      final favoriteData= json.decode(favoriteItems.body);
      List<Product> loadedProducts = [];
      extractedData.forEach(
        (prodId, value) {
          loadedProducts.add(
            Product(
              id: prodId,
              title: value['title'],
              description: value['description'],
              price: value['price'],
              imageUrl: value['imageUrl'],
              isFavourite: favoriteData==null ? false : favoriteData[prodId]
            ),
          );
        },
      );
      _items=loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateProduct (
      String updatedProductId, Product updatedProduct) async {
    final _productIndex =
        _items.indexWhere((element) => element.id == updatedProductId);
    if (_productIndex >= 0) {
      final url =
          'https://myshop-d80c6-default-rtdb.firebaseio.com/products/$updatedProductId.json?auth=${Auth.token}';
      Uri myUri = Uri.parse(url);
      await http.patch(myUri,body:json.encode({
        'title': updatedProduct.title,
        'description': updatedProduct.description,
        'price': updatedProduct.price,
        'imageUrl': updatedProduct.imageUrl,
      }) );
      _items[_productIndex] = updatedProduct;
      notifyListeners();
    } else {
      return;
    }
  }

  Future<void> removeProduct(String productId) async{
    final url =
        'https://myshop-d80c6-default-rtdb.firebaseio.com/products/$productId.json?auth=${Auth.token}';
    Uri myUri = Uri.parse(url);
    final existingProductIndex=_items.indexWhere((element) => element.id==productId);
    var existingProduct=_items[existingProductIndex];

    _items.removeAt(existingProductIndex);
    notifyListeners();

    final response=await http.delete(myUri);

      if(response.statusCode>=400){
        _items.insert(existingProductIndex,existingProduct);
        notifyListeners();
        throw HttpException('could not delete product');
      }
      //existingProduct=null as Product;

  }
}
