import 'package:get/get.dart';
import 'package:herbani/controller/form.dart';

class FormBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(FormController());
  }
}
