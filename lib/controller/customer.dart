import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:herbani/API/services.dart';
import 'package:herbani/model/global_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerController extends GetxController
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
    final String? id = prefs.getString('distributor_id');
    debugPrint('id $id');
    // debugPrint('url $url');

    Map body = {};
    List<dynamic> result = [];
    String? url;
    if (area != null) {
      url = '/show-customer/$id';
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
            debugPrint('data ${response['data']}');
            setRecords(response['data']);
            if (response['data'].length < 20) {
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
    } else {
      url = '/customer/customer.php';
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
            }
            debugPrint('data ${response['data']}');
            setRecords(response['data']);
            if (response['data'].length < 20) {
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

  List<dynamic> listProvinsi = [];
  List<String> listStringProvinsi = [];
  List<dynamic> listKelurahan = [];
  List<String> listStringKelurahan = [];
  List<dynamic> listKecamatan = [];
  List<String> listStringKecamatan = [];
  List<dynamic> listKota = [];
  List<String> listStringKota = [];

  Rx<TextEditingController> provinsiController = TextEditingController().obs;
  Rx<TextEditingController> kotaController = TextEditingController().obs;
  Rx<TextEditingController> kelurahanController = TextEditingController().obs;
  Rx<TextEditingController> kecamatanController = TextEditingController().obs;

  Future<dynamic> getProvinsi() async {
    listProvinsi.clear();
    listKota.clear();
    listStringKota.clear();
    listKecamatan.clear();
    listStringKecamatan.clear();
    listKelurahan.clear();
    listStringKelurahan.clear();
    token = CancelToken();

    final prefs = await SharedPreferences.getInstance();
    final String? area = prefs.getString('area');
    String? url;
    Map body = {};
    if (area != null) {
      url = '/provinsi';

      await APIServices.newApi(url, body, token).then((response) {
        if (response['success'] == true) {
          listProvinsi = response['data'];
          for (var i = 0; i < response['data'].length; i++) {
            var post = response['data'][i]['prov_name'];
            listStringProvinsi.add(post);
          }

          return change(listProvinsi, status: RxStatus.success());
        }
      });
    } else {
      url = '/wilayah/provinsi.php';
      await APIServices.getApi(url, body, token).then((response) {
        if (response['success'] == true) {
          listProvinsi = response['data'];
          for (var i = 0; i < response['data'].length; i++) {
            var post = response['data'][i]['prov_name'];
            listStringProvinsi.add(post);
          }
          return change(listProvinsi, status: RxStatus.success());
        }
      });
    }
  }

  Future<dynamic> getKota(provId) async {
    listKota.clear();
    listStringKota.clear();
    token = CancelToken();
    final prefs = await SharedPreferences.getInstance();
    final String? area = prefs.getString('area');
    String? url;
    Map body = {'id': provId};
    if (area != null) {
      url = '/show-kota/$provId';
      await APIServices.newApi(url, body, token).then((response) {
        if (response['success'] == true) {
          listKota = response['data'];
          for (var i = 0; i < response['data'].length; i++) {
            listStringKota.add(listKota[i]['city_name']);
          }
          return change(response['data'], status: RxStatus.success());
        }
      });
    } else {
      url = '/wilayah/kotaId.php';
      await APIServices.getApi(url, body, token).then((response) {
        if (response['success'] == true) {
          listKota = response['data'];
          for (var i = 0; i < response['data'].length; i++) {
            listStringKota.add(listKota[i]['city_name']);
          }
          return change(response['data'], status: RxStatus.success());
        }
      });
    }
  }

  Future<dynamic> getKecamatan(idKota) async {
    listKecamatan.clear();
    listStringKecamatan.clear();
    token = CancelToken();
    final prefs = await SharedPreferences.getInstance();
    final String? area = prefs.getString('area');
    String? url;
    Map body = {'id': idKota};
    if (area != null) {
      url = '/show-kecamatan/$idKota';
      await APIServices.newApi(url, body, token).then((response) {
        if (response['success'] == true) {
          listKecamatan = response['data'];
          for (var i = 0; i < response['data'].length; i++) {
            listStringKecamatan.add(listKecamatan[i]['dis_name']);
          }
        }
      });
    } else {
      url = '/wilayah/kecamatanId.php';
      await APIServices.getApi(url, body, token).then((response) {
        if (response['success'] == true) {
          listKecamatan = response['data'];
          for (var i = 0; i < response['data'].length; i++) {
            listStringKecamatan.add(listKecamatan[i]['dis_name']);
          }
        }
      });
    }
  }

  Future<dynamic> getKelurahan(idKec) async {
    listKelurahan.clear();
    listStringKelurahan.clear();
    token = CancelToken();
    final prefs = await SharedPreferences.getInstance();
    final String? area = prefs.getString('area');
    String? url;
    Map body = {'id': idKec};
    if (area != null) {
      url = '/show-kelurahan/$idKec';
      await APIServices.newApi(url, body, token).then((response) {
        if (response['success'] == true) {
          listKelurahan = response['data'];
          for (var i = 0; i < response['data'].length; i++) {
            listStringKelurahan.add(listKelurahan[i]['subdis_name']);
          }

          return change(response['data'], status: RxStatus.success());
        }
      });
    } else {
      url = '/wilayah/kelurahanId.php';
      await APIServices.getApi(url, body, token).then((response) {
        if (response['success'] == true) {
          listKelurahan = response['data'];
          for (var i = 0; i < response['data'].length; i++) {
            listStringKelurahan.add(listKelurahan[i]['subdis_name']);
          }
          return change(response['data'], status: RxStatus.success());
        }
      });
    }
  }

  var idProvinsi = '0'.obs;
  setProvId(String val) {
    idProvinsi.value = val;
  }

  var idKota = '0'.obs;
  setKotaId(String val) {
    idKota.value = val;
  }

  var idKecamatan = '0'.obs;
  setKecamatanId(String val) {
    idKecamatan.value = val;
  }

  Future<dynamic> generateProvinsi(name) async {
    final prefs = await SharedPreferences.getInstance();
    final String? area = prefs.getString('area');

    for (var i = 0; i < listProvinsi.length; i++) {
      if (listProvinsi[i]['prov_name'] == name) {
        if (area != null) {
          idProvinsi.value = listProvinsi[i]['id'].toString();
        } else {
          idProvinsi.value = listProvinsi[i]['prov_id'];
        }
      }
    }

    debugPrint('id provinsi $idProvinsi');
    // getListKota(idProvinsi.value);
    getKota(idProvinsi.value);
  }

  // Future<dynamic> getListKota(provId) async {
  //   listStringKota.clear();
  //   for (var i = 0; i < listKota.length; i++) {
  //     if (listKota[i]['prov_id'] == provId) {
  //       listStringKota.add(listKota[i]['city_name']);
  //     }
  //   }
  // }

  Future<dynamic> generateKota(name) async {
    final prefs = await SharedPreferences.getInstance();
    final String? area = prefs.getString('area');
    debugPrint('name $name');
    for (var i = 0; i < listKota.length; i++) {
      if (listKota[i]['city_name'] == name) {
        if (area != null) {
          idKota.value = listKota[i]['id'].toString();
        } else {
          idKota.value = listKota[i]['city_id'];
        }
      }
    }

    debugPrint('idKota $idKota');
    getKecamatan(idKota.value);
    // getListKecamatan(idKota.value);
  }

  // Future<dynamic> getListKecamatan(cityId) async {
  //   // debugPrint('cityId $cityId');
  //   // debugPrint('kec $listKecamatan');

  //   listStringKecamatan.clear();
  //   for (var i = 0; i < listKecamatan.length; i++) {
  //     if (listKecamatan[i]['city_id'] == cityId) {
  //       listStringKecamatan.add(listKecamatan[i]['dis_name']);
  //     }

  //     // debugPrint('kec $listKecamatan');
  //   }
  //   // debugPrint('kec $listStringKecamatan');

  //   // debugPrint('kec $listStringKecamatan');
  // }

  Future<dynamic> generateKecamatan(name) async {
    // debugPrint('name kec $name');
    final prefs = await SharedPreferences.getInstance();
    final String? area = prefs.getString('area');
    for (var i = 0; i < listKecamatan.length; i++) {
      if (listKecamatan[i]['dis_name'] == name) {
        if (area != null) {
          idKecamatan.value = listKecamatan[i]['id'].toString();
        } else {
          idKecamatan.value = listKecamatan[i]['dis_id'];
        }
      }
    }
    debugPrint('id kec ${idKecamatan.value}');
    // getListKelurahan(idKecamatan.value);
    getKelurahan(idKecamatan.value);
  }

  // Future<dynamic> getListKelurahan(kecamatanId) async {
  //   listStringKelurahan.clear();
  //   for (var i = 0; i < listKelurahan.length; i++) {
  //     debugPrint('kecamatanId $kecamatanId');
  //     if (listKelurahan[i]['dis_id'] == kecamatanId) {
  //       // debugPrint('kel ${listKelurahan[i]}');
  //       listStringKelurahan.add(listKelurahan[i]['subdis_name']);
  //       break;
  //       //
  //     }
  //   }
  // }

  Future createCustomer(body) async {
    EasyLoading.show(status: 'memuat...');
    setIsTouch(true);
    token = CancelToken();
    final prefs = await SharedPreferences.getInstance();
    final String? area = prefs.getString('area');
    if (area != null) {
      var response =
          await APIServices.newSendWithFiles('/customer', body, token);
      if (response['success'] == true) {
        getData();
        EasyLoading.showSuccess('Tambah customer berhasil');
        EasyLoading.dismiss();
        setIsTouch(false);

        return Get.back();
      } else {
        EasyLoading.dismiss();
        setIsTouch(false);
        EasyLoading.showError('${response['message']}');
      }
    } else {
      var response = await APIServices.getApi(
          '/customer/tambah_customer.php', body, token);
      if (response['success'] == true) {
        getData();
        EasyLoading.showSuccess('Tambah customer berhasil');
        EasyLoading.dismiss();
        setIsTouch(false);

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
