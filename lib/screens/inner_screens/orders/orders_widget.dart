import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import '../../../widgets/subtitle_text.dart';
import '../../../widgets/title_text.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import '../../../providers/orders_provider.dart';

class OrdersWidget extends StatelessWidget {
  final String orderId;
  final String productTitle;
  final double price;
  final int quantity;
  final String imageUrl;
  final String username;

  const OrdersWidget({
    required this.orderId,
    required this.productTitle,
    required this.price,
    required this.quantity,
    required this.imageUrl,
    required this.username,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double totalPrice = price * quantity;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: FancyShimmerImage(
              height: size.width * 0.25,
              width: size.width * 0.25,
              imageUrl: imageUrl,
            ),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: TitlesTextWidget(
                          label: productTitle,
                          maxLines: 2,
                          fontSize: 15,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          try {
                            await Provider.of<OrdersProvider>(context, listen: false).deleteOrder(orderId);
                            if (context.mounted) {
                              showToast(
                                'Order deleted successfully',
                                context: context,
                                backgroundColor: Colors.green,
                                textStyle: const TextStyle(color: Colors.white),
                                position: StyledToastPosition.bottom,
                                animation: StyledToastAnimation.slideFromBottomFade,
                                reverseAnimation: StyledToastAnimation.fade,
                                duration: const Duration(seconds: 4),
                              );
                            }
                          } catch (e) {
                            // Handle the error if needed
                          }
                        },
                        icon: const Icon(
                          Icons.clear,
                          color: Colors.red,
                          size: 22,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const TitlesTextWidget(
                        label: 'Price:  ',
                        fontSize: 15,
                      ),
                      Flexible(
                        child: SubtitleTextWidget(
                          label: "${price.toStringAsFixed(2)} \₪",
                          fontSize: 15,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  SubtitleTextWidget(
                    label: "Qty: $quantity",
                    fontSize: 15,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  SubtitleTextWidget(
                    label: "Total: ${totalPrice.toStringAsFixed(2)} \₪",
                    fontSize: 15,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  SubtitleTextWidget(
                    label: "User: $username",
                    fontSize: 15,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
