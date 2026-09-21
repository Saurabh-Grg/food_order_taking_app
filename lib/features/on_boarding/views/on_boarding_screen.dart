import 'package:demo_restro_app/features/on_boarding/controllers/on_boarding_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingScreen extends StatelessWidget {
  final OnboardingController controller = Get.find();
  final PageController pageController = PageController();

  OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            PageView.builder(
              controller: pageController,
              itemCount: controller.pages.length,
              onPageChanged: (index) {
                controller.currentPage.value = index;
              },
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.all(40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        controller.pages[index].image,
                        size: 150,
                        color: Colors.orange,
                      ),
                      SizedBox(height: 60),
                      Text(
                        controller.pages[index].title,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        controller.pages[index].description,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            Positioned(
              top: 20,
              right: 20,
              child: TextButton(
                onPressed: () => controller.skipToLogin(),
                child: Text(
                  'Skip',
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      controller.pages.length,
                      (index) => Obx(() => Container(
                            margin: EdgeInsets.symmetric(horizontal: 4),
                            width:
                                controller.currentPage.value == index ? 30 : 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: controller.currentPage.value == index
                                  ? Colors.orange
                                  : Colors.orange.shade200,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          )),
                    ),
                  ),
                  SizedBox(height: 30),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (controller.currentPage.value <
                              controller.pages.length - 1) {
                            pageController.animateToPage(
                              controller.currentPage.value + 1,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeIn,
                            );
                          } else {
                            controller.skipToLogin();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Obx(() => Text(
                              controller.currentPage.value ==
                                      controller.pages.length - 1
                                  ? 'Get Started'
                                  : 'Next',
                              style: TextStyle(fontSize: 16),
                            )),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
