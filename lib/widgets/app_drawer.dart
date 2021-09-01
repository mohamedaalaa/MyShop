

import 'package:flutter/material.dart';
import 'package:my_shop/provider/Auth.dart';
import 'package:my_shop/screens/orders_screen.dart';
import 'package:my_shop/screens/product_overview_screen.dart';
import 'package:my_shop/screens/user_products_screen.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children:<Widget>[
          AppBar(title: Text('Hello Friend'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('SHOP'),
            onTap: (){
              Navigator.of(context).pushReplacementNamed(ProductOverviewScreen.poScreen);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Orders'),
            onTap: (){
              Navigator.of(context).pushReplacementNamed(OrdersScreen.ordersScreenRouteName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Manage Products'),
            onTap: (){
              Navigator.of(context).pushReplacementNamed(UserProductsScreen.usprouteName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Manage Products'),
            onTap: (){
              Navigator.of(context).pop();
              Provider.of<Auth>(context,listen:false).logOut();
            },
          ),
        ],
      ),
    );
  }
}
