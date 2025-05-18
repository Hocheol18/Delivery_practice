import 'package:delivery/common/const/colors.dart';
import 'package:delivery/common/layout/default_layout.dart';
import 'package:delivery/product/model/product_model.dart';
import 'package:delivery/rating/component/rating_card.dart';
import 'package:delivery/rating/model/rating_model.dart';
import 'package:delivery/restaurant/component/restaurant_card.dart';
import 'package:delivery/restaurant/provider/restaurant_rating_provider.dart';
import 'package:delivery/restaurant/repository/restaurant_repository.dart';
import 'package:delivery/restaurant/view/basket_screen.dart';
import 'package:delivery/user/provider/basket_provider.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../common/model/cursor_pagination_model.dart';
import '../../common/utils/pagination_utils.dart';
import '../../product/component/product_card.dart';
import '../model/restaurant_detail_model.dart';
import '../model/restaurant_model.dart';
import '../provider/restaurant_provider.dart';
import 'package:badges/badges.dart';

class RestaurantDetailScreen extends ConsumerStatefulWidget {
  static String get routeName => 'restaurantDetailScreen';
  final String id;

  const RestaurantDetailScreen({super.key, required this.id});

  @override
  ConsumerState<RestaurantDetailScreen> createState() =>
      _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState
    extends ConsumerState<RestaurantDetailScreen> {
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();

    ref.read(restaurantProvider.notifier).getDetail(id: widget.id);

    controller.addListener(listener);
  }

  void listener() {
    PaginationUtils.paginate(
      controller: controller,
      provider: ref.read(restaurantRatingProvider(widget.id).notifier),
    );
  }

  Future<RestaurantDetailModel> getRestaurantDetail(WidgetRef ref) async {
    return ref
        .watch(restaurantRepositoryProvider)
        .getRestaurantDetail(id: widget.id);

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
    final ratingsState = ref.watch(restaurantRatingProvider(widget.id));
    final basket = ref.watch(basketProvider);

    if (state == null) {
      return DefaultLayout(child: Center(child: CircularProgressIndicator()));
    }

    return DefaultLayout(
      title: '불타는 떡볶이',
      floatingActionbutton: FloatingActionButton(
        // 스택 위에 쌓이는 방식
        onPressed: () {
          context.pushNamed(BasketScreen.routeName);
        },
        backgroundColor: PRIMARY_COLOR,
        child: Badge(
          showBadge: basket.isNotEmpty,
          badgeContent: Text(
            basket
                .fold<int>(0, (previous, next) => previous + next.count)
                .toString(),
            style: TextStyle(color: PRIMARY_COLOR, fontSize: 11.0),
          ),
          badgeStyle: BadgeStyle(badgeColor: Colors.white),
          child: Icon(Icons.shopping_basket_outlined, color: Colors.white),
        ),
      ),
      child: CustomScrollView(
        controller: controller,
        slivers: [
          renderTop(model: state),
          if (state is! RestaurantDetailModel) renderLoading(),
          if (state is RestaurantDetailModel) renderLabel(),
          if (state is RestaurantDetailModel)
            renderProduct(products: state.products, restaurant: state),
          if (ratingsState is CursorPagination<RatingModel>)
            renderRaings(models: ratingsState.data),
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

  SliverPadding renderLoading() {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      sliver: Skeletonizer.sliver(
        effect: ShimmerEffect(
          baseColor: Colors.grey,
          highlightColor: Colors.white,
          duration: Duration(seconds: 2),
        ),
        child: SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            return Card(
              color: Colors.white,
              elevation: 0, // 쉐도우 제거
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.zero, // 모서리 둥글기 제거
                side: BorderSide.none, // 외곽선 제거
              ),
              child: ListTile(
                title: Text('abcdefud'),
                subtitle: Text('helloWorldNiceToMeetYou'),
              ),
            );
          }, childCount: 6),
        ),
      ),
    );
  }

  SliverPadding renderProduct({
    required RestaurantModel restaurant,
    required List<RestaurantProductModel> products,
  }) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final model = products[index];
          return InkWell(
            onTap: () {
              ref
                  .read(basketProvider.notifier)
                  .addToBasket(
                    product: ProductModel(
                      name: model.name,
                      detail: model.detail,
                      imgUrl: model.imgUrl,
                      price: model.price,
                      restaurant: restaurant,
                      id: model.id,
                    ),
                  );
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: ProductCard.fromRestaurantProductModel(model: model),
            ),
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

SliverPadding renderRaings({required List<RatingModel> models}) {
  return SliverPadding(
    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
    sliver: SliverList(
      delegate: SliverChildBuilderDelegate(
        (_, index) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: RatingCard.fromModel(model: models[index]),
        ),
        childCount: models.length,
      ),
    ),
  );
}
