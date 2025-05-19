import 'package:delivery/common/const/colors.dart';
import 'package:flutter/material.dart';

import '../model/order_model.dart';

class OrderCard extends StatelessWidget {
  final DateTime orderDate;
  final Image image;
  final int price;
  final String name;
  final String productsDetail;

  const OrderCard({
    super.key,
    required this.name,
    required this.image,
    required this.price,
    required this.productsDetail,
    required this.orderDate,
  });

  factory OrderCard.fromModel({required OrderModel model}) {
    final productsDetail =
        model.products.length < 2
            ? model.products.first.product.name
            : '${model.products.first.product.name} 외 ${model.products.length - 1}개';

    return OrderCard(
      name: model.restaurant.name,
      image: Image.network(
        model.restaurant.thumbUrl,
        height: 50.0,
        width: 50.0,
        fit: BoxFit.cover,
      ),
      price: model.totalPrice,
      productsDetail: productsDetail,
      orderDate: model.createdAt,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          // 2025.05.01
          '${orderDate.year}.${orderDate.month.toString().padLeft(2, '0')}.${orderDate.day.toString().padLeft(2, '0')} 주문완료',
        ),
        const SizedBox(height: 8.0),
        Row(
          children: [
            ClipRRect(borderRadius: BorderRadius.circular(16.0), child: image),
            const SizedBox(width: 16.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: TextStyle(fontSize: 14.0)),
                Text(
                  '$productsDetail $price원',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: BODY_TEXT_COLOR,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
