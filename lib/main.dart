import 'package:admin_app/consts/theme_data.dart';
import 'package:admin_app/providers/product_provider.dart';
import 'package:admin_app/providers/theme_provider.dart';
import 'package:admin_app/screens/dashboard_screen.dart';
import 'package:admin_app/screens/edit_upload_product_form.dart';
import 'package:admin_app/screens/inner_screens/orders/orders_screen.dart';
import 'package:admin_app/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';

import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCafT4k49z1hH0KYgTklSj0Cw7RoqsGgL4",
      appId: "1:542912087664:android:cefc6fa368d82ecf4e16b5",
      messagingSenderId: "542912087664",
      projectId: "techtacelectro",
      storageBucket: "techtacelectro.appspot.com",
    ),
  );
  runApp(const MyApp());
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
              ],
              child: Consumer<ThemeProvider>(builder: (
                context,
                themeProvider,
                child,
              ) {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'Shop Smart ADMIN AR',
                  theme: Styles.themeData(
                      isDarkTheme: themeProvider.getIsDarkTheme,
                      context: context),
                  home: const DashboardScreen(),
                  routes: {
                    OrdersScreenFree.routeName: (context) =>
                        const OrdersScreenFree(),
                    SearchScreen.routeName: (context) => const SearchScreen(),
                    EditOrUploadProductScreen.routeName: (context) =>
                        const EditOrUploadProductScreen(),
                  },
                );
              }),
            );
          }),
    );
  }
}
