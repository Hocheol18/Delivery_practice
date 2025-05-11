import 'package:delivery/common/layout/default_layout.dart';
import 'package:delivery/restaurant/component/restaurant_card.dart';
import 'package:delivery/restaurant/repository/restaurant_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../product/component/product_card.dart';
import '../model/restaurant_detail_model.dart';
import '../model/restaurant_model.dart';
import '../provider/restaurant_provider.dart';

class RestaurantDetailScreen extends ConsumerStatefulWidget {
  final String id;

  const RestaurantDetailScreen({super.key, required this.id});

  @override
  ConsumerState<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends ConsumerState<RestaurantDetailScreen> {

  @override
  void initState() {
    super.initState();

    ref.read(restaurantProvider.notifier).getDetail(id: widget.id);
  }

  Future<RestaurantDetailModel> getRestaurantDetail(WidgetRef ref) async {
    return ref.watch(restaurantRepositoryProvider).getRestaurantDetail(id: widget.id);

    // final dio = ref.watch(dioProvider);
    //
    // final repository = RestaurantRepository(dio, baseUrl: 'http://$ip/restaurant');
    //
    // return repository.getRestaurantDetail(id: id);

    // final accessToken = await storage.read(key: ACCESS_TOKEN);
    //
    // final resp = await dio.get(
    //   'http://$ip/restaurant/$id',
    //   options: Options(headers: {'authorization': 'Bearer $accessToken'}),
    // );
    //
    // return resp.data;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(restaurantDetailProvider(widget.id));

    if (state == null) {
      return DefaultLayout(child: Center(child: CircularProgressIndicator()));
    }

    return DefaultLayout(
      title: '불타는 떡볶이',
      child: CustomScrollView(
        slivers: [
          renderTop(model: state),
          if (state is RestaurantDetailModel)
          renderLabel(),
          if (state is RestaurantDetailModel)
          renderProduct(products: state.products),
        ],
      ),

      // FutureBuilder<RestaurantDetailModel>(
      //   future: getRestaurantDetail(ref),
      //   builder: (_, AsyncSnapshot<RestaurantDetailModel> snapshot) {
      //     if(!snapshot.hasData) {
      //       return Center(
      //         child: CircularProgressIndicator(),
      //       );
      //     }
      //     return CustomScrollView(
      //       slivers: [renderTop(model : snapshot.data!), renderLabel(), renderProduct(products: snapshot.data!.products)],
      //     );
      //   },
      // ),
    );
  }

  SliverPadding renderProduct({
    required List<RestaurantProductModel> products,
  }) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final model = products[index];
          return Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: ProductCard.fromModel(model: model),
          );
        }, childCount: products.length),
      ),
    );
  }
}

SliverPadding renderLabel() {
  return SliverPadding(
    padding: EdgeInsets.symmetric(horizontal: 16.0),
    sliver: SliverToBoxAdapter(
      child: Text(
        '메뉴',
        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
      ),
    ),
  );
}

SliverToBoxAdapter renderTop({required RestaurantModel model}) {
  return SliverToBoxAdapter(
    child: RestaurantCard.fromModel(model: model, isDetail: true),
  );
}
