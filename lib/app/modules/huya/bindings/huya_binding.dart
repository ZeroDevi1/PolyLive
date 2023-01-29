import 'package:get/get.dart';

import '../controllers/huya_controller.dart';

class HuyaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HuyaController>(
      () => HuyaController(),
    );
  }
}
