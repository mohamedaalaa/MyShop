import 'package:flutter/material.dart';
import 'package:my_shop/provider/cart.dart';
import 'package:my_shop/provider/products.dart';
import 'package:my_shop/screens/cart_screen.dart';
import 'package:my_shop/widgets/21.1%20badge.dart';
import 'package:my_shop/widgets/app_drawer.dart';
import 'package:my_shop/widgets/product_item.dart';
import 'package:provider/provider.dart';

enum FilterOptions { Favorites, All }

class ProductOverviewScreen extends StatefulWidget {
  static const poScreen='/povs';
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {



  @override

  @override
  Widget build(BuildContext context) {
    var _showFavoritesOnly = false;
    return Scaffold(
            appBar: AppBar(
              title: Text('MyShop'),
              actions: <Widget>[
                PopupMenuButton(
                  onSelected: (FilterOptions selectedValue) {
                    setState(() {
                      if (selectedValue == FilterOptions.Favorites) {
                        _showFavoritesOnly = true;
                      } else {
                        _showFavoritesOnly = false;
                      }
                    });
                  },
                  icon: Icon(Icons.more_vert),
                  itemBuilder: (_) => [
                    PopupMenuItem(
                      child: Text('only favorites'),
                      value: FilterOptions.Favorites,
                    ),
                    PopupMenuItem(
                      child: Text('ShowAll'),
                      value: FilterOptions.All,
                    ),
                  ],
                ),
                Consumer<Cart>(
                  builder: (BuildContext context, value, ch) => Badge(
                    child: IconButton(
                      icon: Icon(Icons.shopping_cart),
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(CartScreenOverView.cSRouteName);
                      },
                    ),
                    value: value.itemsCount.toString(),
                  ),
                )
              ],
            ),
            drawer: AppDrawer(),
            body: FutureBuilder(
              future:Provider.of<Products>(context,listen: false).fetchAndSetProducts(),builder: (context,dataSnapshot){
              if(dataSnapshot.connectionState==ConnectionState.waiting){
                return Center(child:CircularProgressIndicator(),);
              }
                /*if(dataSnapshot.error!=null){
                  print(dataSnapshot.error);
                  return Center(child:Text(dataSnapshot.error.toString()),);
                }*/

                else{
                  return Consumer<Products>(builder: (context,viewData,child){
                    return buildGridView(context, _showFavoritesOnly);
                  });
                }
            } ,)
    );
  }
}

Widget buildGridView(BuildContext context, bool showFavoritesOnly) {
  final products = Provider.of<Products>(context);
  final productsData =
      showFavoritesOnly ? products.favoriteItems : products.items;

  return GridView.builder(
    padding: const EdgeInsets.all(10),
    itemCount: productsData.length,
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      childAspectRatio: 3 / 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 5,
    ),
    itemBuilder: (context, index) => ChangeNotifierProvider.value(
      value: productsData[index],
      child: ProductItem(),
    ),
  );
}
