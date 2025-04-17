import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';
import '../../../widgets/common/error_view.dart';
import '../../../widgets/common/loading_indicator.dart';
import '../controllers/home_controller.dart';
import '../widgets/order_card.dart';


class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('Orders'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.refreshOrders(),
          ),
        ],
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const LoadingIndicator();
          }

          if (controller.hasError.value) {
            return ErrorView(
              message: controller.errorMessage.value,
              onRetry: () => controller.refreshOrders(),
            );
          }

          return Column(
            children: [
              // Tab bar for All, In Progress, Ready
              Container(
                child: TabBar(
                  controller: controller.tabController,
                  labelColor: Theme.of(context).primaryColor,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Theme.of(context).primaryColor,
                  tabs: [
                    Tab(text: 'All (${controller.allOrders.length})'),
                    Tab(text: 'In Progress (${controller.inProgressOrders.length})'),
                    Tab(text: 'Ready (${controller.readyOrders.length})'),
                  ],
                ),
              ),

              // Tab content
              Expanded(
                child: TabBarView(
                  controller: controller.tabController,
                  children: [
                    // All Orders Tab
                    _buildOrdersList(controller.allOrders),

                    // In Progress Orders Tab
                    _buildOrdersList(controller.inProgressOrders),

                    // Ready Orders Tab
                    _buildOrdersList(controller.readyOrders),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
        currentIndex: controller.currentNavIndex.value,
        onTap: controller.changeNavPage,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),  // Add this menu item
            label: 'Menu',                      // Menu navigation option
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      )),
    );
  }

  Widget _buildOrdersList(RxList orders) {
    return Obx(() {
      if (orders.isEmpty) {
        return const Center(
          child: Text('No orders available'),
        );
      }

      return RefreshIndicator(
        onRefresh: controller.refreshOrders,
        child: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];
            return OrderCard(
              order: order,
              onTap: () => Get.toNamed(
                Routes.ORDER_DETAIL,
                arguments: order,
              ),
            );
          },
        ),
      );
    });
  }
}