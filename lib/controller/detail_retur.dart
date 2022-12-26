import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:herbani/API/services.dart';
import 'package:herbani/model/global_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailReturController extends GetxController
    with StateMixin<List<dynamic>>, GlobalList {
  CancelToken token = CancelToken();

  List<String> listProduk = [];
  Rx<TextEditingController> searchController = TextEditingController().obs;

  Future<dynamic> getData(idPo, region) async {
    change(null, status: RxStatus.loading());
    initGetData();
    token = CancelToken();
    List<dynamic> result = [];
    final prefs = await SharedPreferences.getInstance();
    final String? area = prefs.getString('area');
    String? url;
    if (area != null) {
      debugPrint('statement $region');
      if (region == 'membeli') {
        url = '/show-preorder-detail/$idPo';
      } else {
        url = '/show-kunjungan-detail/$idPo';
      }

      Map body = {};
      debugPrint('body $url');
      await APIServices.newApi(url, body, token).then((response) {
        debugPrint('lis  $response');
        result.clear();
        if (response['success'] == true) {
          if (response['data'].length == 0) {
            setMessageEmpty('Data tidak ada');
            return change(null, status: RxStatus.empty());
          } else {
            Map<String, dynamic> data = {};
            Map newData = {};
            Map combine = {};

            // for (var i = 0; i < response['data'].length; i++) {
            //   data = response['data'][i];

            // }
            response['data'].forEach((key, value) {
              newData[key] = value ??= '';
              combine = {...combine, ...newData};
            });
            result.add(combine);
            if (result.length < 20) {
              setRecords(result);
              listRecords =
                  List.generate(result.length, (index) => result[index]).obs;
            } else {
              listRecords = List.generate(19, (index) => result[index]).obs;
            }
            // debugPrint('statement ${result}');

            return change(listRecords, status: RxStatus.success());
          }
        } else {
          return change(null, status: RxStatus.error(response['message']));
        }
      });
    } else {
      url = '/po/detail_po.php';
      Map body = {'id_po': idPo, 'region': region};
      debugPrint('body $body');
      await APIServices.getApi(url, body, token).then((response) {
        debugPrint('lis  $response');
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
    }
  }

  Future<dynamic> getListOrder(kodePo, region) async {
    change(null, status: RxStatus.loading());
    initGetData();
    token = CancelToken();
    List<dynamic> result = [];
    // final prefs = await SharedPreferences.getInstance();
    // final String? area = prefs.getString('area');
    String url = '/po/list_order.php';
    Map body = {'kode_po': kodePo, 'region': region};
    await APIServices.getApi(url, body, token).then((response) {
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
            //
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
  }

  // ignore: prefer_typing_uninitialized_variables
  var textEditingController;
  // ignore: prefer_typing_uninitialized_variables
  var textEditingControllerVal;
  List<TextEditingController> textEditingControllers = [];
  List<TextEditingController> textEditingControllersVal = [];

  var qtyProduk = [].obs;
  setQtyProduk(List<int> val) {
    qtyProduk.value = val;
  }

  Future<dynamic> getListReturNonDki(idRetur) async {
    change(null, status: RxStatus.loading());
    initGetData();
    token = CancelToken();
    List<dynamic> result = [];
    // final prefs = await SharedPreferences.getInstance();
    // final String? area = prefs.getString('area');
    String? url;
    url = '/show-retur-list/$idRetur';
    // debugPrint('$url');
    Map body = {};
    await APIServices.newApi(url, body, token).then((response) {
      result.clear();
      if (response['success'] == true) {
        if (response['data']['list'].length == 0) {
          setMessageEmpty('Data tidak ada');
          return change(null, status: RxStatus.empty());
        } else {
          Map<String, dynamic> data = {};
          Map newData = {};
          Map combine = {};
          for (var i = 0; i < response['data']['list'].length; i++) {
            // debugPrint('statement ${response['data']['list'][i]}');
            response['data']['list'][i].forEach((key, value) {
              newData[key] = value ??= '';
              combine = {...combine, ...newData};
            });

            result.add(combine);
          }

          // debugPrint('statement ${textEditingControllers}');

          if (result.length < 20) {
            setRecords(result);
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
  }

  var totalProduk = 0.obs;
  setTotalProduk(int val) {
    totalProduk.value = val;
  }

  Future<dynamic> getTotalOrderan(idPo, region) async {
    change(null, status: RxStatus.loading());
    initGetData();
    token = CancelToken();
    var url = '/po/detail_po.php';
    Map body = {'id_po': idPo, 'region': region};
    await APIServices.getApi(url, body, token).then((response) {
      if (response['success'] == true) {
        if (response['data'][0]['total_tagihan'] == null) {
          setTotalProduk(0);
        } else {
          setTotalProduk(int.parse(response['data'][0]['total_tagihan']));
        }
      } else {
        setTotalProduk(0);
      }
    });
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
