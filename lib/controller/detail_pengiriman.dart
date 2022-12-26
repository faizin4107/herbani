import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:herbani/API/services.dart';
import 'package:herbani/controller/home.dart';
import 'package:herbani/model/global_list.dart';

class DetailPengirimanController extends GetxController
    with StateMixin<List<dynamic>>, GlobalList {
  CancelToken token = CancelToken();

  List<String> listProduk = [];
  Rx<TextEditingController> searchController = TextEditingController().obs;

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

  Future<dynamic> getData(idPesanan) async {
    change(null, status: RxStatus.loading());
    initGetData();
    token = CancelToken();
    final HomeController home = Get.put(HomeController());
    String url;
    if (home.namaLevel.value == 'Sales') {
      url = '/sales/detail_pengiriman.php';
    } else if (home.namaLevel.value == 'Delivery') {
      url = '/delivery/detail_pengiriman.php';
    } else {
      url = '/kolektor/detail_pengiriman.php';
    }
    Map body = {'id_pesanan': idPesanan};
    await APIServices.getApi(url, body, token).then((response) {
      debugPrint('lis  $response');
      if (response['success'] == true) {
        if (response['data'].length == 0) {
          setMessageEmpty('Data tidak ada');
          return change(null, status: RxStatus.empty());
        } else {
          if (response['data'].length < 20) {
            setRecords(response['data']);
            listRecords = List.generate(
                    response['data'].length, (index) => response['data'][index])
                .obs;
          } else {
            listRecords =
                List.generate(19, (index) => response['data'][index]).obs;
          }

          return change(listRecords, status: RxStatus.success());
        }
      } else {
        return change(null, status: RxStatus.error(response['message']));
      }
    });
  }

  Future<dynamic> getListOrder(idPesanan) async {
    change(null, status: RxStatus.loading());
    initGetData();
    token = CancelToken();
    Map body = {
      'id_pesanan': idPesanan,
    };
    var url = '/order/list_order.php';
    await APIServices.getApi(url, body, token).then((response) {
      if (response['success'] == true) {
        if (response['data'].length == 0) {
          setMessageEmpty('Data tidak ada');
          return change(null, status: RxStatus.empty());
        } else {
          if (response['data'].length < 20) {
            setRecords(response['data']);
            listRecords = List.generate(
                    response['data'].length, (index) => response['data'][index])
                .obs;
          } else {
            listRecords =
                List.generate(19, (index) => response['data'][index]).obs;
          }

          return change(listRecords, status: RxStatus.success());
        }
      } else {
        return change(null, status: RxStatus.error(response['message']));
      }
    });
  }

  Future<dynamic> getTotalOrderan(idPesanan) async {
    change(null, status: RxStatus.loading());
    initGetData();
    token = CancelToken();
    Map body = {
      'id_pesanan': idPesanan,
    };
    var url = '/order/total_order.php';
    await APIServices.getApi(url, body, token).then((response) {
      if (response['success'] == true) {
        if (response['data']['value_sum'] == null) {
          setTotalProduk(0);
        } else {
          setTotalProduk(int.parse(response['data']['value_sum']));
        }
      } else {
        setTotalProduk(0);
      }
    });
  }

  var totalProduk = 0.obs;
  setTotalProduk(int val) {
    totalProduk.value = val;
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
