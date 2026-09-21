import 'package:demo_restro_app/features/on_boarding/controllers/on_boarding_controller.dart';
import 'package:get/get.dart';

class OnBoardingBinding extends Bindings {
  @override
  void dependencies(){
    Get.lazyPut<OnboardingController>(() => OnboardingController());
  }
}