import 'package:flutter/material.dart';
import 'package:flutter_shop_app/providers/auth.dart';
import 'package:flutter_shop_app/providers/cart.dart';
import 'package:flutter_shop_app/providers/orders.dart';
import 'package:flutter_shop_app/providers/products_provider.dart';
import 'package:flutter_shop_app/screens/auth_screen.dart';
import 'package:flutter_shop_app/screens/cart_screen.dart';
import 'package:flutter_shop_app/screens/edit_product_screen.dart';
import 'package:flutter_shop_app/screens/orders_screen.dart';
import 'package:flutter_shop_app/screens/products_overview_screen.dart';
import 'package:flutter_shop_app/screens/splash_screen.dart';
import 'package:flutter_shop_app/screens/user_products_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_shop_app/screens/product_detail_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, ProductsProvider>(
          create: (ctx) => ProductsProvider('', '', []),
          update: (ctx, auth, previousState) => ProductsProvider(
            auth.token,
            auth.userId,
            previousState.items == null ? [] : previousState.items,
          ),
          // previousState..authToken = auth.token,
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (ctx) => Orders('', '', []),
          update: (ctx, auth, previousState) => Orders(
            auth.token,
            auth.userId,
            previousState == null ? [] : previousState.orders,
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'My Shop',
          theme: ThemeData(
            primarySwatch: Colors.amber,
            accentColor: Colors.amberAccent,
            fontFamily: 'Lato',
          ),
          home: auth.isAuth //true?
              ? ProductsOverviewScreen() //Go
              : FutureBuilder(
                  //else
                  future: auth.tryAutoLogin(), //try autoLogin
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting //autoLogin state waiting?
                          ? SplashScreen() //show splash screen
                          : auth.isAuth //else isAuth true?
                              ? ProductsOverviewScreen() //show
                              : AuthScreen(), //else login
                ),
          routes: {
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            UserProductScreen.routeName: (ctx) => UserProductScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
