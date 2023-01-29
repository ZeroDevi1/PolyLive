import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:poly_live/utils/huya.dart';

import '../controllers/home_controller.dart';
import 'package:bruno/bruno.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var selectIndex = 0.obs;
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'HomeView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        BrnMiddleInputDialog(
            title: '请输入房间号',
            hintText: '提示信息',
            cancelText: '取消',
            confirmText: '确定',
            maxLength: 1000,
            maxLines: 2,
            barrierDismissible: false,
            inputEditingController: TextEditingController()..text = '',
            textInputAction: TextInputAction.done,
            onConfirm: (value) {
             if (kDebugMode) {
               print(value);
             }
            if(value.isNotEmpty){
              parseHuyaUrl(value);
            }
             Navigator.pop(context);
            },
            onCancel: () {
              BrnToast.show("取消", context);
              Navigator.pop(context);
            }).show(context);
      },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BrnBottomTabBar(
          fixedColor: Colors.blue,
          currentIndex: selectIndex.value,
          badgeColor: Colors.red,
          items: const [
            BrnBottomTabBarItem(
              icon: Icon(
                Icons.live_tv,
                color: Colors.yellow,
                size: 24.0,
              ),
              title: Text("虎牙")
            ),
            BrnBottomTabBarItem(
                icon: Icon(
                  Icons.live_tv,
                  color: Colors.yellow,
                  size: 24.0,
                ),
                title: Text("斗鱼")
            ),
            BrnBottomTabBarItem(
                icon: Icon(
                  Icons.live_tv,
                  color: Colors.yellow,
                  size: 24.0,
                ),
                title: Text("哔哩哔哩")
            ),
          ]),
    );
  }
}
