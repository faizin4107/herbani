import 'package:get/get.dart';
import 'package:herbani/controller/home.dart';
import 'package:herbani/controller/info.dart';

class InitialAppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(InfoController());
    Get.put(HomeController());
  }
}
