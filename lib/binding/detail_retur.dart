import 'package:get/get.dart';
import 'package:herbani/controller/detail_retur.dart';

class DetailReturBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DetailReturController());
  }
}
