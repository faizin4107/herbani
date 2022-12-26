import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:herbani/controller/form.dart';
import 'package:herbani/helper/alert_custom.dart';
import 'package:herbani/helper/textstyle_custom.dart';
import 'package:herbani/util/constant.dart';
import 'package:herbani/widget/appbar/appbar_default.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class FormOrder extends StatefulWidget {
  const FormOrder({Key? key}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _FormOrderState createState() => _FormOrderState();
}

class _FormOrderState extends State<FormOrder> {
  final FormController form = Get.put(FormController());
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController jmlOrderController = TextEditingController();
  TextEditingController orderanController = TextEditingController();
  TextEditingController orderanValController = TextEditingController();
  TextEditingController orderanHargaController = TextEditingController();
  TextEditingController orderanKodeController = TextEditingController();
  TextEditingController orderanStokController = TextEditingController();

  dio.CancelToken token = dio.CancelToken();

  List<dynamic> dataOrder = [];
  List<dynamic> dataOrderVal = [];
  List<dynamic> dataOrderHarga = [];
  List<dynamic> records = [];
  List<dynamic> fields = [];
  File? image;
  // ignore: prefer_typing_uninitialized_variables
  var typeFile;
  // ignore: prefer_typing_uninitialized_variables
  var extFile;
  // ignore: prefer_typing_uninitialized_variables
  var fileName;
  // ignore: prefer_typing_uninitialized_variables
  var latitude;
  // ignore: prefer_typing_uninitialized_variables
  var longitude;
  @override
  void initState() {
    setState(() {
      records = Get.arguments['records'];
      fields = Get.arguments['fields'];
      image = Get.arguments['image'];
      typeFile = Get.arguments['typeFile'];
      extFile = Get.arguments['extFile'];
      fileName = Get.arguments['fileName'];
      latitude = Get.arguments['latitude'];
      longitude = Get.arguments['longitude'];
    });
    Get.put(FormController()).getProduk();
    super.initState();
  }

  @override
  void dispose() {
    jmlOrderController.dispose();
    orderanController.dispose();
    orderanValController.dispose();
    orderanHargaController.dispose();
    orderanStokController.dispose();
    super.dispose();
  }

