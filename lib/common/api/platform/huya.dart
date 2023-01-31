import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:poly_live/common/models/liveroom.dart';
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
    Log().d(json);
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
}
