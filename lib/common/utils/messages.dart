import 'package:get/get.dart';

class Messages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'zh_CN': {
          'favorite': '关注',
          'setting': '设置',
          'remove': '移除',
          'Move to Top': '置顶',
          'Input Room Keyword': '输入房间关键字',
          'Select Platform': '选择直播平台',
          'Huya': '虎牙'
        },
        'en_US': {
          'favorite': 'Favorite',
          'setting': 'Setting',
          'remove': 'Remove',
          'Move to Top': 'Move to Top',
          'Input Room Keyword': 'Input Room Keyword',
          'Select Platform': 'Select Platform',
          'Huya': 'Huya'
        }
      };
}
