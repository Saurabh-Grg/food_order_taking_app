// lib/main.dart
import 'package:demo_restro_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'config/theme/app_theme.dart';
import 'features/orders/services/order_service.dart';
import 'features/tutorials/services/tutorial_service.dart';
import 'routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services
  await Get.putAsync(() => TutorialService().init());
  await Get.putAsync(() async => OrderService());

  runApp(DemoRestroApp());
}

class DemoRestroApp extends StatelessWidget {
  const DemoRestroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Restaurant Order App',
      theme: AppTheme.lightTheme,
      initialRoute: Routes.LOGIN,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}
