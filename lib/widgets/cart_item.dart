import 'package:flutter/material.dart';
import 'package:my_shop/provider/cart.dart';
import 'package:provider/provider.dart';

class CartItemView extends StatelessWidget {
  final String id;
  final String productId;
  final String title;
  final int quantity;
  final double price;

  CartItemView(
    this.id,
    this.productId,
    this.title,
    this.quantity,
    this.price,
  );

  @override
  Widget build(BuildContext context) {
    final removeItemCart = Provider.of<Cart>(context);
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Colors.purpleAccent,
        child: Icon(
          Icons.delete,
          color:Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        removeItemCart.removeItem(productId);
      },
      confirmDismiss: (direction){
        return showDialog(context: context, builder: (context)=>
            AlertDialog(
              title: Text("Are You Sure?"),
              content: Text('Do You Want To Remove The Item?'),
              actions:<Widget>[
                TextButton(onPressed: (){
                 Navigator.of(context).pop(true);
                }, child: Text('YES'),
                ),
                TextButton(onPressed: (){
                  Navigator.of(context).pop(false);
                }, child: Text('NO'),
                ),
              ],
            ),
        );
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: FittedBox(
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text('\$$price'),
                ),
              ),
            ),
            title: Text(
              title,
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
            ),
            subtitle: Text(
              'total:\$${(price * quantity)}',
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),
            ),
            trailing: Text(
              '$quantity x',
              style: TextStyle(fontSize: 15),
            ),
          ),
        ),
      ),
    );
  }
}
