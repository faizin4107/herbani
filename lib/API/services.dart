import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
// ignore: library_prefixes
import 'package:get/get.dart' as getController;
import 'package:herbani/controller/auth.dart';
import 'package:herbani/util/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class APIServices {
  static Future<dynamic> getApi(url, body, token) async {
    final AuthController authController =
        getController.Get.put(AuthController());
    BaseOptions options = BaseOptions(
      baseUrl: authController.selectArea.value == 'Sales Luar Jakarta'
          ? urlApiGw2
          : urlApiGw,
      connectTimeout: 30000,
      receiveTimeout: 25000,
    );
    debugPrint('url1 ${urlApiGw + url}');
    debugPrint('url2 ${urlApiGw2 + url}');
    Map<String, dynamic> res = {};
    Dio dio = Dio(options);
    Response response;
    try {
      response = await dio.post(
        url,
        options: Options(
          headers: {
            "Content-Type": "application/json",
          },
        ),
        data: jsonEncode(body),
        cancelToken: token,
      );
      debugPrint('res ${response.data}');
      if (authController.selectArea.value == 'Sales Luar Jakarta') {
        res = response.data;
      } else {
        res = jsonDecode(response.data);
      }
      if (res['success'] == false) {
        if (res['message'] == 'Session expired') {
          getController.Get.offNamedUntil('/login', (route) => false);
          return EasyLoading.showInfo(
              'Sesi anda telah berakhir, silahkan login kembeli');
        }
      }

      return res;
    } on DioError catch (e) {
      if (e.response != null) {
        return e.response!.data;
      } else {
        if (e.requestOptions.cancelToken!.isCancelled == false) {
          return {"success": false, "message": e.message};
        }
      }
    }
  }

  static Future<dynamic> newApi(url, body, token) async {
    BaseOptions options = BaseOptions(
      baseUrl: urlApiGw2,
      connectTimeout: 30000,
      receiveTimeout: 25000,
    );
    // debugPrint('url1 ${urlApiGw + url}');
    debugPrint('url2 ${urlApiGw2 + url}');
    final prefs = await SharedPreferences.getInstance();
    final String? bearerToken = prefs.getString('auth-token');
    Map<String, dynamic> res = {};
    Dio dio = Dio(options);
    Response response;
    try {
      response = await dio.get(
        url,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $bearerToken",
          },
        ),
        cancelToken: token,
      );
      debugPrint('res ${response.data}');
      res = response.data;

      return res;
    } on DioError catch (e) {
      if (e.response != null) {
        return e.response!.data;
      } else {
        if (e.requestOptions.cancelToken!.isCancelled == false) {
          return {"success": false, "message": e.message};
        }
      }
    }
  }

  static Future<dynamic> newPostApi(url, body, token) async {
    BaseOptions options = BaseOptions(
      baseUrl: urlApiGw2,
      connectTimeout: 30000,
      receiveTimeout: 25000,
    );
    final prefs = await SharedPreferences.getInstance();
    final String? bearerToken = prefs.getString('auth-token');
    Map<String, dynamic> res = {};
    Dio dio = Dio(options);
    Response response;
    try {
      response = await dio.post(
        url,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $bearerToken",
          },
        ),
        data: body,
        queryParameters: {'_method': 'PUT'},
        cancelToken: token,
      );
      debugPrint('res ${response.data}');
      res = response.data;

      return res;
    } on DioError catch (e) {
      if (e.response != null) {
        return e.response!.data;
      } else {
        if (e.requestOptions.cancelToken!.isCancelled == false) {
          return {"success": false, "message": e.message};
        }
      }
    }
  }

  static Future<dynamic> sendWithFiles(url, body, token) async {
    BaseOptions options = BaseOptions(
      baseUrl: urlApiGw,
      connectTimeout: 30000,
      receiveTimeout: 25000,
    );
    Dio dio = Dio(options);
    Map<String, dynamic> res = {};
    Response response;
    try {
      response = await dio.post(
        url,
        options: Options(
          headers: {
            "Content-Type": "application/json",
          },
        ),
        data: body,
        cancelToken: token,
      );
      res = jsonDecode(response.data);

      return res;
    } on DioError catch (e) {
      if (e.response != null) {
        return e.response!.data;
      } else {
        if (e.requestOptions.cancelToken!.isCancelled == false) {
          return {"success": false, "message": e.message};
        }
      }
    }
  }

  static Future<dynamic> newSendWithFiles(url, body, token) async {
    final prefs = await SharedPreferences.getInstance();
    final String? bearerToken = prefs.getString('auth-token');
    BaseOptions options = BaseOptions(
      baseUrl: urlApiGw2,
      connectTimeout: 30000,
      receiveTimeout: 25000,
    );
    debugPrint('url ${urlApiGw2 + url}');
    Dio dio = Dio(options);
    Response response;
    try {
      response = await dio.post(
        url,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $bearerToken",
          },
        ),
        data: body,
        cancelToken: token,
      );
      debugPrint('statement ${response.data}');

      return response.data;
    } on DioError catch (e) {
      if (e.response != null) {
        return e.response!.data;
      } else {
        if (e.requestOptions.cancelToken!.isCancelled == false) {
          return {"success": false, "message": e.message};
        }
      }
    }
  }
}
