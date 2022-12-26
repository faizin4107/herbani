import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:herbani/controller/auth.dart';

Color primaryColor = const Color.fromARGB(255, 108, 194, 43);
// String urlApiGw = 'http://192.168.1.4/ppic/android';
// String urlUploads = 'http://192.168.1.4/ppic/assets/uploads/purchase-order/';
// String urlFoto = 'http://192.168.1.4/ppic/assets/uploads/profile/';
final AuthController auth = Get.put(AuthController());

String urlApiGw = 'https://beherbani.com/android';
String urlUploads = 'https://beherbani.com/assets/uploads/purchase-order/';
String urlFoto = 'https://beherbani.com/assets/uploads/profile/';
String urlPenagihan = 'https://beherbani.com/assets/uploads/penagihan/';

String urlApiGw2 = 'https://ppic-api.beherbani.com/api';
String urlUploads2 = 'https://ppic-api.beherbani.com/api';
String urlFoto2 = 'https://beherbani.com/assets/uploads/';
// String urlApiGw2 = 'http://192.168.1.9:8080/api';
// String urlUploads2 = 'http://192.168.1.9:8080/api';
// String urlFoto2 = 'http://192.168.1.9:8000/storage/';
