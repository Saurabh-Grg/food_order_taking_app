// lib/modules/order/controllers/order_detail_controller.dart
import 'package:get/get.dart';
import '../../../data/models/order_model.dart';

import '../../tutorials/services/tutorial_service.dart';
import '../services/order_service.dart';

class OrderDetailController extends GetxController {
  final OrderService _orderService = Get.find();
  final TutorialService _tutorialService = Get.find();

  late OrderModel order;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    order = Get.arguments as OrderModel;
  }

  Future<void> acceptOrder() async {
    if (_tutorialService.isTutorialActive.value) {
      // In tutorial mode, just mark as complete
      return;
    }

    isLoading.value = true;
    try {
      await _orderService.updateOrderStatus(order.id, 'in_progress');
      order.status = 'in_progress';
      Get.back(result: true);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to accept order. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> rejectOrder() async {
    isLoading.value = true;
    try {
      await _orderService.updateOrderStatus(order.id, 'rejected');
      order.status = 'rejected';
      Get.back(result: true);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to reject order. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}