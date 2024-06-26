import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'consts/theme_data.dart';
import 'providers/cart_provider.dart';
import 'providers/order_provider.dart';
import 'providers/product_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/user_provider.dart';
import 'providers/viewed_prod_provider.dart';
import 'providers/wishlist_provider.dart';
import 'root_screen.dart';
import 'screens/auth/forgot_password.dart';
import 'screens/auth/login.dart';
import 'screens/auth/register.dart';
import 'screens/inner_screens/orders/orders_screen.dart';
import 'screens/inner_screens/product_details.dart';
import 'screens/inner_screens/viewed_recently.dart';
import 'screens/inner_screens/wishlist.dart';
import 'screens/search_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid ? await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyBxU7D-agwmxkAip_cJsnI0xls6TQbQOVM',
      appId: '1:577423224501:android:8d4cd48f1d4560850558fc',
      messagingSenderId: '577423224501',
      projectId: 'twins-shop',
      storageBucket: "twins-shop.appspot.com",
    ),
  ).whenComplete((){
  })
      : await Firebase.initializeApp().whenComplete(() {});
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
          future: Firebase.initializeApp(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (snapshot.hasError) {
              return Scaffold(
                body: Center(
                  child: SelectableText(
                      "An error has been occured ${snapshot.error}"),
                ),
              );
            }
            return MultiProvider(
              providers: [
                ChangeNotifierProvider(
                  create: (_) => ThemeProvider(),
                ),
                ChangeNotifierProvider(
                  create: (_) => ProductProvider(),
                ),
                ChangeNotifierProvider(
                  create: (_) => CartProvider(),
                ),
                ChangeNotifierProvider(
                  create: (_) => WishlistProvider(),
                ),
                ChangeNotifierProvider(
                  create: (_) => ViewedProdProvider(),
                ),
                ChangeNotifierProvider(
                  create: (_) => UserProvider(),
                ),
                ChangeNotifierProvider(
                  create: (_) => OrdersProvider(),
                ),
              ],
              child: Consumer<ThemeProvider>(
                builder: (
                  context,
                  themeProvider,
                  child,
                ) {
                  return MaterialApp(
                    debugShowCheckedModeBanner: false,
                    title: 'Shop Smart AR',
                    theme: Styles.themeData(
                        isDarkTheme: themeProvider.getIsDarkTheme,
                        context: context),
                    home: const RootScreen(),
                    // home: const RegisterScreen(),
                    routes: {
                      ProductDetails.routName: (context) =>
                          const ProductDetails(),
                      WishlistScreen.routName: (context) =>
                          const WishlistScreen(),
                      ViewedRecentlyScreen.routName: (context) =>
                          const ViewedRecentlyScreen(),
                      RegisterScreen.routName: (context) =>
                          const RegisterScreen(),
                      LoginScreen.routName: (context) => const LoginScreen(),
                      OrdersScreenFree.routeName: (context) =>
                          const OrdersScreenFree(),
                      ForgotPasswordScreen.routeName: (context) =>
                          const ForgotPasswordScreen(),
                      SearchScreen.routeName: (context) => const SearchScreen(),
                      RootScreen.routName: (context) => const RootScreen(),
                    },
                  );
                },
              ),
            );
          }),
    );
  }
}
