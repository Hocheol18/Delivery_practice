import 'package:delivery/common/layout/default_layout.dart';
import 'package:delivery/user/view/logout_screen.dart';
import 'package:flutter/material.dart';

import '../../product/view/product_screen.dart';
import '../../restaurant/view/restaurant_screen.dart';
import '../const/colors.dart';

class RootTab extends StatefulWidget {
  static String get routeName => 'home';

  const RootTab({super.key});

  @override
  State<RootTab> createState() => _RootTabState();
}

class _RootTabState extends State<RootTab> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  int currentIndex = 0;

  @override
  void initState() {
    super.initState();

    // this 넣기 위해서는 SingleTickerProviderStateMixin 이거 필요
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(tabListener);
  }

  @override
  void dispose() {
    _tabController.removeListener(tabListener);
    super.dispose();
  }

  void tabListener() {
    setState(() {
      currentIndex = _tabController.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '호철 딜리버리',
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: PRIMARY_COLOR,
        unselectedItemColor: BODY_TEXT_COLOR,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          _tabController.animateTo(index);
        },
        currentIndex: currentIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: '홈'),
          BottomNavigationBarItem(
            icon: Icon(Icons.fastfood_outlined),
            label: '음식',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            label: '주문',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: '프로필',
          ),
        ],
      ),
      child: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: [
          RestaurantScreen(),
          ProductScreen(),
          Text('주문'),
          LogoutScreen(),
        ],
      ),
    );
  }
}
