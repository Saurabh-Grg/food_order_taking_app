import 'package:get/get.dart';

import '../features/home/controllers/home_controller.dart';
import '../features/orders/services/order_service.dart';
import '../features/tutorials/services/tutorial_service.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(TutorialService());
    Get.put(OrderService());
    Get.put(HomeController());
  }
}