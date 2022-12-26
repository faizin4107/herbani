import 'package:get/get.dart';
import 'package:herbani/controller/auth.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController());
  }
}
