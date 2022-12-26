import 'package:get/get.dart';
import 'package:herbani/controller/retur.dart';

class ReturBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ReturController());
  }
}
