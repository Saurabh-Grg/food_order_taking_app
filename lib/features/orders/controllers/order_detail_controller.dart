import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/order_model.dart';
import '../../../data/repositories/order_repositories.dart';

class OrderDetailController extends GetxController {
  final OrderRepository orderRepository;

  OrderDetailController({required this.orderRepository});

  final isLoading = false.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;

  final Rx<Order?> order = Rx<Order?>(null);

  @override
  void onInit() {
    super.onInit();
    // Get the order ID from arguments
    final orderId = Get.arguments is Order ? (Get.arguments as Order).id : Get.arguments as String;
    fetchOrder(orderId);
  }

  Future<void> fetchOrder(String orderId) async {
    isLoading.value = true;
    hasError.value = false;

    try {
      final fetchedOrder = await orderRepository.getOrderById(orderId);
      order.value = fetchedOrder;
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Failed to load order. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshOrder() async {
    if (order.value != null) {
      return fetchOrder(order.value!.id);
    }
  }

  Future<void> updateOrderStatus(OrderStatus newStatus) async {
    if (order.value == null) return;

    isLoading.value = true;

    try {
      final updatedOrder = await orderRepository.updateOrderStatus(
        order.value!.id,
        newStatus,
      );

      order.value = updatedOrder;
      Get.snackbar(
        'Success',
        'Order status updated to ${updatedOrder.statusText}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Failed to update order status. Please try again.';
      Get.snackbar(
        'Error',
        'Failed to update order status',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> acceptOrderWithPickupTime(DateTime pickupTime) async {
    if (order.value == null) return;

    isLoading.value = true;

    try {
      // First update the pickup time
      final orderWithPickupTime = await orderRepository.updatePickupTime(
        order.value!.id,
        pickupTime,
      );

      // Then update the status to accepted if it's currently pending
      if (orderWithPickupTime.status == OrderStatus.pending) {
        final updatedOrder = await orderRepository.updateOrderStatus(
          order.value!.id,
          OrderStatus.accepted,
        );

        order.value = updatedOrder;
      } else {
        order.value = orderWithPickupTime;
      }

      Get.snackbar(
        'Success',
        'Order accepted with pickup time set',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Failed to accept order. Please try again.';
      Get.snackbar(
        'Error',
        'Failed to accept order',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}