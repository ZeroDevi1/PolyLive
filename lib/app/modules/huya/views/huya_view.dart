import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/huya_controller.dart';

class HuyaView extends GetView<HuyaController> {
  const HuyaView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('虎牙直播'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'HuyaView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
