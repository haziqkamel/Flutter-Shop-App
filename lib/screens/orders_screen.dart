import 'package:flutter/material.dart';
import 'package:flutter_shop_app/providers/orders.dart';
import 'package:flutter_shop_app/widgets/app_drawer.dart';
import '../widgets/order_item.dart' as o;
import 'package:provider/provider.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = 'Orders';
  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      body: ListView.builder(
        itemCount: orderData.orders.length,
        itemBuilder: (ctx, i) => o.OrderItem(
          orderData.orders[i],
        ),
      ),
      drawer: AppDrawer(),
    );
  }
}
