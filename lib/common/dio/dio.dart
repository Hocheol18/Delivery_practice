// ignore_for_file: avoid_print

import 'package:delivery/common/const/securetoken.dart';
import 'package:delivery/user/provider/auth_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../secure_storage/secure_storage.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();

  final storage = ref.watch(secureStorageProvider);
  
  dio.interceptors.add(
    CustomInterceptor(storage: storage, ref: ref)
  );

  return dio;
});


class CustomInterceptor extends Interceptor {
  final Ref ref;
  final FlutterSecureStorage storage;

  CustomInterceptor({required this.storage, required this.ref});

  // 1) 요청 보낼 때
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    print('[REQ], [${options.method}], ${options.uri}');

    // 만약 요청 Headers에 accessToken : true 값이 있다면
    // 실제 토큰을 가져와서 (storage) authorization : Bearer $token으로 헤더를 변경한다.
    if (options.headers['accessToken'] == 'true') {
      // 헤더 삭제
      options.headers.remove('accessToken');

      final token = await storage.read(key: ACCESS_TOKEN);

      // 실제 토큰으로 변경
      options.headers.addAll({'authorization': 'Bearer $token'});
    }

    if (options.headers['refreshToken'] == 'true') {
      // 헤더 삭제
      options.headers.remove('refreshToken');

      final token = await storage.read(key: REFRESH_TOKEN);

      // 실제 토큰으로 변경
      options.headers.addAll({'authorization': 'Bearer $token'});
    }

    return super.onRequest(options, handler);
  }

  // 2) 응답을 받을 때
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('[RES], [${response.requestOptions.method}], ${response.requestOptions.uri}');


    super.onResponse(response, handler);
  }

  // 3) 에러 났을 때
  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // 401에러가 났을 때 (status code)
    // 토큰을 재발급 받는 시도를 하고, 토큰이 재발급되면
    // 다시 새로운 토큰으로 요청을 한다.
    print('[ERR], [${err.requestOptions}], ${err.requestOptions.uri}');

    final refreshToken = await storage.read(key: REFRESH_TOKEN);

    // refreshToken이 아예 없으면
    // 에러 던진다
    if (refreshToken == null) {
      // 에러 던질때는 handler.reject 사용한다.
      return handler.reject(err);
    }

    final isStatus401 = err.response?.statusCode == 401;
    final isPathRefresh = err.requestOptions.path == '/auth/token';

    // 인증 오류이고, 만약에 토큰을 발급받는 의도가 아니었다면 -> 다시 토큰을 받아서 재전송
    if (isStatus401 && !isPathRefresh) {
      final dio = Dio();

      try {
        final resp = await dio.post(
          'http://$ip/auth/token',
          options: Options(headers: {'authorization': 'Bearer $refreshToken'}),
        );

        final accessToken = resp.data['accessToken'];

        final options = err.requestOptions;

        // 토큰변경
        options.headers.addAll({'authorization': 'Bearer $accessToken'});

        // 스토리지에 accessToken 저장
        storage.write(key: ACCESS_TOKEN, value: accessToken);

        // 요청 재전송
        final response = await dio.fetch(options);

        // 이 경우에는 다시 요청을 실행시킴.
        return handler.resolve(response);
      } on DioException catch (e) {
        // RefreshToken 마저 만료되었을 경우
        // circular dependency error
        // UserMeProvider -> dio -> UserMeProvider -> dio
        ref.read(authProvider.notifier).logout();
        return handler.reject(e);
      }
    }

    return super.onError(err, handler);
  }
}