  Future<bool> checkDuplicate(str) async {
    bool allowInput = false;
    for (var i = 0; i < dataOrderHarga.length; i++) {
      if (str == dataOrderHarga[i]['produk']) {
        allowInput = true;
      } else {
        allowInput = false;
      }
    }
    return allowInput;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        EasyLoading.dismiss();
        Get.back();
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        key: _scaffoldKey,
        appBar: const AppBarDefault(
          title: 'Pilih Orderan',
        ),
        bottomNavigationBar: Padding(
            padding: EdgeInsets.fromLTRB(
                15.0, 0, 15.0, GetPlatform.isAndroid ? 15 : 20),
            child: SizedBox(
              height: GetPlatform.isAndroid ? 30.h : 35.h,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  textStyle: textStyleButtonLogin(context),
                ),
                onPressed: () async {
                  if (dataOrder.isEmpty) {
                    FocusScope.of(context).requestFocus(FocusNode());
                    return orangeDialog(
                        context,
                        'Silahkan pilih orderan dan masukkan jumlah orderan dan klik tombol tambah terlebih dahulu',
                        AlertType.info);
                  } else {
                    FocusScope.of(context).requestFocus(FocusNode());
                    Get.toNamed('/form_purchase_order', arguments: {
                      // 'data_order': dataOrderVal,
                      'data_harga': dataOrderHarga,
                      'records': records,
                      'fields': fields,
                      'image': image,
                      'typeFile': typeFile,
                      'extFile': extFile,
                      'fileName': fileName,
                      'latitude': latitude,
                      'longitude': longitude,
                    });
                  }
                },
                child: const Text(
                  'Lanjut',
                ),
              ),
            )),
        body: SafeArea(
          child: Container(
            color: const Color(0xFFF9F9F9),
            height: double.infinity,
            width: double.infinity,
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: ScrollConfiguration(
                  behavior: const ScrollBehavior(),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15.0, 10, 15.0, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 10.h,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 12.0, right: 12.0, top: 12.0),
                              child: DropdownFormField<Map<String, dynamic>>(
                                onEmptyActionPressed: () async {},
                                emptyText: 'Tidak ada data',
                                dropdownHeight: 300.h,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    suffixIcon: Icon(Icons.arrow_drop_down),
                                    labelText: "Orderan"),
                                onSaved: (dynamic str) async {
                                  setState(() {
                                    debugPrint('statement ${str['stok']}');
                                    orderanController = TextEditingController(
                                        text: str['nama_pdk']);
                                    orderanValController =
                                        TextEditingController(
                                            text: str['id_pdk']);
                                    orderanKodeController =
                                        TextEditingController(
                                            text: str['kode_pdk']);
                                    orderanHargaController =
                                        TextEditingController(
                                            text: str['harga_jual']);
                                    orderanStokController =
                                        TextEditingController(
                                            text: str['stok']);
                                  });
                                },
                                onChanged: (dynamic str) async {
                                  setState(() {
                                    debugPrint('statement ${str['stok']}');
                                    orderanController = TextEditingController(
                                        text: str['nama_pdk']);
                                    orderanValController =
                                        TextEditingController(
                                            text: str['id_pdk']);
                                    orderanKodeController =
                                        TextEditingController(
                                            text: str['kode_pdk']);
                                    orderanHargaController =
                                        TextEditingController(
                                            text: str['harga_jual']);
                                    orderanStokController =
                                        TextEditingController(
                                            text: str['stok']);
                                  });
                                },
                                validator: (dynamic str) {
                                  if (str == '' || str == null) {
                                    return 'Orderan wajib diisi';
                                  }
                                  return null;
                                },
                                displayItemFn: (dynamic item) => Text(
                                  (item ?? {})['nama_pdk'] ?? '',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                findFn: (dynamic str) async => form.listProduk,
                                selectedFn: (dynamic item1, dynamic item2) {
                                  if (item1 != null && item2 != null) {
                                    return item1['nama_pdk'] ==
                                        item2['nama_pdk'];
                                  }
                                  return false;
                                },
                                filterFn: (dynamic item, str) =>
                                    item['nama_pdk']
                                        .toLowerCase()
                                        .indexOf(str.toLowerCase()) >=
                                    0,
                                dropdownItemFn: (dynamic item,
                                        int position,
                                        bool focused,
                                        bool selected,
                                        Function() onTap) =>
                                    ListTile(
                                  title: Text(item['nama_pdk']),
                                  tileColor: focused
                                      ? const Color.fromARGB(20, 0, 0, 0)
                                      : Colors.transparent,
                                  onTap: onTap,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            jmlOrderController.text == ''
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: const [
                                      Text(
                                          'Pilih menu orderan diatas untuk memilih produk'),
                                      Icon(Icons.arrow_circle_up_rounded),
                                    ],
                                  )
                                : Container(),
                            const Divider(
                              color: Colors.blue,
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            orderanController.text != ''
                                ? ListTile(
                                    title: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Banyaknya pesanan:',
                                          style: textStyleFormTitle(context),
                                        ),
                                        SizedBox(
                                          height: 3.h,
                                        ),
                                        Text(
                                          orderanController.text,
                                          style: textStyleFormTitle(context),
                                        ),
                                      ],
                                    ),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.only(top: 5.0),
                                      child: TextFormField(
                                        controller: jmlOrderController,
                                        enableSuggestions: false,
                                        style: textStyleFormTitle(context),
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white,
                                          border: InputBorder.none,
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Color(0xFF979797),
                                                  width: 0.5),
                                              borderRadius:
                                                  BorderRadius.circular(5.0)),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Color(0xFF979797),
                                                  width: 0.5),
                                              borderRadius:
                                                  BorderRadius.circular(5.0)),
                                          errorBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Color(0xFF979797),
                                                  width: 0.5),
                                              borderRadius:
                                                  BorderRadius.circular(5.0)),
                                          contentPadding: const EdgeInsets.only(
                                              left: 10.0, top: 18.0),
                                          hintText: 'Masukkan jumlah orderan',
                                          hintStyle:
                                              textStyleFormInput(context),
                                          errorStyle:
                                              textStyleFormError(context),
                                        ),
                                        validator: (value) {
                                          if (value == '' || value == null) {
                                            return 'Jumlah order wajib diisi';
                                          }
                                          return null;
                                        },
                                        keyboardType: TextInputType.number,
                                      ),
                                    ),
                                  )
                                : Container(),
                            SizedBox(
                              height: 10.h,
                            ),
                            orderanController.text != ''
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15.0, right: 15.0),
                                    child: SizedBox(
                                      width: Get.size.width,
                                      height: 35.h,
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: primaryColor,
                                            textStyle: textStyleCustom(
                                                context,
                                                primaryColor,
                                                14.sp,
                                                FontWeight.bold),
                                          ),
                                          onPressed: () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              FocusScope.of(context)
                                                  .requestFocus(FocusNode());
                                              Map<String, dynamic> data = {};
                                              Map<String, dynamic> dataVal = {};
                                              Map<String, dynamic> dataHarga =
                                                  {};
                                              debugPrint(
                                                  'produk ${orderanStokController.text}');
                                              for (var i = 0;
                                                  i < form.listProduk.length;
                                                  i++) {
                                                if (form.listProduk[i]
                                                        ['id_pdk'] ==
                                                    orderanValController.text) {
                                                  debugPrint(
                                                      'order val ${form.listProduk[i]['stok']}');
                                                  debugPrint(
                                                      'no ${jmlOrderController.text}');
                                                  if (int.parse(
                                                          jmlOrderController
                                                              .text) >
                                                      int.parse(
                                                          form.listProduk[i]
                                                              ['stok'])) {
                                                    orangeDialog(
                                                        context,
                                                        'Jumlah order melebihi jumlah stok produk yang tersedia, jumlah stok yang tersedia adalah ${form.listProduk[i]['stok']}',
                                                        AlertType.info);
                                                  } else {
                                                    var check = dataOrderHarga
                                                        .where((val) =>
                                                            val['produk'] ==
                                                            orderanController
                                                                .text);
                                                    if (check.isNotEmpty) {
                                                      orangeDialog(
                                                          context,
                                                          'Anda sudah memasukkan produk ${orderanController.text}, silahkan pilih produk yang lain atau hapus produk ${orderanController.text} terlebih dahulu',
                                                          AlertType.info);
                                                    } else {
                                                      setState(() {
                                                        data['order'] =
                                                            orderanController
                                                                .text;
                                                        data['jml_order'] =
                                                            jmlOrderController
                                                                .text;
                                                        dataHarga['produk'] =
                                                            orderanController
                                                                .text;
                                                        dataHarga['harga'] =
                                                            orderanHargaController
                                                                .text;
                                                        dataHarga['jml_order'] =
                                                            jmlOrderController
                                                                .text;
                                                        dataHarga['id_pdk'] =
                                                            orderanValController
                                                                .text;
                                                        dataHarga['kode_pdk'] =
                                                            orderanKodeController
                                                                .text;

                                                        dataOrder.add(data);
                                                        dataOrderVal
                                                            .add(dataVal);
                                                        dataOrderHarga
                                                            .add(dataHarga);
                                                        orderanController
                                                            .clear();
                                                        orderanValController
                                                            .clear();
                                                        orderanKodeController
                                                            .clear();
                                                        jmlOrderController
                                                            .clear();
                                                        orderanHargaController
                                                            .clear();
                                                      });
                                                    }
                                                  }
                                                }
                                              }
                                            }
                                          },
                                          child: const Text('Tambah')),
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      orderanController.text != ''
                          ? const Divider(
                              color: Colors.blue,
                            )
                          : Container(),
                      Expanded(
                        child: dataOrder.isEmpty
                            ? const Text('')
                            : ListView.builder(
                                physics: const AlwaysScrollableScrollPhysics(),
                                shrinkWrap: true,
                                addAutomaticKeepAlives: true,
                                itemCount: dataOrder.length,
                                itemBuilder: (BuildContext context, int index) {
                                  // print('order ${dataOrder[index]['order']}');
                                  return Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        31.0, 15, 31.0, 0.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.green, width: 2.0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5.0.r))),
                                      height: 170.h,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          AppBar(
                                            shape: RoundedRectangleBorder(
                                              side: BorderSide.none,
                                              borderRadius: BorderRadius.only(
                                                  topLeft:
                                                      Radius.circular(5.0.r),
                                                  topRight:
                                                      Radius.circular(5.0.r)),
                                            ),
                                            leading:
                                                const Icon(Icons.verified_user),
                                            elevation: 2.5,
                                            title: Text(
                                              'Orderan',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: textStyleCustom(
                                                  context,
                                                  Colors.white,
                                                  14.sp,
                                                  FontWeight.bold),
                                            ),
                                            backgroundColor: primaryColor,
                                            centerTitle: true,
                                            actions: <Widget>[
                                              IconButton(
                                                  icon:
                                                      const Icon(Icons.delete),
                                                  onPressed: () {
                                                    setState(() {
                                                      dataOrder.removeAt(index);
                                                      dataOrderVal
                                                          .removeAt(index);
                                                      dataOrderHarga
                                                          .removeAt(index);
                                                    });
                                                  }),
                                            ],
                                          ),
                                          Expanded(
                                              child: Column(
                                            children: [
                                              ListTile(
                                                visualDensity:
                                                    const VisualDensity(
                                                        vertical: -2),
                                                dense: true,
                                                title: const Text(
                                                  'Produk',
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                subtitle: Text(
                                                  '${dataOrder[index]['order']}',
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              const Divider(
                                                color: Colors.blue,
                                              ),
                                              ListTile(
                                                visualDensity:
                                                    const VisualDensity(
                                                        vertical: -2),
                                                dense: true,
                                                title: const Text(
                                                  'Jumlah Produk',
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                subtitle: Text(
                                                  '${dataOrder[index]['jml_order']}',
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          )),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
