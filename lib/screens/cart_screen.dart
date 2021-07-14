import 'package:flutter/material.dart';
import 'package:flutter_shop_app/providers/cart.dart';
import 'package:flutter_shop_app/providers/orders.dart';
import 'package:provider/provider.dart';
import '../widgets/cart_item.dart' as ci;

class CartScreen extends StatelessWidget {
  // const CartScreen({Key? key}) : super(key: key);

  static const routeName = '/cartScreen';

  @override
  Widget build(BuildContext context) {
    final cartItem = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  // SizedBox(
                  //   width: 10,
                  // ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${cartItem.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        color:
                            Theme.of(context).primaryTextTheme.headline6.color,
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  TextButton(
                    onPressed: () {
                      Provider.of<Orders>(context, listen: false).addOrder(
                        cartItem.items.values.toList(),
                        cartItem.totalAmount,
                      );
                      cartItem.clear();
                    },
                    child: Text('Order Now'),
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(
                        Colors.amber,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cartItem.items.length,
              itemBuilder: (ctx, i) => ci.CartItemWidget(
                cartItem.items.values.toList()[i].id,
                cartItem.items.keys.toList()[i],
                cartItem.items.values.toList()[i].price,
                cartItem.items.values.toList()[i].quantity,
                cartItem.items.values.toList()[i].title,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
