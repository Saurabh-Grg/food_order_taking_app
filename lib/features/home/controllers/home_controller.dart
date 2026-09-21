import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/order_model.dart';
import '../../../routes/app_routes.dart';
import '../../orders/services/order_service.dart';
import '../../tutorials/services/tutorial_service.dart';

class HomeController extends GetxController with GetSingleTickerProviderStateMixin {
  final OrderService _orderService = Get.find();
  late TutorialService _tutorialService;

  late TabController tabController;
  final RxList<OrderModel> allOrders = <OrderModel>[].obs;
  final RxList<OrderModel> inProgressOrders = <OrderModel>[].obs;
  final RxList<OrderModel> readyOrders = <OrderModel>[].obs;

  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  // Tutorial-specific fields
  final RxBool hasTestOrder = false.obs;
  final Rx<OrderModel?> testOrder = Rx<OrderModel?>(null);
  final RxInt tutorialTimerSeconds = 240.obs; // 4 minutes in seconds
  Timer? _tutorialTimer;
  final Rx<GlobalKey?> testOrderKey = Rx<GlobalKey?>(GlobalKey());

  @override
  void onInit() {
    super.onInit();
    print('HomeController: onInit called');
    try {
      _tutorialService = Get.find();
      print('HomeController: TutorialService found');
    } catch (e) {
      print('HomeController: Error finding TutorialService: $e');
      rethrow;
    }
    tabController = TabController(length: 3, vsync: this);
    print('HomeController: Starting refreshOrders');
    refreshOrders();

    if (!_tutorialService.isTutorialComplete.value) {
      print('HomeController: Tutorial not completed, scheduling startTutorial');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        print('HomeController: Starting tutorial');
        _tutorialService.startTutorial();
      });
    } else {
      print('HomeController: Tutorial already completed');
    }
  }

  @override
  void onClose() {
    print('HomeController: onClose - Disposing resources');
    tabController.dispose();
    _tutorialTimer?.cancel();
    super.onClose();
  }

  Future<void> refreshOrders() async {
    if (_tutorialService.isTutorialActive.value && _tutorialService.currentStep.value < 3) {
      print('HomeController: refreshOrders skipped (tutorial active, step < 3)');
      return;
    }

    print('HomeController: refreshOrders - Starting');
    isLoading.value = true;
    hasError.value = false;

    try {
      final orders = await _orderService.getOrders();
      print('HomeController: refreshOrders - Orders fetched: ${orders.length}');
      allOrders.value = orders;
      inProgressOrders.value = orders.where((o) => o.status == 'in_progress').toList();
      readyOrders.value = orders.where((o) => o.status == 'ready').toList();
    } catch (e) {
      print('HomeController: refreshOrders - Error: $e');
      hasError.value = true;
      errorMessage.value = 'Failed to load orders. Please try again.';
    } finally {
      isLoading.value = false;
      print('HomeController: refreshOrders - Completed');
    }
  }

  void createTestOrder() {
    print('HomeController: createTestOrder - Creating test order');
    final newOrder = OrderModel(
      id: 'test-order-${DateTime.now().millisecondsSinceEpoch}',
      customerName: 'Tutorial Customer',
      items: [
        {'name': 'Tutorial Item', 'quantity': 1, 'price': 9.99},
      ],
      total: 9.99,
      status: 'new',
      createdAt: DateTime.now(),
      address: '123 Tutorial St.',
      phoneNumber: '555-123-4567',
    );

    testOrder.value = newOrder;
    allOrders.insert(0, newOrder);
    hasTestOrder.value = true;

    tutorialTimerSeconds.value = 240; // 4 minutes
    print('HomeController: createTestOrder - Starting tutorial timer');
    _tutorialTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (tutorialTimerSeconds.value > 0) {
        tutorialTimerSeconds.value--;
      } else {
        timer.cancel();
        print('HomeController: Tutorial timer finished');
      }
    });
    print('HomeController: createTestOrder - Test order created: ${newOrder.id}');
  }

  void handleOrderTap(OrderModel order) {
    print('HomeController: handleOrderTap - Order tapped: ${order.id}, tutorialActive=${_tutorialService.isTutorialActive.value}, testOrderId=${testOrder.value?.id}');
    print('HomeController: handleOrderTap - Navigating to OrderDetailView');
    Get.toNamed(
      Routes.ORDER_DETAIL,
      arguments: order,
    );
    print('HomeController: handleOrderTap - Navigation call executed');
  }

  String formatTimer(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}