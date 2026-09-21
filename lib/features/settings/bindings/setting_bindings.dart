import 'package:demo_restro_app/features/home/controllers/home_controller.dart';
import 'package:get/get.dart';


class SettingBinding extends Bindings {
  @override
  void dependencies(){
    Get.lazyPut<HomeController>(() => HomeController());
  }
}