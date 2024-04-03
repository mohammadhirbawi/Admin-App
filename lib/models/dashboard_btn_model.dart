import 'package:admin_app/screens/edit_upload_product_form.dart';
import 'package:admin_app/screens/inner_screens/orders/orders_screen.dart';
import 'package:admin_app/screens/search_screen.dart';
import 'package:admin_app/services/assets_manager.dart';
import 'package:flutter/material.dart';

class DashBoardButtonModel {
  final String text, imagePath;
  final Function onPressed;

  DashBoardButtonModel({
    required this.text,
    required this.imagePath,
    required this.onPressed,
  });
  static List<DashBoardButtonModel> dashboardBtnList(BuildContext context) => [
        DashBoardButtonModel(
          text: "Add a new product",
          imagePath: AssetsManager.cloud,
          onPressed: () {
            Navigator.pushNamed(context, UploadProductScreen.routName);
          },
        ),
        DashBoardButtonModel(
          text: "Inspect all products",
          imagePath: AssetsManager.shoppingCart,
          onPressed: () {
            Navigator.pushNamed(context, SearchScreen.routeName);
          },
        ),
        DashBoardButtonModel(
          text: "View Orders",
          imagePath: AssetsManager.order,
          onPressed: () {
            Navigator.pushNamed(context, OrdersScreenFree.routeName);
          },
        ),
      ];
}
