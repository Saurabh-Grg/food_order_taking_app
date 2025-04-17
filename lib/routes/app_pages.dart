import 'package:demo_restro_app/features/on_boarding/bindings/on_boarding_binding.dart';
import 'package:demo_restro_app/features/on_boarding/views/on_boarding_screen.dart';
import 'package:demo_restro_app/features/orders/bindings/order_detail_binding.dart';
import 'package:demo_restro_app/features/orders/views/order_detail_view.dart';
import 'package:demo_restro_app/features/splash/splash_screen.dart';
import 'package:get/get.dart';

import '../features/auth/bindings/auth_binding.dart';
import '../features/auth/views/login_view.dart';
import '../features/home/bindings/home_binding.dart';
import '../features/home/views/home_view.dart';
import '../features/menu/bindings/menu_binding.dart';
import '../features/menu/views/menu_management_view.dart';
import '../features/settings/setting_view.dart';
import 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: Routes.SPLASH,
      page: () => SplashScreen(),
    ),
    GetPage(
      name: Routes.ONBOARDING,
      page: () => OnboardingScreen(),
      binding: OnBoardingBinding()
    ),

    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.MENU_MANAGEMENT,
      page: () => MenuManagementView(),
      binding: MenuBinding(),
    ),
    GetPage(
      name: Routes.SETTINGS,
      page: () => SettingView(),
      // binding: MenuBinding(),
    ),
    GetPage(
      name: Routes.ORDER_DETAIL,
      page: () => const OrderDetailView(),
      binding: OrderDetailBinding(),
    ),
  ];
}