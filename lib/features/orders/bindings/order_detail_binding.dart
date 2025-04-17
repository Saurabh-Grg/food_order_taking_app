import 'package:get/get.dart';
import '../../../data/providers/api_provider.dart';
import '../../../data/repositories/order_repositories.dart';
import '../controllers/order_detail_controller.dart';

class OrderDetailBinding extends Bindings {
  @override
  void dependencies() {
    // If the API provider and repository are not already registered
    if (!Get.isRegistered<ApiProvider>()) {
      Get.lazyPut<ApiProvider>(() => ApiProvider());
    }

    if (!Get.isRegistered<OrderRepository>()) {
      Get.lazyPut<OrderRepository>(() => OrderRepository(
        apiProvider: Get.find<ApiProvider>(),
      ));
    }

    // Provide the order detail controller
    Get.lazyPut<OrderDetailController>(() => OrderDetailController(
      orderRepository: Get.find<OrderRepository>(),
    ));
  }
}