import 'package:get/get.dart';
import 'package:herbani/controller/penagihan.dart';

class PenagihanBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PenagihanController());
  }
}
