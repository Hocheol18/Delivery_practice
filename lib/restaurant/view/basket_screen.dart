import 'package:delivery/common/const/colors.dart';
import 'package:delivery/common/layout/default_layout.dart';
import 'package:delivery/order/provider/order_provider.dart';
import 'package:delivery/order/view/order_done_screen.dart';
import 'package:delivery/product/component/product_card.dart';
import 'package:delivery/user/provider/basket_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class BasketScreen extends ConsumerWidget {
  static String get routeName => 'basket';

  const BasketScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final basket = ref.watch(basketProvider);

    if (basket.isEmpty) {
      return DefaultLayout(
        title: '장바구니',
        child: Center(child: Text('장바구니가 비었습니다.')),
      );
    }

    final int productsTotal = basket.fold<int>(
      0,
      (p, n) => p + n.product.price * n.count,
    );
    final int deliveryFee = basket.first.product.restaurant.deliveryFee;

    return DefaultLayout(
      title: '장바구니',
      child: SafeArea(
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (_, index) {
                    return Divider(height: 32.0);
                  },
                  itemBuilder: (_, index) {
                    final model = basket[index];
                    return ProductCard.fromProductModel(
                      model: model.product,
                      onAdd: () {
                        ref
                            .read(basketProvider.notifier)
                            .addToBasket(product: model.product);
                      },
                      onSubtract: () {
                        ref
                            .read(basketProvider.notifier)
                            .removeFromBasket(product: model.product);
                      },
                    );
                  },
                  itemCount: basket.length,
                ),
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('장바구니 금액', style: TextStyle(color: BODY_TEXT_COLOR)),
                      Text('₩${productsTotal.toString()}'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('배달비', style: TextStyle(color: BODY_TEXT_COLOR)),
                      if (basket.isNotEmpty) Text('₩${deliveryFee.toString()}'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('총액', style: TextStyle(fontWeight: FontWeight.w500)),
                      Text('₩${(deliveryFee + productsTotal).toString()}'),
                    ],
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        final resp = await ref.read(orderProvider.notifier).postOrder();

                        if (resp) {
                          // ignore: use_build_context_synchronously
                          context.goNamed(OrderDoneScreen.routeName);

                        } else {
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar((SnackBar(content : Text('결제 실패!'))));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: PRIMARY_COLOR,
                      ),
                      child: Text(
                        '결제하기',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


}
