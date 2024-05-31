import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../services/assets_manager.dart';
import '../../../widgets/empty_bag.dart';
import '../../../widgets/title_text.dart';
import 'orders_widget.dart';

class OrdersScreenFree extends StatefulWidget {
  static const routeName = '/OrderScreen';

  const OrdersScreenFree({Key? key}) : super(key: key);

  @override
  State<OrdersScreenFree> createState() => _OrdersScreenFreeState();
}

class _OrdersScreenFreeState extends State<OrdersScreenFree> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TitlesTextWidget(
          label: 'Placed Orders',
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('ordersAdvanced').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return EmptyBagWidget(
              imagePath: AssetsManager.order,
              title: "No orders have been placed yet",
              subtitle: "",
            );
          }

          final orders = snapshot.data!.docs;

          return ListView.separated(
            itemCount: orders.length,
            itemBuilder: (ctx, index) {
              final orderData = orders[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
                child: OrdersWidget(
                  orderId: orderData['orderId'],
                  productTitle: orderData['productTitle'],
                  price: orderData['price'],
                  quantity: orderData['quantity'],
                  imageUrl: orderData['imageUrl'],
                  username: orderData['userName'],
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const Divider();
            },
          );
        },
      ),
    );
  }
}
