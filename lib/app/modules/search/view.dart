import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poly_live/common/api/live_api.dart';
import 'package:poly_live/common/models/liveroom.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController controller = TextEditingController();
  var platform = Platforms.huya.obs;

  final List<RoomInfo> _ownerList = [];

  @override
  Widget build(BuildContext context) {
    int _index =
        0; // Make sure this is outside build(), otherwise every setState will chage the value back to 0

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
                PopupMenuItem(
                  value: Platforms.huya,
                  child: Text('Huya'.tr),
                )
              ];
            },
            tooltip: 'Select Platform'.tr,
            onSelected: (value) {
              platform.value = value;
            },
          )
        ],
      ),
      body: Center(
        child: Container(
            child: Text(
                'You are looking at the message for bottom navigation item $_index')),
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
      setState(() {});
    });
  }
}
