import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_shop/provider/products.dart';
import 'package:provider/provider.dart';

class ProductDetails extends StatelessWidget {
  const ProductDetails({Key? key}) : super(key: key);
  static const productDetailsRouteName = '/product_details_routeName';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final productSelected =
        Provider.of<Products>(context).findProductById(productId);

    return Scaffold(
        appBar: AppBar(
          title: Text(
            productSelected.title,
            style: TextStyle(fontWeight: FontWeight.w400, color: Colors.white),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: 300,
                width: double.infinity,
                child: Image.network(
                  productSelected.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text('\$${productSelected.price}'),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.all(10),
                width: double.infinity,
                child: Text(
                  '${productSelected.description}',
                  softWrap: true,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
