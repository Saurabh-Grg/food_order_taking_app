


import 'package:demo_restro_app/features/home/controllers/home_controller.dart';
import 'package:demo_restro_app/features/menu/controllers/menu_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingView extends StatelessWidget {

  final MenuManagementController controller = Get.find();
  final HomeController homeController = Get.find();
  SettingView({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Settings'),
        
      ),
      body: Text('Settings'),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
        currentIndex: homeController.currentNavIndex.value,
        onTap: homeController.changeNavPage,
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
