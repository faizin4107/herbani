import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:herbani/API/services.dart';
import 'package:herbani/controller/home.dart';
import 'package:herbani/model/global_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReturController extends GetxController
    with StateMixin<List<dynamic>>, GlobalList {
  CancelToken token = CancelToken();

  List<String> listProduk = [];
  Rx<TextEditingController> searchController = TextEditingController().obs;

  Future<dynamic> getData() async {
    change(null, status: RxStatus.loading());
    initGetData();
    token = CancelToken();
    final prefs = await SharedPreferences.getInstance();
    final String? area = prefs.getString('area');
    final String? id = prefs.getString('id');
    final String? disId = prefs.getString('distributor_id');
    String? url = '/show-retur/$id/$disId';
    ;
    if (area != null) {
      Map body = {};
      List<dynamic> result = [];

      await APIServices.newApi(url, body, token).then((response) {
        result.clear();
        if (response['success'] == true) {
          if (response['data'].length == 0) {
            setMessageEmpty('Data tidak ada');
            return change(null, status: RxStatus.empty());
          } else {
            Map<String, dynamic> data = {};
            Map newData = {};
            Map combine = {};
            for (var i = 0; i < response['data'].length; i++) {
              data = response['data'][i];
              data.forEach((key, value) {
                newData[key] = value ??= '';
                combine = {...combine, ...newData};
              });
              result.add(combine);
            }

            if (response['data'].length < 20) {
              setRecords(response['data']);
              listRecords =
                  List.generate(result.length, (index) => result[index]).obs;
            } else {
              listRecords = List.generate(19, (index) => result[index]).obs;
            }

            return change(listRecords, status: RxStatus.success());
          }
        } else {
          return change(null, status: RxStatus.error(response['message']));
        }
      });
    } else {}
  }

  Future onsearch(String text) async {
    setListSearch([]);
    if (text.isEmpty) {
      searchController.value.clear();
      setListSearch([]);
      if (tapSearch.value) {
        setTapSearch(false);
      }
      return change(records, status: RxStatus.success());
    } else {
      setTapSearch(true);
    }
    List<dynamic> data = [];
    for (var f in records) {
      if (f.toString().toLowerCase().contains(text.toString().toLowerCase())) {
        data.add(f);
      }
    }
    List result;
    if (records.length != data.length) {
      final jsonList = data.map((item) => jsonEncode(item)).toList();
      final uniqueJsonList = jsonList.toSet().toList();
      result = uniqueJsonList.map((item) => jsonDecode(item)).toList();
      if (result.length < 20) {
        listSearch = List.generate(result.length, (index) => result[index]).obs;
      } else {
        listSearch = List.generate(19, (index) => result[index]).obs;
      }
    } else {
      if (data.length < 20) {
        listSearch = List.generate(data.length, (index) => data[index]).obs;
      } else {
        listSearch = List.generate(19, (index) => data[index]).obs;
      }
    }
    return change(listSearch.toSet().toList(), status: RxStatus.success());
  }

  @override
  onClose() {
    searchController.value.clear();
    token.cancel();
    super.onClose();
  }

  @override
  void dispose() {
    searchController.value.clear();
    token.cancel();
    super.dispose();
  }
}
