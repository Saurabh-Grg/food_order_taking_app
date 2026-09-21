import 'package:demo_restro_app/features/menu/controllers/menu_controller.dart';
import 'package:get/get.dart';

import '../../home/controllers/home_controller.dart';

class MenuBinding extends Bindings {
  @override
  void dependencies(){
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<MenuManagementController>(() => MenuManagementController());
  }
}