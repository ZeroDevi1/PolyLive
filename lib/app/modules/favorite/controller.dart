import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:poly_live/common/models/liveroom.dart';
import 'package:poly_live/common/utils/log.dart';
import 'package:poly_live/common/utils/pref_util.dart';

class FavoriteProvider with ChangeNotifier {
  final BuildContext context;

  FavoriteProvider(this.context) {
    onRefresh();
  }

  // 所有添加的直播间
  final List<RoomInfo> _roomList = [];

  // 所有在线的直播间
  final List<RoomInfo> _onlineRoomList = [];

  // TODO 配置显示所有直播间还是只显示在线直播间
  List<RoomInfo> get roomList => _roomList;

  Future<void> onRefresh() async {
    _loadRoomList();
  }

  Future<void> removeRoom(RoomInfo roomInfo) async {
    Log().d('removeRoom: ${roomInfo.roomId}');
  }

  Future<void> moveRoomToTop(RoomInfo roomInfo) async {
    Log().d('moveRoomToTop: ${roomInfo.roomId}');
  }

  void _loadRoomList() {
    _roomList.clear();
    _onlineRoomList.clear();
    var prefList = PrefUtil.getStringList('favorite') ?? [];
    _roomList.addAll(prefList.map((e) => RoomInfo.fromJson(jsonDecode(e))));
    _onlineRoomList.addAll(
        _roomList.where((element) => element.liveStatus == LiveStatus.live));
  }
}
