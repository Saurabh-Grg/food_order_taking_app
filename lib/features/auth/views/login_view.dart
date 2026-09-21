import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';
import '../../../widgets/buttons/icon_button.dart';
import '../../../widgets/inputs/custom_text_field.dart';
import '../controllers/auth_controller.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: controller.loginFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 60),
                  // Logo and app name
                  // Center(
                  //   child: Column(
                  //     children: [
                  //       Container(
                  //         height: 80,
                  //         width: 80,
                  //         decoration: BoxDecoration(
                  //           color: primaryColor,
                  //           borderRadius: BorderRadius.circular(20),
                  //         ),
                  //         child: const Icon(
                  //           Icons.restaurant,
                  //           color: Colors.white,
                  //           size: 48,
                  //         ),
                  //       ),
                  //       const SizedBox(height: 16),
                  //       const Text(
                  //         'FoodDelight',
                  //         style: TextStyle(
                  //           color: textDark,
                  //           fontSize: 28,
                  //           fontWeight: FontWeight.bold,
                  //         ),
                  //       ),
                  //       const SizedBox(height: 8),
                  //       const Text(
                  //         'Delicious food at your doorstep',
                  //         style: TextStyle(
                  //           color: Colors.black54,
                  //           fontSize: 14,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  const SizedBox(height: 60),
                  // Welcome text
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Welcome Back',
                        style: TextStyle(
                          color: colorScheme.onSurface,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Sign in to continue',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),
                  // Email field
                  CustomTextField(
                    controller: controller.emailController,
                    label: 'Email',
                    hint: 'Enter your email',
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icon(Icons.email_outlined, color: colorScheme.primary),
                    validator: controller.validateEmail,
                    borderRadius: 12,
                  ),
                  const SizedBox(height: 20),
                  // Password field
                  Obx(() => CustomTextField(
                    controller: controller.passwordController,
                    label: 'Password',
                    hint: 'Enter your password',
                    obscureText: !controller.isPasswordVisible.value,
                    prefixIcon: Icon(Icons.lock_outline, color: colorScheme.primary),
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.isPasswordVisible.value
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: Colors.black54,
                      ),
                      onPressed: controller.togglePasswordVisibility,
                    ),
                    validator: controller.validatePassword,
                    borderRadius: 12,
                  )),
                  const SizedBox(height: 16),
                  // Forgot password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // Handle forgot password
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: colorScheme.primary,
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(50, 30),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Login button
                  Obx(() => CustomButton(
                    text: 'Sign In',
                    isLoading: controller.isLoading.value,
                    onPressed: controller.login,
                    backgroundColor: colorScheme.primary,
                    textColor: colorScheme.onPrimary,
                    borderRadius: 12,
                    height: 56,
                  )),
                  const SizedBox(height: 24),
                  // Sign up option
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account?",
                        style: TextStyle(color: Colors.black54),
                      ),
                      TextButton(
                        onPressed: () => Get.toNamed(Routes.SIGNUP),
                        style: TextButton.styleFrom(
                          foregroundColor: colorScheme.primary,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}