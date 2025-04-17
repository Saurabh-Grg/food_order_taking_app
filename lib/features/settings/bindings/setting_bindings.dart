import 'package:demo_restro_app/features/home/controllers/home_controller.dart';
import 'package:get/get.dart';

import '../../../data/repositories/order_repositories.dart';

class SettingBinding extends Bindings {
  void dependencies(){
    Get.lazyPut<HomeController>(() => HomeController(
      orderRepository: Get.find<OrderRepository>(),
    ));
  }
}