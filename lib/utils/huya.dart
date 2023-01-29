import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// 解析huya
Future<void> parseHuyaUrl(String roomInfo) async {
  var dio = Dio();
  dio.options.headers["User-Agent"] = "Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1 Edg/91.0.4472.69";
  var response = await dio.get("https://www.huya.com/$roomInfo");
  print(response);
  if (response.statusCode == 200) {
    // 请求成功
    var liveStream = response.data;
    // 可以使用liveStream变量来访问直播流
    if (kDebugMode) {
      print(liveStream);
    }
  } else {
    // 请求失败
    if (kDebugMode) {
      print("Failed to get live stream.");
    }
  }
}