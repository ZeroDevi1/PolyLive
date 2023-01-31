import 'dart:convert';

import 'package:poly_live/common/utils/log.dart';
import 'package:http/http.dart' as http;

import '../utils/md5.dart';

/// 解析huya
Future<String> parseHuyaUrl(String roomInfo) async {
  String url = 'https://m.huya.com/$roomInfo';
  var resp = await http.get(
    Uri.parse(url),
    headers: {
      'User-Agent':
          'Mozilla/5.0 (iPhone; CPU iPhone OS 12_4_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148'
    },
  );
  // print(resp.body);
  // resp.body 进行正则查找 window\.HNF_GLOBAL_INIT.=.\{(.*?)\}.</script>
  var reg = RegExp(r'window\.HNF_GLOBAL_INIT.=.\{(.*?)\}.</script>');
  var match = reg.firstMatch(resp.body);
  if (match != null) {
    var jsonStr = '{${match.group(1)}}';
    var json = jsonDecode(jsonStr);
    // 获取 roomProfile 里面的 liveLineUrl
    var liveLineUrl = json['roomProfile']['liveLineUrl'];
    // 使用base64解码,并且重新编码成utf-8
    var decodeUrl = utf8.decode(base64.decode(liveLineUrl));
    // 把 符合 .*?\.hls\.huya\.com 正则替换为 https://tx.hls.huya.com，选择线路
    var lineData = decodeUrl.replaceAll(
        RegExp(r'.*?\.hls\.huya\.com'), 'https://tx.hls.huya.com');
    // 把 line_data 中的 hls.huya.com 替换为 flv.huya.com，_2000替换为"",ratio=2000&替换为"",.m3u8替换为.flv
    lineData =
        lineData.replaceAll(RegExp(r'hls\.huya\.com'), 'flv.huya.com');
    lineData = lineData.replaceAll(RegExp(r'_2000'), '');
    lineData = lineData.replaceAll(RegExp(r'ratio=2000&'), '');
    lineData = lineData.replaceAll(RegExp(r'\.m3u8'), '.flv');
    // 获取 fm=xxx&,里面的xxx字符串
    var fm = RegExp(r'fm=(.*?)&').firstMatch(lineData);
    var fmStr = fm!.group(1);
    // 对 fmStr 进行Uri解码
    fmStr = Uri.decodeComponent(fmStr!);
    // 对 fmStrDecode 进行 base64 解码,并且转换成 utf-8
    fmStr = utf8.decode(base64.decode(fmStr));
    // fmStr 根据_分割成数组
    var fmStrArr = fmStr.split('_');
    // 获取第1个值,赋值为p
    var p = fmStrArr[0];
    // 生成时间戳 *10000000
    var time = (DateTime.now().millisecondsSinceEpoch * 10000000).toString();
    // 把 liveLineUrlStr 根据?进行拆分,获取第0个的数据
    var liveLineUrlStrArr = lineData.split('?');
   var liveLineUrlStr = liveLineUrlStrArr[0];
    // 然后根据 / 拆分，获取最后一个数据
    var liveLineUrlStrArr2 = liveLineUrlStr.split('/');
    liveLineUrlStr = liveLineUrlStrArr2[liveLineUrlStrArr2.length - 1];
    // 把 live_line_url 的 .flv|.m3u8 替换为 ""
    var streamName = liveLineUrlStr.replaceAll(RegExp(r'\.flv|.m3u8'), '');
    // 获取 line_data 中 wsTime的值
    var wsTime = RegExp(r'wsTime=(.*?)&').firstMatch(lineData);
    var wsTimeStr = wsTime!.group(1);
    // 拼接新的 newWsSecret ${p}_0_${streamName}_${time}_${wsTime}
    var newWsSecret = '${p}_0_${streamName}_${time}_$wsTimeStr';
    // newWsSecret 进行 MD5 编码
    newWsSecret = generateMd5(newWsSecret);
    // 通过正则替换 wsSecret=xxx& 为 wsSecret=newWsSecret&
    lineData =
        lineData.replaceAll(RegExp(r"wsSecret=\w+&"), newWsSecret);
    // 添加 参数 seqid，值为 time
    lineData = '$lineData&seqid=$time';
    // 把 fm 参数和值通过正则删除
    lineData = lineData.replaceAll(RegExp(r'fm=\w+&'), '');
    // 把 ctype 参数和值通过正则删除
    lineData = lineData.replaceAll(RegExp(r'ctype=\w+&'), '');
    // 输出最终的直播地址
    Log.i(lineData);
    return lineData;
  }
  return '';
}
