import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:poly_live/common/models/live_room.dart';
import 'package:poly_live/common/utils/log.dart';

/// 虎牙直播平台
class HuyaApi {
  static Future<RoomInfo> getRoomInfo(String keyword) async {
    var roomInfo = RoomInfo("0");
    String url = 'https://m.huya.com/$keyword';
    var body = await _getUrl(url);
    // resp.body 进行正则查找 window\.HNF_GLOBAL_INIT.=.\{(.*?)\}.</script>
    var reg = RegExp(r'window\.HNF_GLOBAL_INIT.=.\{(.*?)\}.</script>');
    var match = reg.firstMatch(body);
    if (match == null) {
      return roomInfo;
    }
    var jsonStr = '{${match.group(1)}}';
    var json = jsonDecode(jsonStr);
    print(json);
    // 获取 roomInfo
    var roomInfoJson = json['roomInfo'];
    roomInfo.nick = roomInfoJson['tProfileInfo']['sNick'];
    roomInfo.avatar = roomInfoJson['tProfileInfo']['sAvatar180'];
    roomInfo.roomId = roomInfoJson['tProfileInfo']['lProfileRoom'].toString();
    roomInfo.platform = "huya";
    roomInfo.title = roomInfoJson['tLiveInfo']['sRoomName'];
    roomInfo.followers =
        roomInfoJson['tProfileInfo']['lActivityCount'].toString();
    roomInfo.cover = roomInfoJson['tLiveInfo']['sScreenshot'];
    roomInfo.area = roomInfoJson['tLiveInfo']['sGameFullName'];
    return roomInfo;
  }

  static Future<dynamic> _getUrl(String url) async {
    var resp = await http.get(
      Uri.parse(url),
      headers: {
        'User-Agent':
            'Mozilla/5.0 (iPhone; CPU iPhone OS 12_4_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148'
      },
    );
    return resp.body;
  }

  // 获取直播间信息
  static Future<RoomInfo> getRoomInfoApi(RoomInfo roomInfo) async {
    String url = 'https://mp.huya.com/cache.php?m=Live'
        '&do=profileRoom&roomid=${roomInfo.roomId}';
    var result = await _getUrl(url);
    var response = jsonDecode(result);
    if (response['status'] == 200) {
      dynamic data = response['data'];

      roomInfo.platform = 'huya';
      roomInfo.userId = data['profileInfo']?['uid']?.toString() ?? '';
      roomInfo.nick = data['profileInfo']?['nick'] ?? '';
      roomInfo.title = data['liveData']?['introduction'] ?? '';
      roomInfo.cover = data['liveData']?['screenshot'] ?? '';
      roomInfo.avatar = data['profileInfo']?['avatar180'] ?? '';
      roomInfo.area = data['liveData']?['gameFullName'] ?? '';
      roomInfo.watching = data['liveData']?['attendeeCount']?.toString() ?? '';
      roomInfo.followers = data['liveData']?['totalCount']?.toString() ?? '';

      final liveStatus = data['liveStatus'] ?? 'OFF';
      if (liveStatus == 'OFF' || liveStatus == 'FREEZE') {
        roomInfo.liveStatus = LiveStatus.offline;
      } else if (liveStatus == 'REPLAY') {
        roomInfo.liveStatus = LiveStatus.replay;
      } else {
        roomInfo.liveStatus = LiveStatus.live;
      }
    }

    return roomInfo;
  }

  static Future<Map<String, Map<String, String>>> getLiveStreamUrl(
      RoomInfo roomInfo) async {
    Map<String, Map<String, String>> links = {};
    String url = 'https://mp.huya.com/cache.php?m=Live'
        '&do=profileRoom&roomid=${roomInfo.roomId}';

    try {
      var result = await _getUrl(url);
      var response = jsonDecode(result);
      if (response['status'] == 200) {
        Map streamDict = response['data']['stream']['flv'];

        // 获取支持的分辨率
        Map resolutions = {};
        List rateArray = streamDict['rateArray'];
        for (Map res in rateArray) {
          String bitrate = res['iBitRate'].toString();
          resolutions[res['sDisplayName']] = '_$bitrate';
        }

        // 获取支持的线路
        List multiLine = streamDict['multiLine'];
        links['原画'] = {};
        for (Map item in multiLine) {
          String url = (item['url']).replaceAll('http://', 'https://');
          String cdn = item['cdnType'];
          links['原画']![cdn] = url;
          for (var resolution in resolutions.keys) {
            String key = resolutions[resolution];
            String tempUrl = url.replaceAll('imgplus.flv', 'imgplus$key.flv');
            if (links[resolution] == null) links[resolution] = {};
            links[resolution]![cdn] = tempUrl;
          }
        }
      }
    } catch (e) {
      return links;
    }
    // 循环输出
    return links;
  }
}
