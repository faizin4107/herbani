import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:herbani/API/services.dart';
import 'package:herbani/helper/alert_custom.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
// ignore: depend_on_referenced_packages
import 'package:image/image.dart' as ui;
import 'package:permission_handler/permission_handler.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_connection_checker/simple_connection_checker.dart';
import 'package:url_launcher/url_launcher.dart';

Future checkLogin() async {
  final prefs = await SharedPreferences.getInstance();
  var isLogin = prefs.getBool('isLogin');
  final String? area = prefs.getString('area');
  final String? authToken = prefs.getString('auth-token');
  debugPrint('isLogin $isLogin');
  if (isLogin == null) {
    debugPrint('isLogin 1');
    await Future.delayed(const Duration(seconds: 4));
    Get.offNamedUntil('/login', (route) => false);
  } else {
    debugPrint('isLogin 2');
    if (isLogin) {
      debugPrint('isLogin 3');
      await Future.delayed(const Duration(seconds: 4));
      if (area != null) {
        if(authToken != null){
          final String? area = prefs.getString('area');
          final String? id = prefs.getString('id');
          if(area != null){
            Map<String, dynamic> body = {};
            var url = '/user/$id';
            CancelToken token = CancelToken();
            await APIServices.newApi(url, body, token).then((response) {
              debugPrint('response home $response');
              if (response['success'] == true) {
                return Get.offNamedUntil('/home_distributor', (route) => false);
              } else {
                if(response['message'] == 'Session expired'){
                  return Get.offNamedUntil('/login', (route) => false);
                }else{
                  return Get.offNamedUntil('/home_distributor', (route) => false);
                }
                
              }
          // return change(response, status: RxStatus.success());
            });
          }
          
          
        }else{
          Get.offNamedUntil('/login', (route) => false);
        }
        
      } else {
        Get.offNamedUntil('/home', (route) => false);
      }
    } else {
      debugPrint('isLogin 4');
      await Future.delayed(const Duration(seconds: 4));
      Get.offNamedUntil('/login', (route) => false);
    }
  }
}

getUserSymbol(user) {
  String dataUser;
  List<String> res = [];
  var textLeft = user!.trimLeft();
  var textRight = textLeft.trimRight();
  var splitData = textRight.toString().split(' ');
  for (var i = 0; i < splitData.length; i++) {
    var splitText = splitData[i].substring(0, 1);
    String textSymbol;
    if (splitText.contains('.')) {
      textSymbol = splitText.replaceAll('.', '');
    } else if (splitText.contains(',')) {
      textSymbol = splitText.replaceAll(',', '');
    } else {
      textSymbol = splitText;
    }
    res.add(textSymbol);
  }
  if (res.length == 1) {
    dataUser = res.first.toUpperCase();
  } else {
    dataUser = res.first.toUpperCase() + res.last.toUpperCase();
  }
  return dataUser;
}

Future checkConnection() async {
  bool isConnected = await SimpleConnectionChecker.isConnectedToInternet();
  // final InfoController infoController = Get.find();
  String message;
  if (!isConnected) {
    message =
        'Perangkat Anda sedang tidak terhubung dengan internet. Silakan periksa koneksi internet Anda.';
    return EasyLoading.showInfo(message);
  } else {
    return true;
  }
}

getSayingTime() async {
  var timeNow = DateTime.now().hour;
  Map<String, dynamic> result = {};
  if (timeNow <= 12) {
    result['saying'] = 'Selamat Pagi';
    result['image'] = 'assets/img/weather/morning.svg';
  } else if ((timeNow > 12) && (timeNow <= 16)) {
    result['saying'] = 'Selamat Siang';
    result['image'] = 'assets/img/weather/afternoon.svg';
  } else if ((timeNow > 16) && (timeNow < 20)) {
    result['saying'] = 'Selamat Malam';
    result['image'] = 'assets/img/weather/night.svg';
  } else {
    result['saying'] = 'Selamat Malam';
    result['image'] = 'assets/img/weather/night.svg';
  }
  return result;
}

Future<bool> checkPermissionStorage(context) async {
  Permission permission;
  permission = Permission.storage;

  String? message;
  bool data = false;
  var result = await permission.request();
  if (result == PermissionStatus.granted) {
    data = true;
  } else if (result == PermissionStatus.denied) {
    message = 'Mohon izinkan izin penyimpanan';
    data = false;
    orangeConfirm(context, message, 'storage-denied');
  } else if (result == PermissionStatus.permanentlyDenied) {
    message = 'Akses semua layanan file ditolak, mohon izinkan';
    orangeConfirm(context, message, 'storage-permanent-denied');
    data = false;
  }
  return data;
}

Future<dynamic> getLocation() async {
  Position? currentPosition;
  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
  List<Placemark> placemarks =
      await placemarkFromCoordinates(position.latitude, position.longitude);
  String locality = placemarks.first.locality.toString();
  String administrativeArea = placemarks.first.administrativeArea.toString();
  String country = placemarks.first.country.toString();
  String isoCountryCode = placemarks.first.isoCountryCode.toString();
  String name = placemarks.first.name.toString();
  String postalCode = placemarks.first.postalCode.toString();
  String street = placemarks.first.street.toString();
  String subAdministrativeArea =
      placemarks.first.subAdministrativeArea.toString();
  String subLocality = placemarks.first.subLocality.toString();
  String address =
      '$name $street $subLocality $locality $administrativeArea $subAdministrativeArea $postalCode $country $isoCountryCode';
  currentPosition = position;
  if (currentPosition.latitude != 0) {
    Map data = {
      'address': address.toString(),
      'latitude': currentPosition.latitude.toDouble(),
      'longitude': currentPosition.longitude.toDouble(),
      'accuracy': currentPosition.accuracy.toDouble(),
      'altitude': currentPosition.altitude.toDouble()
    };
    return data;
  }
}

