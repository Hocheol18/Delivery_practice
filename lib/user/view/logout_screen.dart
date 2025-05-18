import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/user_me_provider.dart';

class LogoutScreen extends ConsumerWidget {
  const LogoutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(child: ElevatedButton(onPressed: () {
      ref.read(userMeProvider.notifier).logout();
    }, child: Text('로그아웃')),);
  }
}
