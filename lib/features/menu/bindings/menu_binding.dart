import 'package:demo_restro_app/features/menu/controllers/menu_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/repositories/order_repositories.dart';
import '../../home/controllers/home_controller.dart';

class MenuBinding extends Bindings {
  void dependencies(){
    Get.lazyPut<HomeController>(() => HomeController(
      orderRepository: Get.find<OrderRepository>(),
    ));
    Get.lazyPut<MenuManagementController>(() => MenuManagementController());
  }
}