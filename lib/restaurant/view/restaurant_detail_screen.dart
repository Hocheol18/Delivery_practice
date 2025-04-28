import 'package:delivery/common/layout/default_layout.dart';
import 'package:delivery/restaurant/component/restaurant_card.dart';
import 'package:flutter/material.dart';

import '../../product/component/product_card.dart';

class RestaurantDetailScreen extends StatelessWidget {
  const RestaurantDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '불타는 떡볶이',
      child: CustomScrollView(
        slivers: [renderTop(), renderLabel(), renderProduct()],
      ),
    );
  }

  SliverPadding renderProduct() {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          return Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: ProductCard(),
          );
        }, childCount: 10),
      ),
    );
  }
}

SliverPadding renderLabel() {
  return SliverPadding(
    padding: EdgeInsets.symmetric(horizontal: 16.0),
    sliver: SliverToBoxAdapter(
      child: Text('메뉴', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),),
    ),
  );
}

SliverToBoxAdapter renderTop() {
  return SliverToBoxAdapter(
    child: RestaurantCard(
      image: Image.asset('asset/img/food/ddeok_bok_gi.jpg'),
      name: '불타는 떡볶이',
      deliveryFee: 3000,
      tags: ['jwt', 'gmt', 'asd'],
      ratings: 4.76,
      ratingsCount: 100,
      devlieryTime: 30,
      detail: "맛잇음",
      isDetail: true,
    ),
  );
}
