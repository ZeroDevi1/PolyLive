import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:poly_live/app/modules/search/view.dart';
import 'package:poly_live/common/models/liveroom.dart';
import 'package:poly_live/common/widgets/empty_view.dart';
import 'package:poly_live/common/widgets/room_card.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'controller.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  final RefreshController refreshController =
      RefreshController(initialRefresh: false);
  late FavoriteProvider favorite = Provider.of<FavoriteProvider>(context);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = screenWidth > 1280
        ? 4
        : (screenWidth > 960 ? 3 : (screenWidth > 640 ? 2 : 1));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'favorite'.tr,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        scrolledUnderElevation: screenWidth > 640 ? 0 : null,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const SearchPage()));
            },
          ),
        ],
      ),
      body: SmartRefresher(
        enablePullDown: true,
        header: const WaterDropHeader(),
        controller: refreshController,
        // onRefresh: () => favorite.onRefresh().then((value) {
        //   refreshController.refreshCompleted();
        // }),
        child: favorite.roomList.isNotEmpty
            ? MasonryGridView.count(
                padding: const EdgeInsets.all(8),
                controller: ScrollController(),
                crossAxisCount: crossAxisCount,
                itemCount: favorite.roomList.length,
                itemBuilder: (context, index) {
                  return RoomCard(
                    room: favorite.roomList[index],
                    dense: screenWidth < 640,
                    onLongPress: () =>
                        onLongPress(context, favorite.roomList[index]),
                  );
                })
            : EmptyView(
                icon: Icons.favorite_rounded,
                title: 'favorite_empty'.tr,
                subtitle: 'favorite_empty_subtitle'.tr,
              ),
      ),
    );
  }

  // 直播间Card长按事件
  onLongPress(BuildContext context, RoomInfo roomInfo) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(roomInfo.title),
        content: const Text('是否取消收藏？'),
        actions: [
          TextButton(
              onPressed: () {
                favorite.removeRoom(roomInfo);
                Navigator.of(context).pop();
              },
              child: Text('remove'.tr)),
          TextButton(
              onPressed: () {
                favorite.moveRoomToTop(roomInfo);
                Navigator.of(context).pop();
              },
              child: Text('Move to Top'.tr))
        ],
      ),
    );
  }
}
