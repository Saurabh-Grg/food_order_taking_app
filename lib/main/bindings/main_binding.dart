import 'package:demo_restro_app/features/menu/controllers/menu_controller.dart';
import 'package:get/get.dart';

import '../../data/providers/api_provider.dart';

import '../../features/home/controllers/home_controller.dart';

class MainBindings extends Bindings {
  @override
  void dependencies() {
    // Provide the API client
    Get.lazyPut<ApiProvider>(() => ApiProvider());

    // Then register HomeController, which depends on OrderRepository
    Get.lazyPut<HomeController>(() => HomeController());

    // Register MenuManagementController
    Get.lazyPut<MenuManagementController>(() => MenuManagementController());
  }
}