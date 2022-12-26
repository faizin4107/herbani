import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:herbani/API/services.dart';
import 'package:herbani/controller/info.dart';
import 'package:herbani/helper/alert_custom.dart';
import 'package:herbani/helper/function.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController with StateMixin<List<dynamic>> {
  var fcmToken = ''.obs;
  setFcmToken(String val) {
    fcmToken.value = val;
  }

  CancelToken token = CancelToken();

  final FocusNode focusNodeUser = FocusNode();
  final FocusNode focusNodePass = FocusNode();
  Rx<TextEditingController> usernameController = TextEditingController().obs;
  Rx<TextEditingController> passwordController = TextEditingController().obs;

  var selectLevel = ''.obs;
  setSelectLevel(String val) {
    selectLevel.value = val;
  }

  var selectArea = ''.obs;
  setSelectArea(String val) {
    selectArea.value = val;
  }

  var user = false.obs;
  setIsUser(bool val) {
    user.value = val;
  }

  var pass = false.obs;
  setIsPass(bool val) {
    pass.value = val;
  }

  var touch = false.obs;
  setIsTouch(bool val) {
    touch.value = val;
  }

  var obscure = true.obs;
  setObscure(bool val) {
    obscure.value = val;
  }

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final formKeyLogin = GlobalKey<FormState>();
  final formKeyForgotPassword = GlobalKey<FormState>();
  final formKeyChangePassword = GlobalKey<FormState>();
  final formKeyInputEmail = GlobalKey<FormState>();
  @override
  void onInit() {
    _firebaseMessaging.getToken().then((token) {
      setFcmToken(token.toString());
    });
    super.onInit();
  }

  Future<dynamic> login(context) async {
    EasyLoading.show(status: 'memuat...');
    final InfoController info = Get.put(InfoController());
    info.setDistributor([]);
    setIsTouch(true);
    final prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> body = {};
    String? url;
    debugPrint('select ${selectArea.value}');

    if (selectArea.value == 'Sales Luar Jakarta') {
      url = '/login';
      body = {
        'username': usernameController.value.text,
        'password': passwordController.value.text,
        'role': 'sales',
        'fcm_token': fcmToken.value.toString(),
      };
    } else {
      url = '/auth/login.php';
      body = {
        'username': usernameController.value.text,
        'password': passwordController.value.text,
        'level': selectLevel.value.toString(),
        'fcm_token': fcmToken.value.toString(),
      };
    }

    try {
    await checkConnection().then((connection) async {
      if (connection) {
        var response = await APIServices.getApi(url, body, token);
        debugPrint('response $response');
        
        if (response != null) {
          if (response['success'] == true) {
            EasyLoading.dismiss();
            setIsTouch(false);
            prefs.setString('FCM_TOKEN', fcmToken.value.toString());
            if (selectArea.value == 'Sales Luar Jakarta') {
              debugPrint('response ${response['distributor']}');
              
              prefs.setString('distributor', jsonEncode(response['distributor']));
              
              debugPrint('dis ${response['data']['id']}');
              debugPrint('dis ${response['data']['distributor_id']}');
              prefs.setString(
                  'perusahaan', response['distributor']['nama_perusahaan'].toString());
              prefs.setString(
                  'username', usernameController.value.text.toString());
              prefs.setString('id', response['data']['id'].toString());
              prefs.setString('distributor_id',
                  response['data']['distributor_id'].toString());
              prefs.setString(
                  'nama_level', response['data']['role'].toString());
              prefs.setString('foto', response['data']['foto'].toString());
              prefs.setString('email', response['data']['email'].toString());
              prefs.setString('area', selectArea.value.toString());
              prefs.setString('auth-token', response['access_token']);
              prefs.setBool('isLogin', true);
              debugPrint('data api1 $response');
              debugPrint('data api ${response['data']}');
              info.setIsLogin(true);
              usernameController.value.clear();
              passwordController.value.clear();
              return Get.offNamedUntil('/home_distributor', (route) => false);
            } else {
              prefs.setString(
                  'username', usernameController.value.text.toString());
              prefs.setString(
                  'id_user', response['data']['id_user'].toString());
              prefs.setString('nama_level', selectLevel.toString());
              prefs.setString('level', response['data']['level'].toString());
              prefs.setString('foto', response['data']['foto'].toString());
              prefs.setString('email', response['data']['email'].toString());
              prefs.setBool('isLogin', true);
              final InfoController info = Get.put(InfoController());
              info.setIsLogin(true);
              usernameController.value.clear();
              passwordController.value.clear();
              return Get.offNamedUntil('/home', (route) => false);
            }
          } else {
            EasyLoading.dismiss();
            setIsTouch(false);
            return orangeDialog(context, response['message'], AlertType.info);
          }
        } else {
          setIsTouch(false);
          EasyLoading.dismiss();
          return orangeDialog(
              context, 'Respon dari server tidak valid', AlertType.error);
        }
      } else {
        setIsTouch(false);
        EasyLoading.dismiss();
        return orangeDialog(
            context, 'Koneksi tidak stabil, mohon coba lagi', AlertType.info);
      }
    });
    } catch (e) {
      debugPrint('e $e');
      touch.value = false;
      EasyLoading.dismiss();
      return orangeDialog(context, 'Terjadi kesalahan', AlertType.error);
    }
  }

  Future<dynamic> checkEmail(context) async {
    EasyLoading.show(status: 'memuat...');
    setIsTouch(true);

    Map<String, dynamic> body = {
      'email': emailController.value.text,
      'level': '1',
    };

    try {
      await checkConnection().then((connection) async {
        if (connection) {
          var response =
              await APIServices.getApi('/auth/check_email.php', body, token);
          if (response != null) {
            if (response['success'] == true) {
              EasyLoading.dismiss();
              setIsTouch(false);
              Get.toNamed('/change_password', arguments: {
                'forgetPassword': true,
                'email': emailController.value.text
              });
            } else {
              EasyLoading.dismiss();
              setIsTouch(false);
              return orangeDialog(context, response['message'], AlertType.info);
            }
          } else {
            setIsTouch(false);
            EasyLoading.dismiss();
            return orangeDialog(
                context, 'Respon dari server tidak valid', AlertType.error);
          }
        } else {
          setIsTouch(false);
          EasyLoading.dismiss();
          return orangeDialog(
              context, 'Koneksi tidak stabil, mohon coba lagi', AlertType.info);
        }
      });
    } catch (e) {
      touch.value = false;
      EasyLoading.dismiss();
      return orangeDialog(context, 'Terjadi kesalahan', AlertType.error);
    }
  }

  // Future<dynamic> logout(context) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   prefs.clear();
  //   final SplashScreenController splash = Get.put(SplashScreenController());
  //   splash.setIsLogin(false);

  //   return Get.offNamedUntil('/login', (route) => false);
  // }

  Rx<TextEditingController> oldPassword = TextEditingController().obs;
  Rx<TextEditingController> newPassword = TextEditingController().obs;
  Rx<TextEditingController> confirmPassword = TextEditingController().obs;

  var showHide1 = true.obs;
  setPassShowHide1(bool val) {
    showHide1.value = val;
  }

  var showHide2 = true.obs;
  setPassShowHide2(bool val) {
    showHide2.value = val;
  }

  var showHide3 = true.obs;
  setPassShowHide3(bool val) {
    showHide3.value = val;
  }

  Future changePassword(context, forgetPassword, email) async {
    token = CancelToken();
    EasyLoading.show(status: 'memuat...');
    setIsTouch(true);
    final prefs = await SharedPreferences.getInstance();
    final area = prefs.getString('area');
    try {
      await checkConnection().then((connection) async {
        if (connection) {
          Map body = {};
          if (area != null) {
            if (forgetPassword) {
              body = {
                'passwordOld': '',
                'password': newPassword.value.text.toString(),
                'email': email,
                'id_user': ''
              };
            } else {
              body = {
                'oldPassword': oldPassword.value.text.toString(),
                'password': newPassword.value.text.toString(),
              };
            }
          } else {
            if (forgetPassword) {
              body = {
                'passwordOld': '',
                'password': newPassword.value.text.toString(),
                'email': email,
                'id_user': ''
              };
            } else {
              body = {
                'passwordOld': oldPassword.value.text.toString(),
                'password': newPassword.value.text.toString(),
                'email': '',
                'id_user': prefs.getString('id_user')
              };
            }
          }
          debugPrint('statement $body');
          if (area != null) {
            final String? id = prefs.getString('id');
            var uri = '/user/$id';
            Map<String, dynamic> res = {};
            var response = await APIServices.newPostApi(uri, body, token);
            if (response['success'] == true) {
              res = response;
              if (res['success'] == true) {
                setIsTouch(false);
                EasyLoading.dismiss();

                setPassShowHide1(true);
                setPassShowHide2(true);
                EasyLoading.showSuccess('${res['message']}');
                await Future.delayed(const Duration(seconds: 1));

                Get.offNamedUntil('/login', (route) => false);
              }
            } else {
              setIsTouch(false);
              EasyLoading.dismiss();
              if (response['error'] == 'validation') {
                // debugPrint('statementw ${response['message']['password']}}');
                return orangeDialog(context,
                    response['message']['password'].toString(), AlertType.info);
              } else {
                return orangeDialog(
                    context, response['message'], AlertType.info);
              }
            }
          } else {
            var uri = '/user/change_password.php';
            Map<String, dynamic> res = {};
            var response = await APIServices.getApi(uri, body, token);
            if (response['success'] == true) {
              res = response;
              if (res['success'] == true) {
                setIsTouch(false);
                EasyLoading.dismiss();

                setPassShowHide1(true);
                setPassShowHide2(true);
                EasyLoading.showSuccess('${res['message']}');
                await Future.delayed(const Duration(seconds: 1));

                Get.offNamedUntil('/login', (route) => false);
              }
            } else {
              setIsTouch(false);
              EasyLoading.dismiss();
              return orangeDialog(context, response['message'], AlertType.info);
            }
          }
        } else {
          setIsTouch(false);
          EasyLoading.dismiss();
          return orangeDialog(
              context, 'Koneksi tidak stabil, mohon coba lagi', AlertType.info);
        }
      });
    } catch (e) {
      debugPrint('statement $e');
      setIsTouch(false);
      EasyLoading.dismiss();
      return orangeDialog(context, 'Terjadi kesalahan', AlertType.error);
    }
  }

  Rx<TextEditingController> password = TextEditingController().obs;
  Rx<TextEditingController> authenticationCode = TextEditingController().obs;

  Rx<TextEditingController> userIdController = TextEditingController().obs;
  Rx<TextEditingController> emailController = TextEditingController().obs;

  @override
  onClose() {
    focusNodeUser.dispose();
    focusNodePass.dispose();
    // focusNodeCode.dispose();
    usernameController.value.clear();
    passwordController.value.clear();
    super.onClose();
  }

  @override
  void dispose() {
    focusNodeUser.dispose();
    focusNodePass.dispose();
    // focusNodeCode.dispose();
    usernameController.value.clear();
    passwordController.value.clear();
    super.dispose();
  }
}