Future<dynamic> getFile() async {
  File? imageFile;
  imageFile = null;
  Map result = {};
  FilePickerResult? pickFile = await FilePicker.platform.pickFiles();
  if (pickFile != null) {
    PlatformFile file = pickFile.files.first;

    if (file.extension == 'jpg' ||
        file.extension == 'png' ||
        file.extension == 'jpeg') {
      File compressedFile = await FlutterNativeImage.compressImage(file.path!,
          quality: 50, targetWidth: 500, targetHeight: 700, percentage: 30);
      ui.Image originalImage =
          ui.decodeImage(compressedFile.readAsBytesSync())!;
      final DateTime now = DateTime.now();
      final DateFormat formatter = DateFormat('yyyyMMdd-HHmmss');
      final String formatted = formatter.format(now);
      var timeStamp = DateTime.now().millisecondsSinceEpoch;
      final File watermarkedFile = File(
          '${(await getTemporaryDirectory()).path}/$formatted-$timeStamp.jpg');

      imageFile = watermarkedFile
        ..writeAsBytesSync(ui.encodeJpg(originalImage));

      result = {
        'fileName': '$formatted-$timeStamp.jpg',
        'file': imageFile,
        'type': 'image',
        'ext_file': 'jpg'
      };
    } else {
      final DateTime now = DateTime.now();
      final DateFormat formatter = DateFormat('yyyyMMdd-HHmmss');
      final String formatted = formatter.format(now);
      var timeStamp = DateTime.now().millisecondsSinceEpoch;
      File files = File(pickFile.files.single.path!);
      result = {
        'fileName': '$formatted-$timeStamp.${file.extension}',
        'file': files,
        'type': 'file',
        'ext_file': file.extension
      };
    }
  }
  return result;
}

final picker = ImagePicker();
Future getImagePicture(type) async {
  File? imageFile;
  Map combine = {};
  imageFile = null;
  final XFile? pickedFile;
  imageFile = null;
  if (type == 'gallery') {
    pickedFile = await picker.pickImage(source: ImageSource.gallery);
  } else {
    pickedFile = await picker.pickImage(source: ImageSource.camera);
  }

  if (pickedFile != null) {
    File compressedFile = await FlutterNativeImage.compressImage(
        pickedFile.path,
        quality: 50,
        targetWidth: 500,
        targetHeight: 700,
        percentage: 30);
    ui.Image originalImage = ui.decodeImage(compressedFile.readAsBytesSync())!;
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyyMMdd-HHmmss');
    final String formatted = formatter.format(now);
    var timeStamp = DateTime.now().millisecondsSinceEpoch;
    final File watermarkedFile = File(
        '${(await getTemporaryDirectory()).path}/$formatted-$timeStamp.jpg');

    imageFile = watermarkedFile..writeAsBytesSync(ui.encodeJpg(originalImage));

    combine = {
      'fileName': '$formatted-$timeStamp.jpg',
      'file': imageFile,
      'type': 'image',
      'ext_file': 'jpg'
    };
  }
  return combine;
}

Future<dynamic> requestPermissionLocation(context) async {
  bool? serviceEnabled;
  LocationPermission permission;
  Object resPermission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  permission = await Geolocator.checkPermission();
  String? message;
  if (!serviceEnabled) {
    message = 'Lokasi dinonaktifkan, harap aktifkan lokasi terlebih dahulu';
    orangeConfirm(context, message, 'location-disabled');
    resPermission = 'location-disabled';
    EasyLoading.dismiss();
  } else if (permission == LocationPermission.deniedForever) {
    message = 'Layanan lokasi ditolak, mohon izinkan';
    orangeConfirm(context, message, 'permission');
    resPermission = 'location-denied-forever';
  } else if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission != LocationPermission.whileInUse &&
        permission != LocationPermission.always) {
      message = 'Layanan lokasi ditolak, mohon izinkan';
      orangeConfirm(context, message, 'permission');
      resPermission = 'location-denied';
    } else {
      resPermission = true;
    }
  } else {
    resPermission = true;
  }
  return resPermission;
}

// Future<bool> checkMockLocation(context) async {
//   Position position = await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.high);
//   if (position.isMocked) {
//     EasyLoading.dismiss();
//     orangeDialog(context, 'Mohon nonaktifkan terlebih dahulu aplikasi fake GPS',
//         AlertType.info);
//     return true;
//   } else {
//     return false;
//   }
// }

void navigateTo(double lat, double lng) async {
  var uri = Uri.parse("google.navigation:q=$lat,$lng&mode=d");
  if (await canLaunch(uri.toString())) {
    await launch(uri.toString());
  } else {
    throw 'Could not launch ${uri.toString()}';
  }
}
