import 'package:demo_restro_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingController extends GetxController {
  var currentPage = 0.obs;

  final List<OnboardingContent> pages = [
    OnboardingContent(
      title: "Browse Menu",
      description: "Explore our wide variety of delicious dishes and beverages",
      image: Icons.menu_book,
    ),
    OnboardingContent(
      title: "Easy Ordering",
      description: "Place your order with just a few taps",
      image: Icons.shopping_cart,
    ),
    OnboardingContent(
      title: "Quick Delivery",
      description: "Get your food delivered to your doorstep in no time",
      image: Icons.delivery_dining,
    ),
  ];

  void nextPage() {
    if (currentPage.value < pages.length - 1) {
      currentPage.value++;
    } else {
      Get.offNamed(Routes.LOGIN);
    }
  }

  void skipToLogin() {
    Get.offNamed(Routes.LOGIN);
  }
}

class OnboardingContent {
  final String title;
  final String description;
  final IconData image;

  OnboardingContent({
    required this.title,
    required this.description,
    required this.image,
  });
}
