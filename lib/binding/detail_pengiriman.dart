import 'package:get/get.dart';
import 'package:herbani/controller/detail_pengiriman.dart';

class DetailPengirimanBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DetailPengirimanController());
  }
}
