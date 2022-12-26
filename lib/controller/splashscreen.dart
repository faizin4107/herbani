import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:herbani/helper/function.dart';

class SplashScreenController extends GetxController {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  var fcmToken = ''.obs;
  setFcmToken(String val) {
    fcmToken.value = val;
  }

  @override
  void onInit() {
    _firebaseMessaging.getToken().then((token) {
      setFcmToken(token.toString());
    });
    checkLogin();

    super.onInit();
  }
}
