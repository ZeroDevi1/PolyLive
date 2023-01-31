import 'package:poly_live/common/models/liveroom.dart';

/// 直播相关接口
class LiveApi {
  static Future<void> getRoomInfo(Platforms platform, String keyword) async {
    switch (platform) {
      case Platforms.huya:
        break;
      case Platforms.douyu:
        break;
      case Platforms.bilibili:
        break;
      default:
        break;
    }
  }
}
