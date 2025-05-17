import 'dart:convert';

import '../const/securetoken.dart';

class DataUtils {
  static String pathToUrl(String value) {
    return 'http://$ip$value';
  }

  static List<String> listPathsToUrls(List paths) {
    return paths.map((e) => pathToUrl(e)).toList();
  }

  static String plainToBase64(String plain) {
    // 이렇게 인코딩함
    Codec<String, String> stringToBase64 = utf8.fuse(base64);

    return stringToBase64.encode(plain);
  }

}