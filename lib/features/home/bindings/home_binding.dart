import 'package:get/get.dart';
import '../../../data/providers/api_provider.dart';
import '../../../data/repositories/order_repositories.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // Provide the API client
    Get.lazyPut<ApiProvider>(() => ApiProvider());

    // Provide the order repository
    Get.lazyPut<OrderRepository>(() => OrderRepository(
      apiProvider: Get.find<ApiProvider>(),
    ));

    // Provide the home controller
    Get.lazyPut<HomeController>(() => HomeController(
      orderRepository: Get.find<OrderRepository>(),
    ));
  }
}