import 'package:delivery/common/const/colors.dart';
import 'package:delivery/common/layout/default_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  static String get routeName => 'splash';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultLayout(
      backgroundColor: PRIMARY_COLOR,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'asset/img/logo/logo.png',
              width: MediaQuery.of(context).size.width / 2,
            ),
            const SizedBox(height: 16.0),
            CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}
