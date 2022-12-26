import 'package:get/get.dart';

class InfoController extends GetxController {
  var isLogin = false.obs;
  setIsLogin(bool val) {
    isLogin.value = val;
  }
var listDistributor = [].obs;
  setDistributor(List<dynamic> val) {
    listDistributor.value = val;
  }
 
}
