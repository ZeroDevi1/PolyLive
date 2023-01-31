import 'package:poly_live/common/api/platform/huya.dart';
import 'package:poly_live/common/models/live_room.dart';
import 'package:poly_live/common/utils/log.dart';

/// 直播相关接口
class LiveApi {
  static Future<RoomInfo> getRoomInfo(Platforms platform, String keyword) async {
    switch (platform) {
      case Platforms.huya:
       return HuyaApi.getRoomInfo(keyword);
      case Platforms.douyu:
        return RoomInfo('0');
      case Platforms.bilibili:
        return RoomInfo('0');
      default:
        return RoomInfo('0');
    }
  }

  /// 获取直播流地址
  static Future<dynamic> getLiveStreamUrl(RoomInfo roomInfo) async {
    Log.d('getLiveStreamUrl: ${roomInfo.platform} ${roomInfo.roomId}');
    switch (roomInfo.platform) {
      case 'huya':
        return  HuyaApi.getLiveStreamUrl(roomInfo);
      case 'douyu':
         return '0';
      case 'bilibili':
        return '0';
      default:
        return '0';
    }
  }

  /// 获取直播间信息
  static Future<RoomInfo> getRoomInfoApi(RoomInfo roomInfo)  async{
    switch (roomInfo.platform) {
      case 'huya':
        return  HuyaApi.getRoomInfoApi(roomInfo);
      case 'douyu':
        return RoomInfo('0');
      case 'bilibili':
        return RoomInfo('0');
      default:
        return RoomInfo('0');
    }
  }
}
