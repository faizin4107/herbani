import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:herbani/API/services.dart';
import 'package:herbani/controller/home.dart';
import 'package:herbani/model/global_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AkunController extends GetxController
    with StateMixin<List<dynamic>>, GlobalList {
  CancelToken token = CancelToken();

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  Future<dynamic> getData() async {
    change(null, status: RxStatus.loading());
    token = CancelToken();
    final prefs = await SharedPreferences.getInstance();
    final String? area = prefs.getString('area');
    final String? id = prefs.getString('id');
    String? url;
    Map body = {
      'id_user': prefs.getString('id_user'),
    };
    if (area != null) {
      url = '/user/$id';
      debugPrint('url $url');
      await APIServices.newApi(url, body, token).then((response) {
        if (response['success'] == true) {
          if (response['data'].length == 0) {
            setMessageEmpty('Data tidak ada');
            return change(null, status: RxStatus.empty());
          } else {
            listRecords.add(response['data']);
            debugPrint('statement ${response['data']}');

            // setListRecords(jsonDecode(response['data']));

            return change(listRecords, status: RxStatus.success());
          }
        } else {
          return change(null, status: RxStatus.error(response['message']));
        }
      });
    } else {
      url = '/user/akun.php';
      await APIServices.getApi(url, body, token).then((response) {
        if (response['success'] == true) {
          if (response['data'].length == 0) {
            setMessageEmpty('Data tidak ada');
            return change(null, status: RxStatus.empty());
          } else {
            setListRecords(response['data']);

            return change(listRecords, status: RxStatus.success());
          }
        } else {
          return change(null, status: RxStatus.error(response['message']));
        }
      });
    }
  }

  Future editFoto(body) async {
    EasyLoading.show(status: 'memuat...');
    setIsTouch(true);
    token = CancelToken();
    final prefs = await SharedPreferences.getInstance();
    final String? area = prefs.getString('area');
    final String? id = prefs.getString('id');
    if (area != null) {
      var response =
          await APIServices.newSendWithFiles('/user/$id', body, token);
      if (response['success'] == true) {
        EasyLoading.dismiss();
        setIsTouch(false);
        final prefs = await SharedPreferences.getInstance();
        prefs.remove('foto');
        prefs.setString('foto', response['data'].toString());
        EasyLoading.showSuccess('${response['message']}');
        Get.put(HomeController()).getData();
        await Future.delayed(const Duration(seconds: 1));
        getData();
        return Get.back();
      } else {
        EasyLoading.dismiss();
        setIsTouch(false);
        EasyLoading.showError('${response['message']}');
      }
    } else {
      var response =
          await APIServices.sendWithFiles('/user/change_foto.php', body, token);
      if (response['success'] == true) {
        EasyLoading.dismiss();
        setIsTouch(false);
        final prefs = await SharedPreferences.getInstance();
        prefs.remove('foto');
        prefs.setString('foto', response['data'].toString());
        EasyLoading.showSuccess('${response['message']}');
        Get.put(HomeController()).getData();
        await Future.delayed(const Duration(seconds: 1));
        getData();
        return Get.back();
      } else {
        EasyLoading.dismiss();
        setIsTouch(false);
        EasyLoading.showError('${response['message']}');
      }
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
