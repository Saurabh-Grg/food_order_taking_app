import 'package:get/get.dart';

class MainController extends GetxController {
  var currentNavIndex = 0.obs;

  void changeNavPage(int index) {
    currentNavIndex.value = index;
  }
}