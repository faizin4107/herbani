import 'package:get/get.dart';
import 'package:herbani/controller/splashscreen.dart';

class SplashScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SplashScreenController());
  }
}
