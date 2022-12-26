import 'package:get/get.dart';
import 'package:herbani/controller/detail_order.dart';

class DetailOrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DetailOrderController());
  }
}
