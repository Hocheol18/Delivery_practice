import 'package:flutter/material.dart';

// 모든 화면에 공통적으로 실행시키는 로직
// API 호출인 경우 이렇게 사용한다.
class DefaultLayout extends StatelessWidget {
  final Widget child;

  const DefaultLayout({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: child,
    );
  }
}
