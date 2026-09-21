import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/common/error_view.dart';
import '../../../widgets/common/loading_indicator.dart';
import '../../tutorials/services/tutorial_service.dart';
import '../controllers/home_controller.dart';
import '../widgets/order_card.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    print('HomeView: Building HomeView');
    final tutorialService = Get.find<TutorialService>();

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('Orders'),
        actions: [
          Obx(() => tutorialService.isTutorialActive.value && tutorialService.currentStep.value < 3
              ? SizedBox()
              : IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.refreshOrders(),
          )),
        ],
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value && !tutorialService.isTutorialActive.value) {
            return const LoadingIndicator();
          }

          if (controller.hasError.value && !tutorialService.isTutorialActive.value) {
            return ErrorView(
              message: controller.errorMessage.value,
              onRetry: () => controller.refreshOrders(),
            );
          }

          return Column(
            children: [
              Container(
                child: TabBar(
                  controller: controller.tabController,
                  labelColor: Theme.of(context).colorScheme.primary,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Theme.of(context).colorScheme.primary,
                  tabs: [
                    Tab(text: 'All (${controller.allOrders.length})'),
                    Tab(text: 'In Progress (${controller.inProgressOrders.length})'),
                    Tab(text: 'Ready (${controller.readyOrders.length})'),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  physics: tutorialService.isTutorialActive.value && tutorialService.currentStep.value < 3
                      ? NeverScrollableScrollPhysics()
                      : AlwaysScrollableScrollPhysics(),
                  controller: controller.tabController,
                  children: [
                    _buildOrdersList(controller.allOrders),
                    _buildOrdersList(controller.inProgressOrders),
                    _buildOrdersList(controller.readyOrders),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildOrdersList(RxList orders) {
    final tutorialService = Get.find<TutorialService>();
    final homeController = Get.find<HomeController>();

    return Obx(() {
      if (orders.isEmpty) {
        return const Center(
          child: Text('No orders available'),
        );
      }

      return RefreshIndicator(
        onRefresh: tutorialService.isTutorialActive.value && tutorialService.currentStep.value < 3
            ? () async {}
            : controller.refreshOrders,
        child: ListView.builder(
          physics: tutorialService.isTutorialActive.value && tutorialService.currentStep.value < 3
              ? NeverScrollableScrollPhysics()
              : AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(8),
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];
            final isTestOrder = tutorialService.isTutorialActive.value &&
                homeController.testOrder.value != null &&
                order.id == homeController.testOrder.value!.id;

            return OrderCard(
              key: isTestOrder ? homeController.testOrderKey.value : null,
              order: order,
              onTap: () {
                print('HomeView: OrderCard tapped: ${order.id}');
                if (isTestOrder && tutorialService.isTutorialActive.value) {
                  print('HomeView: Test order tapped, closing overlay');
                  tutorialService.completeTutorial(); // Complete tutorial
                }
                controller.handleOrderTap(order);
              },
            );
          },
        ),
      );
    });
  }
}