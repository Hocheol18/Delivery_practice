import 'package:delivery/common/model/cursor_pagination_model.dart';
import 'package:delivery/restaurant/model/restaurant_model.dart';
import 'package:delivery/restaurant/view/restaurant_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../component/restaurant_card.dart';
import '../provider/restaurant_provider.dart';
import '../repository/restaurant_repository.dart';

class RestaurantScreen extends ConsumerStatefulWidget {
  const RestaurantScreen({super.key});

  @override
  ConsumerState<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends ConsumerState<RestaurantScreen> {
  Future<CursorPagination<RestaurantModel>> paginateRestaurant(
    WidgetRef ref,
  ) async {
    final paginate = ref.watch(restaurantRepositoryProvider).paginate();
    return paginate;
    // final dio = ref.watch(dioProvider);
    //
    // final resp = await RestaurantRepository(dio, baseUrl: 'http://$ip/restaurant').paginate();
    //
    // return resp.data;
  }

  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();

    controller.addListener(scrollListener);
  }

  void scrollListener() {
    // 현재 위치가 최대 길이보다 조금 덜되는 위치까지 왔다면
    // 새로운 데이터 추가 요청

    // 최대 길이보다 300 픽셀 위에 도달하면
    if (controller.offset > controller.position.maxScrollExtent - 400) {
      ref.read(restaurantProvider.notifier).paginate(fetchMore: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(restaurantProvider);

    // 클래스를 생성했기 때문에 is로 비교 가능
    // 처음 로딩 상황
    if (data is CursorPaginationLoading) {
      return Center(child: CircularProgressIndicator());
    }

    // 에러 발생 상황
    if (data is CursorPaginationError) {
      return Center(child: Text(data.message));
    }

    final cp = data as CursorPagination;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ListView.separated(
        controller: controller,
        itemBuilder: (_, index) {
          if (index == cp.data.length) {
            return Center(
              child:
                  data is CursorPaginationFetchingMore
                      ? CircularProgressIndicator()
                      : Text('데이터가 없습니다.'),
            );
          }

          final pItem = cp.data[index];
          // 파싱

          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => RestaurantDetailScreen(id: pItem.id),
                ),
              );
            },
            child: RestaurantCard.fromModel(model: pItem),
          );
        },
        separatorBuilder: (_, index) {
          return SizedBox(height: 16.0);
        },
        itemCount: cp.data.length + 1,
      ),
    );
  }
}
