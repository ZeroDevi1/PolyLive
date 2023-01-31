import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poly_live/app/modules/favorite/controller.dart';
import 'package:poly_live/common/api/live_api.dart';
import 'package:poly_live/common/models/live_room.dart';
import 'package:poly_live/common/utils/log.dart';
import 'package:poly_live/common/widgets/empty_view.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController controller = TextEditingController();
  var platform = Platforms.huya.obs;
  late FavoriteProvider favoritePod = Provider.of<FavoriteProvider>(context);
  final List<RoomInfo> _ownerList = [];

  @override
  Widget build(BuildContext context) {
    var appBarHeight = AppBar().preferredSize.height;
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: InputDecoration(
            hintText: 'Input Room Keyword'.tr,
            // border: InputBorder.none,
            hintStyle: const TextStyle(fontSize: 13.0),
          ),
          controller: controller,
          onSubmitted: _onSearch,
        ),
        centerTitle: true,
        actions: [
          PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return [
                _buildPopupMenuItem(
                    Platforms.huya.name.tr, null, Platforms.huya.index),
              ];
            },
            offset: Offset(0.0, appBarHeight),
            tooltip: 'Select Platform'.tr,
            onSelected: (value) {
              platform.value = value;
            },
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8.0),
                bottomRight: Radius.circular(8.0),
                topLeft: Radius.circular(8.0),
                topRight: Radius.circular(8.0),
              ),
            ),
          )
        ],
      ),
      body: _ownerList.isNotEmpty
          ? ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(8),
              itemCount: _ownerList.length,
              itemBuilder: (context, index) {
                final roomInfo = _ownerList[index];
                return OwnerCard(
                  room: roomInfo,
                  favoritePod: favoritePod,
                );
              },
            )
          : EmptyView(
              icon: Icons.live_tv_rounded,
              title: 'empty_search_title'.tr,
              subtitle: 'empty_search_subtitle'.tr,
            ),
    );
  }

  // 搜索直播间
  void _onSearch(String value) {
    // 清空当前直播间
    setState(() {
      _ownerList.clear();
    });
    // 获取直播间
    LiveApi.getRoomInfo(platform.value, value).then((value) {
      setState(() {
        _ownerList.add(value);
      });
    });
  }

  PopupMenuItem _buildPopupMenuItem(
      String title, IconData? iconData, int position) {
    return PopupMenuItem(
      value: position,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          if (iconData != null) Icon(iconData),
          Text(title),
        ],
      ),
    );
  }
}

class OwnerCard extends StatelessWidget {
  const OwnerCard({Key? key, required this.room, required this.favoritePod})
      : super(key: key);
  final RoomInfo room;
  final FavoriteProvider favoritePod;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          room.nick,
          maxLines: 1,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          '${room.platform}-${room.area}',
          maxLines: 1,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        trailing: favoritePod.isFavorite(room.roomId)
            ? ElevatedButton(
                onPressed: () {
                  favoritePod.removeRoom(room);
                },
                child: Text('Followed'.tr),
              )
            : ElevatedButton(
                onPressed: () {
                  favoritePod.addRoom(room);
                },
                child: Text('Follow'.tr),
              ),
        onTap: () => _onTap(context),
        leading: CircleAvatar(
          foregroundImage: room.avatar.isNotEmpty
              ? CachedNetworkImageProvider(room.avatar)
              : null,
          radius: 20,
          backgroundColor: Theme.of(context).disabledColor,
        ),
      ),
    );
  }

  void _onTap(BuildContext context) async {
    // TODO 跳转视频播放
  }
}
