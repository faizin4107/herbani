import 'package:get/get.dart';
import 'package:herbani/controller/akun.dart';

class AkunBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AkunController());
  }
}
