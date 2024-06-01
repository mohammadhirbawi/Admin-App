import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../services/assets_manager.dart';
import '../../../widgets/empty_bag.dart';
import '../../../widgets/title_text.dart';
import 'orders_widget.dart';
import '../../../providers/orders_provider.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/OrderScreen';

  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<OrdersProvider>(context, listen: false).fetchOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ordersProvider = Provider.of<OrdersProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const TitlesTextWidget(
          label: 'Placed Orders',
        ),
      ),
      body: ordersProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ordersProvider.errorMessage != null
          ? Center(child: Text('Something went wrong: ${ordersProvider.errorMessage}'))
          : ordersProvider.orders.isEmpty
          ? EmptyBagWidget(
        imagePath: AssetsManager.order,
        title: "No orders have been placed yet",
        subtitle: "",
      )
          : ListView.separated(
        itemCount: ordersProvider.orders.length,
        itemBuilder: (ctx, index) {
          final orderData = ordersProvider.orders[index];
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
      ),
    );
  }
}
