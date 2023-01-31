import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:poly_live/app/modules/favorite/index.dart';

import 'package:poly_live/common/api/huya.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({Key? key}) : super(key: key);
  final _textController = TextEditingController();

  Widget get body => [
    const FavoritePage(key: Key('FavoritePage')),
    const FavoritePage(key: Key('FavoritePage')),
  ][controller.selectIndex.value];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: body,
      bottomNavigationBar: Obx(() => BottomNavigationBar(
            currentIndex: controller.selectIndex.value,
            onTap: (index) {
              controller.selectIndex.value = index;
            },
            items:  [
              BottomNavigationBarItem(
                icon: const Icon(Icons.favorite_rounded),
                label: 'favorite'.tr,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.settings_rounded),
                label: 'setting'.tr,
              ),
            ],
          )),
    );
  }

  Future<void> _showDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('请输入房间号'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: _textController,
                  decoration: const InputDecoration(
                    hintText: 'lck',
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('确认'),
              onPressed: () async {
                // 发送请求
                var roomId = _textController.text;
                var url = await parseHuyaUrl(roomId);

              },
            ),
          ],
        );
      },
    );
  }
}
