import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:herbani/API/services.dart';
import 'package:herbani/controller/home.dart';
import 'package:herbani/controller/invoice.dart';
import 'package:herbani/helper/alert_custom.dart';
import 'package:herbani/helper/function.dart';
import 'package:herbani/model/global_list.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FormController extends GetxController
    with StateMixin<List<dynamic>>, GlobalList {
  CancelToken token = CancelToken();

  @override
  void onInit() {
    initData();
    getUser();
    getProduk();
    super.onInit();
  }

  Future initData() async {
    setInputLokasi('');
  }

  List<String> listUser = [];
  List<Map<String, dynamic>> listProduk = [];
  List<Map<String, dynamic>> listOrder = [];
  List<Map<String, dynamic>> listCustomer = [];
  List<Map<String, dynamic>> listPreorder = [];

  var inputLokasi = ''.obs;
  setInputLokasi(String val) {
    inputLokasi.value = val;
  }

  var errorCustomer = false.obs;
  setErrorCustomer(bool val) {
    errorCustomer.value = val;
  }

  Future<dynamic> getUser() async {
    change(null, status: RxStatus.loading());
    listUser.clear();
    token = CancelToken();
    var url = '/user/list_user.php';
    Map body = {
      'level': '1',
    };
    await APIServices.getApi(url, body, token).then((response) {
      if (response['success'] == true) {
        for (var i = 0; i < response['data'].length; i++) {
          listUser.add(response['data'][i]['username'].toString());
        }

        return change(response['data'], status: RxStatus.success());
      }
      return change(response, status: RxStatus.success());
    });
  }

  Future<dynamic> getProduk() async {
    change(null, status: RxStatus.loading());
    listProduk.clear();
    token = CancelToken();
    final prefs = await SharedPreferences.getInstance();
    final String? area = prefs.getString('area');
    final String? disId = prefs.getString('distributor_id');
    String? url;
    Map body = {};
    if (area != null) {
      url = '/show-produk/$disId';
      await APIServices.newApi(url, body, token).then((response) {
        if (response['success'] == true) {
          debugPrint('produk 1 $response');
          Map<String, dynamic> data = {};
          Map<String, dynamic> combine = {};
          for (var i = 0; i < response['data'].length; i++) {
            // debugPrint('data produk ${}')
            data['id_pdk'] = response['data'][i]['produk']['id'].toString();
            data['kode_pdk'] = response['data'][i]['produk']['kode'].toString();
            data['nama_pdk'] = response['data'][i]['produk']['produk'].toString();
            data['harga_jual'] = response['data'][i]['produk']['harga_jual'].toString();
            data['stok'] = response['data'][i]['produk']['stok'].toString();
            combine = {...combine, ...data};
            listProduk.add(combine);
          }
          

          return change(response['data'], status: RxStatus.success());
        }
        return change(response, status: RxStatus.success());
      });
    } else {
      url = '/produk/list_produk.php';
      await APIServices.getApi(url, body, token).then((response) {
        if (response['success'] == true) {
          Map<String, dynamic> data = {};
          Map<String, dynamic> combine = {};
          for (var i = 0; i < response['data'].length; i++) {
            data['id_pdk'] = response['data'][i]['id_pdk'].toString();
            data['kode_pdk'] = response['data'][i]['kode_pdk'].toString();
            data['nama_pdk'] = response['data'][i]['nama_pdk'].toString();
            data['harga_jual'] = response['data'][i]['harga_jual'].toString();
            data['stok'] = response['data'][i]['stok'].toString();
            combine = {...combine, ...data};
            listProduk.add(combine);
          }
          debugPrint('produk 2 $listProduk');

          return change(response['data'], status: RxStatus.success());
        }
        return change(response, status: RxStatus.success());
      });
    }
  }

  Future<dynamic> getCustomer() async {
    change(null, status: RxStatus.loading());
    listCustomer.clear();
    token = CancelToken();
    final prefs = await SharedPreferences.getInstance();
    final String? area = prefs.getString('area');
    final String? id = prefs.getString('distributor_id');
    debugPrint('id $id');
    Map body = {};
    String? url;
    if (area != null) {
      url = '/show-customer/$id';
      await APIServices.newApi(url, body, token).then((response) {
        if (response['success'] == true) {
          Map<String, dynamic> data = {};
          Map<String, dynamic> combine = {};
          for (var i = 0; i < response['data'].length; i++) {
            data['id_pembeli'] = response['data'][i]['id'].toString();
            data['nama_pembeli'] =
                response['data'][i]['nama_pembeli'].toString();
            data['alamat'] = response['data'][i]['alamat'].toString();
            data['kelurahan'] = response['data'][i]['kelurahan_id'].toString();
            data['kecamatan'] = response['data'][i]['kecamatan_id'].toString();
            data['provinsi'] = response['data'][i]['provinsi_id'].toString();
            data['kota'] = response['data'][i]['kota_id'].toString();
            data['no_telp'] = response['data'][i]['no_telp'].toString();
            data['lat_cst'] = response['data'][i]['latitude'].toString();
            data['lon_cst'] = response['data'][i]['longitude'].toString();
            data['id_distributor'] =
                response['data'][i]['distributor_id'].toString();
            combine = {...combine, ...data};
            listCustomer.add(combine);
          }

          debugPrint('pesanan listOrder $listCustomer');

          return change(response['data'], status: RxStatus.success());
        } else {
          return change(null, status: RxStatus.error());
        }
      });
    } else {
      url = '/customer/customer.php';
      await APIServices.getApi(url, body, token).then((response) {
        if (response['success'] == true) {
          Map<String, dynamic> data = {};
          Map<String, dynamic> combine = {};
          for (var i = 0; i < response['data'].length; i++) {
            data['id_pembeli'] = response['data'][i]['id_pembeli'].toString();
            data['nama_pembeli'] =
                response['data'][i]['nama_pembeli'].toString();
            data['alamat'] = response['data'][i]['alamat'].toString();
            data['kelurahan'] = response['data'][i]['kelurahan'].toString();
            data['kecamatan'] = response['data'][i]['kecamatan'].toString();
            data['provinsi'] = response['data'][i]['provinsi'].toString();
            data['kota'] = response['data'][i]['kota'].toString();
            data['no_telp'] = response['data'][i]['no_telp'].toString();
            data['lat_cst'] = response['data'][i]['lat_cst'].toString();
            data['lon_cst'] = response['data'][i]['lon_cst'].toString();
            data['id_distributor'] = '';
            // data['kompetitor'] = response['data'][i]['kompetitor'].toString();
            combine = {...combine, ...data};
            listCustomer.add(combine);
          }

          debugPrint('pesanan listOrder $listCustomer');

          return change(response['data'], status: RxStatus.success());
        } else {
          return change(null, status: RxStatus.error());
        }
      });
    }
  }

  Future<dynamic> getPreorder() async {
    change(null, status: RxStatus.loading());
    listPreorder.clear();
    token = CancelToken();
    final prefs = await SharedPreferences.getInstance();
    final String? area = prefs.getString('area');
    final String? id = prefs.getString('distributor_id');
    // debugPrint('id $id');
    Map<String, dynamic> data = {};
    Map body = {};
    String? url;
    if (area != null) {
      url = '/show-preorder-id/$id';
      await APIServices.newApi(url, body, token).then((response) {
        debugPrint('preorder ${response['data'].length}');
        debugPrint('preorder ${response['data']}');
        if (response['success'] == true) {
          
          Map<String, dynamic> combine = {};
          for (var i = 0; i < response['data'].length; i++) {
            data['id'] = response['data'][i]['id'].toString();
            data['kode'] = response['data'][i]['kode'].toString();
            data['customer_id'] = response['data'][i]['customer_id'].toString();
            data['nama_pembeli'] =
                response['data'][i]['customer']['nama_pembeli'].toString();
            data['alamat'] =
                response['data'][i]['customer']['alamat'].toString();
            data['tgl_po'] = response['data'][i]['tgl_po'].toString();
            combine = {...combine, ...data};
            listPreorder.add(combine);
          }

          debugPrint('pesanan listOrder $listPreorder');

          return change(response['data'], status: RxStatus.success());
        } else {
          return change(null, status: RxStatus.error());
        }
      });
    } else {
      url = '/customer/customer.php';
      await APIServices.getApi(url, body, token).then((response) {
        if (response['success'] == true) {
          Map<String, dynamic> data = {};
          Map<String, dynamic> combine = {};
          for (var i = 0; i < response['data'].length; i++) {
            data['id_pembeli'] = response['data'][i]['id_pembeli'].toString();
            data['nama_pembeli'] =
                response['data'][i]['nama_pembeli'].toString();
            data['alamat'] = response['data'][i]['alamat'].toString();
            data['kelurahan'] = response['data'][i]['kelurahan'].toString();
            data['kecamatan'] = response['data'][i]['kecamatan'].toString();
            data['provinsi'] = response['data'][i]['provinsi'].toString();
            data['kota'] = response['data'][i]['kota'].toString();
            data['no_telp'] = response['data'][i]['no_telp'].toString();
            data['lat_cst'] = response['data'][i]['lat_cst'].toString();
            data['lon_cst'] = response['data'][i]['lon_cst'].toString();
            data['id_distributor'] = '';
            // data['kompetitor'] = response['data'][i]['kompetitor'].toString();
            combine = {...combine, ...data};
            listCustomer.add(combine);
          }

          debugPrint('pesanan listOrder $listCustomer');

          return change(response['data'], status: RxStatus.success());
        } else {
          return change(null, status: RxStatus.error());
        }
      });
    }
  }

  Future sendData(url, body) async {
    token = CancelToken();
    final prefs = await SharedPreferences.getInstance();
    final String? area = prefs.getString('area');
    if (area != null) {
      var response = await APIServices.newSendWithFiles(url, body, token);
      if (response['success'] == true) {
        EasyLoading.dismiss();
        setIsTouch(false);
        EasyLoading.showSuccess('${response['message']}');
        Get.offNamedUntil('/home_distributor', (route) => false);
      } else {
        EasyLoading.dismiss();
        setIsTouch(false);
        EasyLoading.showError('${response['message']}');
      }
    } else {
      var response = await APIServices.sendWithFiles(url, body, token);
      if (response['success'] == true) {
        EasyLoading.dismiss();
        setIsTouch(false);
        EasyLoading.showSuccess('${response['message']}');
        Get.offNamedUntil('/home', (route) => false);
      } else {
        EasyLoading.dismiss();
        setIsTouch(false);
        EasyLoading.showError('${response['message']}');
      }
    }
  }

  Future sendDataWithOrder(body) async {
    EasyLoading.show(status: 'memuat...');
    setIsTouch(true);
    token = CancelToken();
    final prefs = await SharedPreferences.getInstance();
    final String? area = prefs.getString('area');
    debugPrint('body preorder ${body.fields}');
    if (area != null) {
      var response =
          await APIServices.newSendWithFiles('/preorder', body, token);
      if (response['success'] == true) {
        return response;
      } else {
        EasyLoading.dismiss();
        setIsTouch(false);
        EasyLoading.showError('${response['message']}');
      }
      debugPrint('response uder $response');
    } else {
      var response = await APIServices.sendWithFiles(
          '/form/input_purchase_order.php', body, token);
      if (response['success'] == true) {
        return response;
      } else {
        EasyLoading.dismiss();
        setIsTouch(false);
        EasyLoading.showError('${response['message']}');
      }
    }
  }

  Future sendOrder(body) async {
    token = CancelToken();
    final prefs = await SharedPreferences.getInstance();
    final String? area = prefs.getString('area');
    debugPrint('order body $body');
    if (area != null) {
      var response =
          await APIServices.newSendWithFiles('/input-list-order', body, token);
      debugPrint('order response $response');
      if (response['success'] == true) {
        EasyLoading.dismiss();
        setIsTouch(false);
        EasyLoading.showSuccess('${response['message']}');
        Get.offNamedUntil('/home_distributor', (route) => false);
      } else {
        EasyLoading.dismiss();
        setIsTouch(false);
        EasyLoading.showError('${response['message']}');
      }
    } else {
      var response =
          await APIServices.sendWithFiles('/form/input_order.php', body, token);
      if (response['success'] == true) {
        EasyLoading.dismiss();
        setIsTouch(false);
        EasyLoading.showSuccess('${response['message']}');
        Get.offNamedUntil('/home', (route) => false);
      } else {
        EasyLoading.dismiss();
        setIsTouch(false);
        EasyLoading.showError('${response['message']}');
      }
    }
  }

  Future sendDataRetur(body) async {
    EasyLoading.show(status: 'memuat...');
    setIsTouch(true);
    token = CancelToken();
    final prefs = await SharedPreferences.getInstance();
    final String? area = prefs.getString('area');
    if (area != null) {
      var response = await APIServices.newSendWithFiles('/retur', body, token);
      debugPrint('response 10 $response');
      if (response['success'] == true) {
        return response;
      } else {
        EasyLoading.dismiss();
        setIsTouch(false);
        EasyLoading.showError('${response['message']}');
      }
      debugPrint('response uder $response');
    } else {
      var response = await APIServices.sendWithFiles(
          '/form/input_purchase_order.php', body, token);
      if (response['success'] == true) {
        return response;
      } else {
        EasyLoading.dismiss();
        setIsTouch(false);
        EasyLoading.showError('${response['message']}');
      }
    }
  }

  Future sendReturList(body) async {
    token = CancelToken();
    final prefs = await SharedPreferences.getInstance();
    final String? area = prefs.getString('area');
    if (area != null) {
      var response =
          await APIServices.newSendWithFiles('/input-list-retur', body, token);
      if (response['success'] == true) {
        EasyLoading.dismiss();
        setIsTouch(false);
        EasyLoading.showSuccess('${response['message']}');
        Get.offNamedUntil('/home_distributor', (route) => false);
      } else {
        EasyLoading.dismiss();
        setIsTouch(false);
        EasyLoading.showError('${response['message']}');
      }
    } else {
      var response =
          await APIServices.sendWithFiles('/form/input_order.php', body, token);
      if (response['success'] == true) {
        EasyLoading.dismiss();
        setIsTouch(false);
        EasyLoading.showSuccess('${response['message']}');
        Get.offNamedUntil('/home', (route) => false);
      } else {
        EasyLoading.dismiss();
        setIsTouch(false);
        EasyLoading.showError('${response['message']}');
      }
    }
  }

  Future terimaPo(body) async {
    EasyLoading.show(status: 'memuat...');
    setIsTouch(true);
    token = CancelToken();

    debugPrint('body $body');
    var response =
        await APIServices.sendWithFiles('/form/terima_po.php', body, token);
    debugPrint('success kirim pesanan $response');
    if (response['success'] == true) {
      EasyLoading.showSuccess('Konfirmasi terima PO berhasil');
      EasyLoading.dismiss();
      setIsTouch(false);
      final InvoiceController pengirimanController =
          Get.put(InvoiceController());

      pengirimanController.getData(null, 'Dikirim');
    } else {
      EasyLoading.dismiss();
      setIsTouch(false);
      EasyLoading.showInfo(response['message']);
    }
  }

  Future tolakPo(body) async {
    EasyLoading.show(status: 'memuat...');
    setIsTouch(true);
    token = CancelToken();
    debugPrint('body $body');
    var response =
        await APIServices.sendWithFiles('/form/tolak_po.php', body, token);
    debugPrint('success kirim pesanan $response');
    if (response['success'] == true) {
      EasyLoading.showSuccess('Konfirmasi tolak PO berhasil');
      EasyLoading.dismiss();
      setIsTouch(false);
      final InvoiceController pengirimanController =
          Get.put(InvoiceController());
      pengirimanController.getData(null, 'Dikirim');
    } else {
      EasyLoading.dismiss();
      setIsTouch(false);
      EasyLoading.showInfo(response['message']);
    }
  }

  Future konfirmasiPenagihan(body) async {
    EasyLoading.show(status: 'memuat...');
    setIsTouch(true);
    token = CancelToken();
    var response = await APIServices.sendWithFiles(
        '/form/penagihan_kolektor.php', body, token);

    debugPrint('success kirim pesanan $response');
    if (response['success'] == true) {
      EasyLoading.showSuccess('Konfirmasi penagihan berhasil dikirim');
      EasyLoading.dismiss();
      setIsTouch(false);
      return Get.back();
    } else {
      EasyLoading.dismiss();
      setIsTouch(false);
      EasyLoading.showError('${response['message']}');
    }
  }

  Future hapusPesanan(idPesanan) async {
    EasyLoading.show(status: 'memuat...');
    setIsTouch(true);
    token = CancelToken();
    final HomeController home = Get.put(HomeController());
    Map body = {'id_pesanan': idPesanan, 'level': home.namaLevel.value};
    var response =
        await APIServices.sendWithFiles('/form/hapus_pesanan.php', body, token);
    debugPrint('success kirim pesanan $response');
    if (response['success'] == true) {
      EasyLoading.showSuccess('Pesanan berhasil dihapus');
      EasyLoading.dismiss();
      setIsTouch(false);

      final InvoiceController controller = Get.put(InvoiceController());
      controller.getData(null, 'Dikirim');
    } else {
      EasyLoading.dismiss();
      setIsTouch(false);
      EasyLoading.showError('${response['message']}');
    }
  }

  var returExist = false.obs;
  setReturExist(bool val) {
    returExist.value = val;
  }

  Future<dynamic> checkReturExist(context, preId) async {
    EasyLoading.show(status: 'memuat...');
    setIsTouch(true);
    final prefs = await SharedPreferences.getInstance();
    final String? area = prefs.getString('area');
    final String? id = prefs.getString('id');
    final String? disId = prefs.getString('distributor_id');
    String? url;
    Map<String, dynamic> body = {};
    if (area != null) {
      url = '/check-retur-exist/$id/$disId/$preId';
    } else {}
    try {
      await checkConnection().then((connection) async {
        if (connection) {
          var response = await APIServices.newApi(url, body, token);
          if (response != null) {
            if (response['success'] == true) {
              if (response['data'] == 1) {
                setReturExist(true);
              } else {
                setReturExist(false);
              }
              return response;
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
