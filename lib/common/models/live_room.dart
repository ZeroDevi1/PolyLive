enum LiveStatus { live, offline, replay, unknown }

enum Platforms { huya, bilibili, douyu, unknown }

class RoomInfo {
  String roomId;
  String userId = '';
  String link = '';
  String title = '';
  String nick = '';
  String avatar = '';
  String cover = '';
  String area = '';
  String watching = '';
  String followers = '';
  String platform = 'UNKNOWN';
  LiveStatus liveStatus = LiveStatus.unknown;

  RoomInfo(this.roomId);

  RoomInfo.fromJson(Map<String, dynamic> json)
      : roomId = json['roomId'] ?? '',
        userId = json['userId'] ?? '',
        title = json['title'] ?? '',
        link = json['link'] ?? '',
        nick = json['nick'] ?? '',
        avatar = json['avatar'] ?? '',
        cover = json['cover'] ?? '',
        area = json['area'] ?? '',
        watching = json['watching'] ?? '',
        followers = json['followers'] ?? '',
        platform = json['platform'] ?? '',
        liveStatus = LiveStatus.values[json['liveStatus']];

  Map<String, dynamic> toJson() => <String, dynamic>{
        'roomId': roomId,
        'userId': userId,
        'title': title,
        'nick': nick,
        'avatar': avatar,
        'cover': cover,
        'area': area,
        'watching': watching,
        'followers': followers,
        'platform': platform,
        'liveStatus': liveStatus.index
      };
}
