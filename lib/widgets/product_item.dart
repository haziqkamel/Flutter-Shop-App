import 'package:flutter/material.dart';
import 'package:flutter_shop_app/models/product.dart';
import 'package:flutter_shop_app/providers/cart.dart';
import 'package:flutter_shop_app/screens/product_detail_screen.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;

  // ProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    final productItem = Provider.of<Product>(context, listen: false);
    final cartItem = Provider.of<Cart>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: productItem.id,
            );
          },
          child: Image.network(
            productItem.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            builder: (ctx, productItem, _) => IconButton(
              color: Theme.of(context).accentColor,
              icon: Icon(
                productItem.isFavorite ? Icons.favorite : Icons.favorite_border,
              ),
              onPressed: () {
                productItem.toogleFavStatus();
              },
            ),
            // child: Text('Never changes!'),
          ),
          trailing: IconButton(
            color: Theme.of(context).accentColor,
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              cartItem.addItem(
                  //add Items selected to cart
                  productItem.id,
                  productItem.price,
                  productItem.title);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              //SnackBars
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Item added to cart!'),
                duration: Duration(seconds: 2),
                action: SnackBarAction(
                  label: 'UNDO',
                  onPressed: () {
                    cartItem.removeSingleItem(productItem.id);
                  },
                ),
              ));
            },
          ),
          title: Text(
            productItem.title,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
