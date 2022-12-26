import 'package:get/get.dart';
import 'package:herbani/controller/customer.dart';

class CustomerBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(CustomerController());
  }
}
