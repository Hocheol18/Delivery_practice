import 'package:delivery/common/provider/pagination_provider.dart';
import 'package:flutter/material.dart';

class PaginationUtils {
  static void paginate({
    required ScrollController controller,
    required PaginationProvider provider,
  }) {
    // 현재 위치가 최대 길이보다 조금 덜되는 위치까지 왔다면
    // 새로운 데이터 추가 요청

    // 최대 길이보다 300 픽셀 위에 도달하면
    if (controller.offset > controller.position.maxScrollExtent - 400) {
      provider.paginate(fetchMore: true);
    }
  }
}
