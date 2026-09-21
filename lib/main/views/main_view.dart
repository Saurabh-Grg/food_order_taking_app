import 'package:demo_restro_app/features/menu/views/menu_management_view.dart';
import 'package:demo_restro_app/features/settings/setting_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../features/home/views/home_view.dart';
import '../controllers/main_controller.dart'; // New controller for navigation

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final MainController mainController = Get.put(MainController());

    // List of screens to switch between
    final List<Widget> screens = [
      HomeView(),
      MenuManagementView(),
      SettingView(),
    ];

    return Scaffold(
      body: Obx(() => IndexedStack(
        index: mainController.currentNavIndex.value,
        children: screens,
      )),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
        currentIndex: mainController.currentNavIndex.value,
        onTap: mainController.changeNavPage,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: 'Menu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      )),
    );
  }
}