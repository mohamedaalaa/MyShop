import 'package:flutter/material.dart';
import 'package:my_shop/provider/Auth.dart';
import 'package:my_shop/provider/cart.dart';
import 'package:my_shop/provider/orders.dart';
import 'package:my_shop/provider/products.dart';
import 'package:my_shop/screens/4.1%20auth_screen.dart';
import 'package:my_shop/screens/cart_screen.dart';
import 'package:my_shop/screens/edit_products_screen.dart';
import 'package:my_shop/screens/orders_screen.dart';
import 'package:my_shop/screens/product_details.dart';
import 'package:my_shop/screens/product_overview_screen.dart';
import 'package:my_shop/screens/user_products_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
            value: Auth()),
        ChangeNotifierProvider.value(
          value: Products(),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProvider.value(
          value: Orders(),
        )
      ],
      child : Consumer<Auth>(builder: (context,auth,_)=>MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MyShop',
        theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato'),
        home: auth.isAuth?ProductOverviewScreen() : AuthScreen(),
        routes: {
          ProductOverviewScreen.poScreen:(_)=>ProductOverviewScreen(),
          ProductDetails.productDetailsRouteName: (_) => ProductDetails(),
          CartScreenOverView.cSRouteName:(_)=> CartScreenOverView(),
          OrdersScreen.ordersScreenRouteName:(_)=> OrdersScreen(),
          UserProductsScreen.usprouteName:(_)=> UserProductsScreen(),
          EditPrpductsScreen.epsRouteName:(_)=> EditPrpductsScreen(),
        },
      ),
      )
    );
  }
}
