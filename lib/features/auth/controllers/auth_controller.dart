import 'package:demo_restro_app/features/tutorials/services/tutorial_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../routes/app_routes.dart';

class AuthController extends GetxController {
  final loginFormKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final RxBool isPasswordVisible = false.obs;
  final RxBool isLoading = false.obs;
  final RxBool isFirstLogin = true.obs;

  final TutorialService tutorialService = Get.find();

  @override
  void onInit() async {
    super.onInit();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isFirstLogin.value = prefs.getBool('first_login') ?? true;
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  Future<void> login() async {
    if (!loginFormKey.currentState!.validate()) {
      return;
    }

    isLoading.value = true;

    try {
      // Simulate authentication
      await Future.delayed(Duration(seconds: 2));

      // Mark as logged in and track first login
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_logged_in', true);

      bool isFirstTimeLogin = prefs.getBool('first_login') ?? true;
      if (isFirstTimeLogin) {
        await prefs.setBool('first_login', false);
      }

      //remove this after testing
      await tutorialService.resetTutorial();
      // Navigate to home
      Get.offAllNamed(Routes.MAIN);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Login failed. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
