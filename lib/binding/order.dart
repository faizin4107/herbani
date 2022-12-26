import 'package:get/get.dart';
import 'package:herbani/controller/order.dart';

class OrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(OrderController());
  }
}
