import 'package:delivery/common/model/cursor_pagination_model.dart';
import 'package:delivery/common/provider/pagination_provider.dart';
import 'package:delivery/order/model/order_model.dart';
import 'package:delivery/order/model/post_order_body.dart';
import 'package:delivery/order/repository/order_repository.dart';
import 'package:delivery/user/model/basket_item_model.dart';
import 'package:delivery/user/provider/basket_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final orderProvider =
    StateNotifierProvider<OrderStateNotifier, CursorPaginationBase>((ref) {
      final repo = ref.watch(orderRepositoryProvider);
      return OrderStateNotifier(ref: ref, repository: repo);
    });

class OrderStateNotifier
    extends PaginationProvider<OrderModel, OrderRepository> {
  final Ref ref;

  OrderStateNotifier({required this.ref, required super.repository});

  void _optimisticResponsePostOrder({
    required String id,
    required List<BasketItemModel> products,
    required int totalPrice,
    required DateTime createdAt,
  }) {
    final newOrder = OrderModel(
      id: id,
      restaurant: products.first.product.restaurant,
      totalPrice: totalPrice,
      createdAt: createdAt,
      products:
          products
              .map(
                (e) => OrderProductCountModel(
                  product: OrderProductModel(
                    id: e.product.id,
                    name: e.product.name,
                    price: e.product.price,
                    detail: e.product.detail,
                    imgUrl: e.product.imgUrl,
                  ),
                  count: e.count,
                ),
              )
              .toList(),
    );

    if (state is CursorPagination<OrderModel>) {
      final oldState = state as CursorPagination<OrderModel>;

      state = oldState.copyWith(data: [newOrder, ...oldState.data]);
    }
  }

  Future<bool> postOrder() async {
    try {
      final uuid = Uuid();
      final id = uuid.v4();
      final state = ref.read(basketProvider);
      final List<PostOrderBodyProduct> products =
          state
              .map(
                (e) => PostOrderBodyProduct(
                  count: e.count,
                  productId: e.product.id,
                ),
              )
              .toList();

      final int totalPrice = state.fold<int>(
        0,
        (prev, nxt) => prev + (nxt.count * nxt.product.price),
      );

      final DateTime createdAt = DateTime.now();

      _optimisticResponsePostOrder(
        id: id,
        products: state,
        totalPrice: totalPrice,
        createdAt: createdAt,
      );

      await repository.postOrder(
        body: PostOrderBody(
          id: id,
          products: products,
          totalPrice: totalPrice,
          createdAt: createdAt.toString(),
        ),
      );

      return true;
    } catch (e) {
      return false;
    }
  }
}
