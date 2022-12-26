import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
// import 'package:herbani/controller/auth.dart';
import 'package:herbani/controller/form.dart';
// import 'package:herbani/controller/splashscreen.dart';
import 'package:herbani/helper/textstyle_custom.dart';
// import 'package:herbani/view/auth/login.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

var alertStyle = AlertStyle(
  animationType: AnimationType.fromTop,
  isCloseButton: false,
  isOverlayTapDismiss: false,
  descStyle: TextStyle(
    fontFamily: "Roboto-regular",
    fontSize: 12.sp,
  ),
  animationDuration: const Duration(milliseconds: 500),
  alertBorder: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20.0),
    side: const BorderSide(
      color: Colors.blue,
    ),
  ),
  titleStyle: const TextStyle(
    fontFamily: "Roboto-regular",
  ),
);

orangeDialog(BuildContext context, String message, type) async {
  Alert(
    context: context,
    type: type,
    title: "Pesan",
    desc: message.toString(),
    style: alertStyle,
    buttons: [
      DialogButton(
        onPressed: () {
          Get.back();
          return;
        },
        color: Colors.blue[900],
        child: Text(
          "Tutup",
          style: textStyleCustom(
            context,
            Colors.white,
            12.sp,
            FontWeight.w500,
          ),
        ),
      ),
    ],
  ).show();
}

final Geolocator geolocator = Geolocator();

Future<dynamic> orangeConfirm(
    BuildContext context, String message, String route) async {
  Alert(
    context: context,
    type: AlertType.info,
    title: "Pesan",
    desc: message.toString(),
    style: alertStyle,
    buttons: [
      DialogButton(
        onPressed: () {
          Get.back();
        },
        color: Colors.grey,
        child: Text(
          "Batal",
          style: textStyleCustom(
            context,
            Colors.white,
            12.sp,
            FontWeight.w500,
          ),
        ),
      ),
      DialogButton(
        onPressed: () async {
          Get.back();
          if (route == 'logout') {
            // final AuthController auth = Get.put(AuthController());
            // await auth.logout(context);
            final prefs = await SharedPreferences.getInstance();
            prefs.clear();
            // final SplashScreenController splash =
            // Get.put(SplashScreenController());
            // splash.setIsLogin(false);

            return Get.offNamedUntil('/login', (route) => false);
            // return Get.offAllNamed('/login');
            // return Get.offAll(const Login());
          } else if (route == 'location-disabled') {
            await Geolocator.openLocationSettings();
          } else if (route == 'permission') {
            await Geolocator.openAppSettings();
          } else if (route == 'storage-denied') {
            await Geolocator.openAppSettings();
          } else if (route == 'storage-permanent-denied') {
            await Geolocator.openAppSettings();
          } else if (route == 'notifikasi-denied') {
            await Geolocator.openAppSettings();
          }
        },
        color: Colors.blueAccent,
        child: Text(
          "Oke",
          style: textStyleCustom(
            context,
            Colors.white,
            12.sp,
            FontWeight.w500,
          ),
        ),
      ),
    ],
  ).show();
}

Future<dynamic> confirmDialogWithAction(
    BuildContext context, String message, String route, Map body) async {
  Alert(
    context: context,
    type: AlertType.info,
    title: "Pesan",
    desc: message.toString(),
    style: alertStyle,
    buttons: [
      DialogButton(
        onPressed: () {
          Get.back();
        },
        color: Colors.grey,
        child: Text(
          "Batal",
          style: textStyleCustom(
            context,
            Colors.white,
            12.sp,
            FontWeight.w500,
          ),
        ),
      ),
      DialogButton(
        onPressed: () async {
          Get.back();
          final FormController form = Get.put(FormController());
          if (route == 'terima-po') {
            await form.terimaPo(body);
          } else if (route == 'tolak-po') {
            await form.tolakPo(body);
          }
        },
        color: Colors.blueAccent,
        child: Text(
          "Oke",
          style: textStyleCustom(
            context,
            Colors.white,
            12.sp,
            FontWeight.w500,
          ),
        ),
      ),
    ],
  ).show();
}

void orangeSuccessAndBack(BuildContext context, String message) async {
  Alert(
    context: context,
    type: AlertType.success,
    title: "Pesan",
    desc: message.toString(),
    style: alertStyle,
    buttons: [
      DialogButton(
        onPressed: () {
          Get.back();
          Get.back();
        },
        color: Colors.blue[700],
        child: const Text(
          "Oke",
        ),
      ),
    ],
  ).show();
}
