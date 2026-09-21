import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../home/controllers/home_controller.dart';
import '../widgets/tutorial_dialog.dart';

class TutorialService extends GetxService {
  static TutorialService get to => Get.find();

  final RxBool isTutorialComplete = false.obs;
  final RxBool isTutorialActive = false.obs;
  final RxInt currentStep = 0.obs;
  OverlayEntry? _overlayEntry;

  Future<TutorialService> init() async {
    print('TutorialService: Initializing');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isTutorialComplete.value = prefs.getBool('tutorial_complete') ?? false;
    print('TutorialService: isTutorialComplete = ${isTutorialComplete.value}');
    return this;
  }

  Future<void> resetTutorial() async {
    print('TutorialService: Resetting tutorial state');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('tutorial_complete', false);
    isTutorialComplete.value = false;
    isTutorialActive.value = false;
    currentStep.value = 0;
    print('TutorialService: Tutorial reset complete');
  }

  void startTutorial() {
    print('TutorialService: startTutorial called');
    if (!isTutorialComplete.value) {
      isTutorialActive.value = true;
      currentStep.value = 0;
      showWelcomeDialog();
    } else {
      print('TutorialService: Tutorial already completed, not starting');
    }
  }

  void completeStep() {
    print('TutorialService: Completing step: ${currentStep.value}');
    currentStep.value++;
    Get.back();
    _showCurrentStep();
  }

  void skipTutorial() async {
    print('TutorialService: Skipping tutorial');
    isTutorialActive.value = false;
    isTutorialComplete.value = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('tutorial_complete', true);
    Get.back();
  }

  void completeTutorial() async {
    print('TutorialService: Completing tutorial');
    isTutorialActive.value = false;
    isTutorialComplete.value = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('tutorial_complete', true);
    _removeOverlay();
    Get.back();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _showCurrentStep() {
    print('TutorialService: Showing step: ${currentStep.value}');
    switch (currentStep.value) {
      case 0:
        showWelcomeDialog();
        break;
      case 1:
        showAllTabDialog();
        break;
      case 2:
        showCreateOrderDialog();
        break;
      case 3:
        createTestOrder();
        showTapOrderDialog();
        break;
      default:
        completeTutorial();
    }
  }

  void showWelcomeDialog() {
    print('TutorialService: Showing welcome dialog');
    Get.dialog(
      WillPopScope(
        onWillPop: () async => false,
        child: TutorialDialog(
          content: 'Welcome to our app! Let\'s take a quick tour to help you get started.',
          showSkip: true,
          onNext: () => completeStep(),
          onSkip: () => skipTutorial(),
        ),
      ),
      barrierDismissible: false,
    );
  }

  void showAllTabDialog() {
    print('TutorialService: Showing all tab dialog');
    Future.delayed(Duration(milliseconds: 300), () {
      final tabPosition = Offset(70, 110);

      Get.dialog(
        WillPopScope(
          onWillPop: () async => false,
          child: Stack(
            children: [
              Positioned(
                top: tabPosition.dy - 50,
                left: tabPosition.dx - 50,
                child: TutorialHighlight(
                  width: 100,
                  height: 50,
                  showBorder: true,
                ),
              ),
              TutorialDialog(
                content: 'New orders appear in this tab',
                showSkip: false,
                onNext: () => completeStep(),
                alignment: DialogAlignment.center,
                pointerOffset: tabPosition,
              ),
            ],
          ),
        ),
        barrierDismissible: false,
        barrierColor: Colors.black54,
      );
    });
  }

  void showCreateOrderDialog() {
    print('TutorialService: Showing create order dialog');
    Future.delayed(Duration(milliseconds: 300), () {
      Get.dialog(
        WillPopScope(
          onWillPop: () async => false,
          child: TutorialDialog(
            content: 'Let\'s create a test order so you can see exactly how.',
            showSkip: false,
            onNext: () => completeStep(),
          ),
        ),
        barrierDismissible: false,
      );
    });
  }

  void createTestOrder() {
    print('TutorialService: Creating test order');
    final homeController = Get.find<HomeController>();
    homeController.createTestOrder();
  }

  void showTapOrderDialog() {
    print('TutorialService: Showing tap order dialog');
    Future.delayed(Duration(milliseconds: 300), () {
      final homeController = Get.find<HomeController>();
      Offset? cardPosition;
      Size? cardSize;

      final testOrderKey = homeController.testOrderKey.value;
      if (testOrderKey != null && testOrderKey.currentContext != null) {
        final RenderBox? renderBox = testOrderKey.currentContext!.findRenderObject() as RenderBox?;
        if (renderBox != null) {
          cardPosition = renderBox.localToGlobal(Offset.zero);
          cardSize = renderBox.size;
        }
      }

      if (cardPosition == null || cardSize == null) {
        cardPosition = Offset(28, 117);
        cardSize = Size(Get.width - 40, 160);
      }

      _overlayEntry = OverlayEntry(
        builder: (context) => Stack(
          children: [
            // Highlight around test order (visual only, no touch interception)
            Positioned(
              top: cardPosition?.dy,
              left: cardPosition?.dx,
              child: IgnorePointer(
                child: TutorialHighlight(
                  width: cardSize!.width,
                  height: cardSize.height,
                  showBorder: false, // Add border for visibility
                ),
              ),
            ),
            // Tutorial dialog below the order card
            Positioned(
              top: cardPosition!.dy + cardSize.height + 20,
              left: 20,
              right: 20,
              child: TutorialDialog(
                content: 'Please tap the order to accept it',
                showSkip: true,
                showNext: false,
                onSkip: () => completeTutorial(),
                alignment: DialogAlignment.bottomCenter,
              ),
            ),
          ],
        ),
      );

      Overlay.of(Get.overlayContext!).insert(_overlayEntry!);
    });
  }
}