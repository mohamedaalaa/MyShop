import 'package:flutter/material.dart';
import 'package:my_shop/provider/cart.dart';
import 'package:my_shop/provider/orders.dart';
import 'package:my_shop/widgets/cart_item.dart';
import 'package:provider/provider.dart';

class CartScreenOverView extends StatelessWidget {
  static const cSRouteName = '/cast_screen_routeName';



  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final cartItems = Provider.of<Cart>(context).items;
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Cart"),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      'Label',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple),
                    ),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                          color: Theme.of(context)
                              .primaryTextTheme
                              .headline6!
                              .color),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  BuildButton(cart: cart, cartItems: cartItems),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (context, index) => CartItemView(
                cartItems.values.toList()[index].id,
                cartItems.keys.toList()[index],
                cartItems.values.toList()[index].title,
                cartItems.values.toList()[index].quantity,
                cartItems.values.toList()[index].price,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BuildButton extends StatefulWidget {
  const BuildButton({
    Key? key,
    required this.cart,
    required this.cartItems,
  }) : super(key: key);

  final Cart cart;
  final Map<String, CartItem> cartItems;

  @override
  _BuildButtonState createState() => _BuildButtonState();
}

class _BuildButtonState extends State<BuildButton> {
  var _isLoading=false;
  @override
  Widget build(BuildContext context) {
    return _isLoading?Center(child:CircularProgressIndicator(),) : TextButton(
      onPressed:(widget.cart.totalAmount<=0||_isLoading) ? null: ()async{
        setState(() {
          _isLoading=true;
        });

          await Provider.of<Orders>(context, listen: false)
              .addOrder(
            widget.cartItems.values.toList(),
            widget.cart.totalAmount,
          );
          setState(() {
            _isLoading=false;
          });
        widget.cart.clearItems();

      },
      child:Text(
        'ORDER NOW',
        style: TextStyle(
          color: Colors.purple,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
