import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';

class AuthController extends GetxController {
  // Observables
  var isLoading = false.obs;
  var isPasswordVisible = false.obs;

  // Form key
  final loginFormKey = GlobalKey<FormState>();

  // Text controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    // Initialize any required setup here
  }

  @override
  void onClose() {
    // Clean up controllers
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  String? validateEmail(String? value) {
    // if (value == null || value.isEmpty) {
    //   return 'Please enter your email';
    // }
    // if (!GetUtils.isEmail(value)) {
    //   return 'Please enter a valid email';
    // }
    // return null;
  }

  String? validatePassword(String? value) {
    // if (value == null || value.isEmpty) {
    //   return 'Please enter your password';
    // }
    // if (value.length < 6) {
    //   return 'Password must be at least 6 characters';
    // }
    // return null;
  }

  void login() async {
    if (loginFormKey.currentState!.validate()) {
      try {
        isLoading.value = true;

        // Simulate API call
        await Future.delayed(const Duration(seconds: 2));

        // Add your authentication logic here
        // For example:
        // final response = await authService.login(
        //   email: emailController.text,
        //   password: passwordController.text,
        // );

        Get.snackbar(
          'Success',
          'Login successful',
          snackPosition: SnackPosition.BOTTOM,
        );

        // Navigate to home screen after successful login
        Get.offAllNamed(Routes.HOME);
      } catch (e) {
        Get.snackbar(
          'Error',
          'Login failed: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } finally {
        isLoading.value = false;
      }
    }
  }
}