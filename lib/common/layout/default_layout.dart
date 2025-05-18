import 'package:flutter/material.dart';

// 모든 화면에 공통적으로 실행시키는 로직
// API 호출인 경우 이렇게 사용한다.
class DefaultLayout extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final String? title;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionbutton;

  const DefaultLayout({
    super.key,
    this.backgroundColor,
    this.title,
    this.bottomNavigationBar,
    required this.child,
    this.floatingActionbutton,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? Colors.white,
      appBar: renderAppBar(),
      body: child,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionbutton,
    );
  }

  AppBar? renderAppBar() {
    if (title == null) {
      return null;
    } else {
      return AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          title!,
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
        ),
        foregroundColor: Colors.black,
      );
    }
  }
}
