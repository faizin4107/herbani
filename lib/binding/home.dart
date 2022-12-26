import 'package:get/get.dart';
import 'package:herbani/controller/home.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(HomeController());
  }
}
