import 'package:get/get.dart';

class BottomNavbarController extends GetxController {
  final RxInt currentIndex = 0.obs;

  void changeIndex(int index) {
    currentIndex.value = index;
  }

  void setInitialIndex(int index) {
    currentIndex.value = index;
  }
}
