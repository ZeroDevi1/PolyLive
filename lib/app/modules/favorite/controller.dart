import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:poly_live/common/api/live_api.dart';
import 'package:poly_live/common/models/live_room.dart';
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
    await  _getRoomInfoFromApi();
  }


  Future<void> moveRoomToTop(RoomInfo roomInfo) async {
    Log.d('moveRoomToTop: ${roomInfo.roomId}');
    final index = _roomList.indexWhere((element) =>
    element.roomId == roomInfo.roomId);
    if (index == -1) {
      return;
    }
    _roomList.removeAt(index);
    _roomList.insert(0, roomInfo);
    _saveToPref();
    notifyListeners();
  }

  void _loadRoomList() {
    _roomList.clear();
    _onlineRoomList.clear();
    var prefList = PrefUtil.getStringList('favorites') ?? [];
    _roomList.addAll(prefList.map((e) => RoomInfo.fromJson(jsonDecode(e))));
    _onlineRoomList.addAll(
        _roomList.where((element) => element.liveStatus == LiveStatus.live));
  }

  // 判断是否已经收藏
  bool isFavorite(String roomId) {
    return _roomList.any((element) => element.roomId == roomId);
  }

  // 移出收藏
  void removeRoom(RoomInfo roomInfo) {
    _roomList.removeWhere((element) => element.roomId == roomInfo.roomId);
    _onlineRoomList.removeWhere((element) => element.roomId == roomInfo.roomId);
    _saveToPref();
    notifyListeners();
  }

  // 添加收藏
  void addRoom(RoomInfo roomInfo) {
    if (roomInfo.title.isEmpty || roomInfo.cover.isEmpty ||
        roomInfo.avatar.isEmpty) {
      return;
    }
    // 判断是否已经收藏
    if (isFavorite(roomInfo.roomId)) {
      return;
    }
    _roomList.add(roomInfo);
    if (roomInfo.liveStatus == LiveStatus.live) {
      _onlineRoomList.add(roomInfo);
    }
    _saveToPref();
    notifyListeners();
  }

  // 保存到本地
  _saveToPref() {
    PrefUtil.setStringList(
        'favorites', _roomList.map((e) => jsonEncode(e.toJson())).toList());
  }

  // 从服务器获取直播间信息
  Future<void> _getRoomInfoFromApi() async {
    for (int i = 0; i < _roomList.length; i++) {
      _roomList[i] = await LiveApi.getRoomInfoApi(_roomList[i]);
    }
    notifyListeners();
    _saveToPref();
  }
}
