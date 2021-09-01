import 'package:flutter/material.dart';
import 'package:my_shop/provider/products.dart';
import 'package:my_shop/screens/edit_products_screen.dart';
import 'package:my_shop/widgets/app_drawer.dart';
import 'package:my_shop/widgets/user_produts_item.dart';
import 'package:provider/provider.dart';

class UserProductsScreen extends StatelessWidget {
  const UserProductsScreen({Key? key}) : super(key: key);
  static const usprouteName = '/u_p_s_routeName';

  Future<void> _refresh(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchAndSetProducts();
  }

  @override
  Widget build(BuildContext context) {
    //final products = Provider.of<Products>(context).items;
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditPrpductsScreen.epsRouteName,
                  arguments: {'id': '', 'title': 'new product'});
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () {
          return _refresh(context);
        },
        child: Padding(
            padding: const EdgeInsets.all(8),
            child: FutureBuilder(
              future: Provider.of<Products>(context, listen: false)
                  .fetchAndSetProducts(),
              builder: (context, dataSnapshot) {
                if (dataSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (dataSnapshot.error != null) {
                  return Center(
                    child: Text('An error occurred'),
                  );
                } else {
                  return Consumer<Products>(builder: (context,viewData,child)=>
                    ListView.builder(
                      itemCount: viewData.items.length,
                      itemBuilder: (context, index) =>
                          ChangeNotifierProvider.value(
                            value: viewData.items[index],
                            child: Column(
                              children: <Widget>[
                                UserProductsItem(),
                                Divider(),
                              ],
                            ),
                          ),
                    )
                  );

                }
              },
            )),
      ),
    );
  }
}
