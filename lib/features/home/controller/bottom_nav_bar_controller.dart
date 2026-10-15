import 'package:get/get.dart';
import 'home_controller.dart';

class BottomNavbarController extends GetxController {
  final RxInt currentIndex = 0.obs;

  void changeIndex(int index) {
    currentIndex.value = index;
    if (index == 0) {
      _refreshHomeData();
    }
  }

  void setInitialIndex(int index) {
    currentIndex.value = index;
    if (index == 0) {
      _refreshHomeData();
    }
  }

  void _refreshHomeData() {
    if (Get.isRegistered<HomeController>()) {
      final homeController = Get.find<HomeController>();
      homeController.refreshUserData();
    }
  }
}
