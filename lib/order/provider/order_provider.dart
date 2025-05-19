import 'package:delivery/order/model/order_model.dart';
import 'package:delivery/order/model/post_order_body.dart';
import 'package:delivery/order/repository/order_repository.dart';
import 'package:delivery/user/provider/basket_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final orderProvider =
    StateNotifierProvider<OrderStateNotifier, List<OrderModel>>((ref) {
      final repo = ref.watch(orderRepositoryProvider);
      return OrderStateNotifier(ref: ref, repository: repo);
    });

class OrderStateNotifier extends StateNotifier<List<OrderModel>> {
  final Ref ref;
  final OrderRepository repository;

  OrderStateNotifier({required this.ref, required this.repository}) : super([]);

  Future<bool> postOrder() async {
    try {
      final uuid = Uuid();

      final id = uuid.v4();

      final state = ref.read(basketProvider);

      await repository.postOrder(
        body: PostOrderBody(
          id: id,
          products:
              state
                  .map(
                    (e) => PostOrderBodyProduct(
                      count: e.count,
                      productId: e.product.id,
                    ),
                  )
                  .toList(),
          totalPrice: state.fold<int>(
            0,
            (p, n) => p + (n.count * n.product.price),
          ),
          createdAt: DateTime.now().toString(),
        ),
      );

      return true;
    } catch (e) {
      return false;
    }
  }
}
