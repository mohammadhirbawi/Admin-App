import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import '../../../widgets/subtitle_text.dart';
import '../../../widgets/title_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import '../../../services/my_app_method.dart';

class OrdersWidgetFree extends StatefulWidget {
  final String orderId;
  final String productTitle;
  final double price;
  final int quantity;
  final String imageUrl;
  final String username;

  const OrdersWidgetFree({
    required this.orderId,
    required this.productTitle,
    required this.price,
    required this.quantity,
    required this.imageUrl,
    required this.username,
    super.key,
  });

  @override
  State<OrdersWidgetFree> createState() => _OrdersWidgetFreeState();
}

class _OrdersWidgetFreeState extends State<OrdersWidgetFree> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double totalPrice = widget.price * widget.quantity;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: FancyShimmerImage(
              height: size.width * 0.25,
              width: size.width * 0.25,
              imageUrl: widget.imageUrl,
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
                          label: widget.productTitle,
                          maxLines: 2,
                          fontSize: 15,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          try {
                            setState(() {
                              isLoading = true;
                            });
                            await FirebaseFirestore.instance
                                .collection('ordersAdvanced')
                                .doc(widget.orderId)
                                .delete();
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
                          } catch (e) {
                            MyAppMethods.showErrorORWarningDialog(
                              context: context,
                              subtitle: e.toString(),
                              fct: () {},
                            );
                          } finally {
                            setState(() {
                              isLoading = false;
                            });
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
                          label: "${widget.price.toStringAsFixed(2)} \$",
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
                    label: "Qty: ${widget.quantity}",
                    fontSize: 15,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  SubtitleTextWidget(
                    label: "Total: ${totalPrice.toStringAsFixed(2)} \$",
                    fontSize: 15,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  SubtitleTextWidget(
                    label: "User: ${widget.username}",
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
