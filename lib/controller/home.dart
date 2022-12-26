import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:herbani/API/services.dart';
import 'package:herbani/controller/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends GetxController with StateMixin<dynamic> {
  CancelToken token = CancelToken();

  var user = ''.obs;
  setUser(String val) {
    user.value = val;
  }

  var fotoProfile = ''.obs;
  setFotoProfile(String val) {
    fotoProfile.value = val;
  }

  var level = ''.obs;
  setLevel(String val) {
    level.value = val;
  }

  var namaLevel = ''.obs;
  setNamaLevel(String val) {
    namaLevel.value = val;
  }

  var email = ''.obs;
  setEmail(String val) {
    email.value = val;
  }

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  Future<dynamic> getData() async {
    change(null, status: RxStatus.loading());
    debugPrint('ini home');
    token = CancelToken();
    final prefs = await SharedPreferences.getInstance();
    final String? area = prefs.getString('area');
    final String? id = prefs.getString('id');
    String? url;
    Map<String, dynamic> body = {};
    if (area != null) {
      url = '/user/$id';
      await APIServices.newApi(url, body, token).then((response) {
        debugPrint('response home $response');
        if (response['success'] == true) {
          if (response['data']['username'] != null) {
            setUser(response['data']['username']);
          } else {
            setUser('');
          }

          if (response['data']['role'] != null) {
            setNamaLevel(response['data']['role']);
          } else {
            setNamaLevel('');
          }

          if (response['data']['foto'] != null) {
            setFotoProfile(response['data']['foto']);
          } else {
            setFotoProfile('');
          }

          debugPrint('statement foto ${fotoProfile.value}');
          if (response['data']['email'] != null) {
            setEmail(response['data']['email']);
          } else {
            setEmail('');
          }
          return change(response, status: RxStatus.success());
        } else {
          return change(response, status: RxStatus.success());
        }
        // return change(response, status: RxStatus.success());
      });
    } else {
      url = '/user/account_by_id.php';
      body = {
        'id_user': prefs.getString('id_user'),
      };
      await APIServices.getApi(url, body, token).then((response) {
        if (response['success'] == true) {
          if (response['data']['username'] != null) {
            setUser(response['data']['username']);
          } else {
            setUser('');
          }
          if (response['data']['level'] != null) {
            setLevel(response['data']['level']);
          } else {
            setLevel('');
          }

          if (response['data']['nama_level'] != null) {
            setNamaLevel(response['data']['nama_level']);
          } else {
            setNamaLevel('');
          }

          if (response['data']['foto'] != null) {
            setFotoProfile(response['data']['foto']);
          } else {
            setFotoProfile('');
          }
          if (response['data']['email'] != null) {
            setEmail(response['data']['email']);
          } else {
            setEmail('');
          }
          return change(response, status: RxStatus.success());
        } else {
          return change(response, status: RxStatus.success());
        }
        // return change(response, status: RxStatus.success());
      });
    }
  }

  @override
  onClose() {
    token.cancel();
    super.onClose();
  }

  @override
  void dispose() {
    token.cancel();
    super.dispose();
  }
}
