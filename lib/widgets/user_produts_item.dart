import 'package:flutter/material.dart';
import 'package:my_shop/provider/product.dart';
import 'package:my_shop/provider/products.dart';
import 'package:my_shop/screens/edit_products_screen.dart';
import 'package:provider/provider.dart';

class UserProductsItem extends StatelessWidget {
  const UserProductsItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaffold=ScaffoldMessenger.of(context);
    final products = Provider.of<Product>(context);
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(products.imageUrl),
      ),
      title: Text(products.title),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(EditPrpductsScreen.epsRouteName,
                    arguments: {'id': products.id, 'title': 'Edit Product'});
              },
              icon: Icon(Icons.edit),
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              onPressed: () async {
                try {
                  await Provider.of<Products>(context, listen: false)
                      .removeProduct(products.id);
                } catch (error) {
                  scaffold.showSnackBar(
                    SnackBar(
                      content: Text('Deleting Failed!'),
                    ),
                  );
                }
              },
              icon: Icon(Icons.delete),
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
