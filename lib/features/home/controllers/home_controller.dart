import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/order_model.dart';
import '../../../data/repositories/order_repositories.dart';
import '../../../routes/app_routes.dart';

class HomeController extends GetxController with GetSingleTickerProviderStateMixin {
  final OrderRepository orderRepository;

  HomeController({required this.orderRepository});

  // Tab controller
  late TabController tabController;

  // Bottom navigation index
  final currentNavIndex = 0.obs;

  // Loading and error states
  final isLoading = false.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;

  // Orders by status
  final allOrders = <Order>[].obs;
  final inProgressOrders = <Order>[].obs;
  final readyOrders = <Order>[].obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(_handleTabSelection);
    fetchOrders();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  void _handleTabSelection() {
    if (tabController.indexIsChanging) {
      // You can perform specific actions when tabs change if needed
    }
  }

  void changeNavPage(int index) {
    currentNavIndex.value = index;

    // Navigate based on the selected tab
    switch (index) {
      case 0: // Orders tab
        Get.offNamed(Routes.HOME);
        break;
      case 1: // Menu management tab
        Get.offNamed(Routes.MENU_MANAGEMENT);
        break;
      case 2: // Settings tab
        Get.offNamed(Routes.SETTINGS);
        break;
    }
  }

  Future<void> fetchOrders() async {
    isLoading.value = true;
    hasError.value = false;

    try {
      final orders = await orderRepository.getOrders();

      allOrders.value = orders;

      // Filter orders by status
      inProgressOrders.value = orders.where((order) =>
      order.status == OrderStatus.accepted ||
          order.status == OrderStatus.preparing
      ).toList();

      readyOrders.value = orders.where((order) =>
      order.status == OrderStatus.ready
      ).toList();

    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Failed to load orders. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshOrders() async {
    return fetchOrders();
  }
}