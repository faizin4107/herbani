import 'package:get/get.dart';
import 'package:herbani/controller/invoice.dart';

class InvoiceBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(InvoiceController());
  }
}
