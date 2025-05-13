import 'package:delivery/common/model/cursor_pagination_model.dart';
import 'package:delivery/common/provider/pagination_provider.dart';
import 'package:delivery/restaurant/repository/restaurant_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/restaurant_model.dart';

final restaurantDetailProvider = Provider.family<RestaurantModel?, String>((
  ref,
  id,
) {
  final state = ref.watch(restaurantProvider);

  if (state is! CursorPagination) {
    return null;
  }

  return state.data.firstWhere((element) => element.id == id);
});

final restaurantProvider =
    StateNotifierProvider<RestaurantStateNotifier, CursorPaginationBase>((ref) {
      final repository = ref.watch(restaurantRepositoryProvider);
      final notifier = RestaurantStateNotifier(repository: repository);
      return notifier;
    });

class RestaurantStateNotifier extends PaginationProvider<RestaurantModel, RestaurantRepository> {

  // RestaurantStateNotifier 클래스가 실행되자마자 paginate 함수가 바로 실행됨.
  RestaurantStateNotifier({required super.repository});


  // 캐싱
  void getDetail({required String id}) async {
    // 만약에 아직 데이터가 하나도 없는 상태라면 (CursorPagination이 아니라면)
    // 데이터를 가져오는 시도를 한다.
    if (state is! CursorPagination) {
      await paginate();
    }

    // state가 CursorPagination이 아닐 때 , 그냥 리턴
    if (state is! CursorPagination) {
      return;
    }

    // 무조건 CursorPagination
    final pState = state as CursorPagination;

    final resp = await repository.getRestaurantDetail(id: id);

    // [RestaurantModel(1), RestaurantModel(2), RestaurantModel(3)]
    // id : 2인 Detail 모델을 가져와라
    // getDetail(id : 2)
    // [RestaurantModel(1), RestaurantDetailModel(2), RestaurantModel(3)]
    state = pState.copyWith(
      data: pState.data.map<RestaurantModel>((e) => e.id == id ? resp : e).toList(),
    );
  }
}
