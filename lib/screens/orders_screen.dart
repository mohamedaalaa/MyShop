import 'package:flutter/material.dart';
import 'package:my_shop/provider/orders.dart';
import 'package:my_shop/widgets/app_drawer.dart';
import 'package:provider/provider.dart';

import 'ordr_item.dart';

class OrdersScreen extends StatelessWidget {

  static const String ordersScreenRouteName = 'ordersRouteName';

  @override
  Widget build(BuildContext context) {
    //final orderData=Provider.of<Orders>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Products'),
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
            future:
                Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
            builder: (context, dataSnapshot) {
              if (dataSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              else {

                if (dataSnapshot.error != null) {
                  return Center(
                    child: Text('An error occurred'),
                  );
                } else {
                  return Consumer<Orders>(
                    builder: (context, orderData, child) => ListView.builder(
                        itemCount: orderData.orders.length,
                        itemBuilder: (context, index) =>
                            ChangeNotifierProvider.value(
                              value: orderData.orders[index],
                              child: OrderItem(),
                            )),
                  );
                }
              }
            }));
  }
}
