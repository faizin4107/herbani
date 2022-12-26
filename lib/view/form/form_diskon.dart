import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:herbani/controller/form.dart';
import 'package:herbani/helper/textstyle_custom.dart';
import 'package:herbani/util/constant.dart';
import 'package:herbani/widget/appbar/appbar_default.dart';
import 'package:styled_text/styled_text.dart';

class FormDiskon extends StatefulWidget {
  const FormDiskon({Key? key}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _FormDiskonState createState() => _FormDiskonState();
}

class _FormDiskonState extends State<FormDiskon> {
  final FormController form = Get.put(FormController());
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController diskonController = TextEditingController();
  TextEditingController diskonCashController = TextEditingController();

  dio.CancelToken token = dio.CancelToken();
  // ignore: prefer_typing_uninitialized_variables
  var tipePembayaran;
  List<dynamic> dataHarga = [];
  List<dynamic> records = [];
  List<dynamic> recordsDisplay = [];
  List<dynamic> fields = [];
  File? image;
  // ignore: prefer_typing_uninitialized_variables
  var typeFile;
  // ignore: prefer_typing_uninitialized_variables
  var extFile;
  // ignore: prefer_typing_uninitialized_variables
  var fileName;
  // ignore: prefer_typing_uninitialized_variables
  var title;
  // ignore: prefer_typing_uninitialized_variables
  var latitude;
  // ignore: prefer_typing_uninitialized_variables
  var longitude;
  @override
  void initState() {
    super.initState();
    setState(() {
      title = Get.arguments['title'];
      dataHarga = Get.arguments['data_harga'];
      records = Get.arguments['records'];
      recordsDisplay = Get.arguments['records_display'];
      fields = Get.arguments['fields'];
      image = Get.arguments['image'];
      typeFile = Get.arguments['typeFile'];
      extFile = Get.arguments['extFile'];
      fileName = Get.arguments['fileName'];
      tipePembayaran = Get.arguments['tipe_pembayaran'];
      latitude = Get.arguments['latitude'];
      longitude = Get.arguments['longitude'];
      if (tipePembayaran == 'CASH') {
        diskonCashController = TextEditingController(text: '3');
      } else {
        diskonCashController = TextEditingController(text: '');
      }
    });
  }

  getSubmit() async {
    records.removeWhere((item) => item['label'] == 'List Order');
    recordsDisplay.removeWhere((item) => item['label'] == 'List Order');
    Map<String, dynamic> dataSebelumDiskon = {};
    Map<String, dynamic> dataSetelahDiskon = {};

    Map<String, dynamic> newHargaSebelumDiskon = {};
    List<dynamic> listLabelHargaSebelumDiskon = [];
    newHargaSebelumDiskon.clear();
    dataSebelumDiskon.clear();
    listLabelHargaSebelumDiskon.clear();

    Map<String, dynamic> newHargaSetelahDiskon = {};
    List<dynamic> listLabelHargaSetelahDiskon = [];
    Map combineHargaSetelahDiskon = {};
    newHargaSetelahDiskon.clear();
    listLabelHargaSetelahDiskon.clear();
    dataSetelahDiskon.clear();
    var totalProduk = 0;
    int newDiskon = 0;

    for (var i = 0; i < dataHarga.length; i++) {
      dataSetelahDiskon['produk'] = dataHarga[i]['produk'];
      dataSetelahDiskon['harga_jual'] = dataHarga[i]['harga'];
      dataSetelahDiskon['id_pdk'] = dataHarga[i]['id_pdk'];
      dataSetelahDiskon['kode_pdk'] = dataHarga[i]['kode_pdk'];
      dataSetelahDiskon['diskon_toko'] = diskonController.text;
      dataSetelahDiskon['diskon_cash'] =
          diskonCashController.text == '' ? '0' : diskonCashController.text;
      int totalHargaJual = 0;
      int diskonToko = 0;
      int hargaSetelahDiskon = 0;
      int totalDiskonToko = 0;
      int diskonCash = 0;
      
      if (tipePembayaran == 'CASH') {
        totalHargaJual = int.parse(dataHarga[i]['harga']) *
            int.parse(dataHarga[i]['jml_order']);
        diskonToko = (totalHargaJual * int.parse(diskonController.text)) ~/ 100;
        totalDiskonToko = totalHargaJual - diskonToko;
        diskonCash =
            (totalDiskonToko * int.parse(diskonCashController.text)) ~/ 100;
        hargaSetelahDiskon = totalDiskonToko - diskonCash;
        totalProduk = totalProduk + hargaSetelahDiskon;
      } else {
        totalHargaJual = int.parse(dataHarga[i]['harga']) *
            int.parse(dataHarga[i]['jml_order']);
        diskonToko = (totalHargaJual * int.parse(diskonController.text)) ~/ 100;
        hargaSetelahDiskon = totalHargaJual - diskonToko;
        totalProduk = totalProduk + hargaSetelahDiskon;
      }

      dataSetelahDiskon['harga_sebelum_diskon'] = totalHargaJual.toString();
      dataSetelahDiskon['harga_setelah_diskon'] = hargaSetelahDiskon.toString();

      dataSetelahDiskon['jml_order'] = dataHarga[i]['jml_order'];
      combineHargaSetelahDiskon = {
        ...combineHargaSetelahDiskon,
        ...dataSetelahDiskon
      };
      listLabelHargaSetelahDiskon.add(combineHargaSetelahDiskon);
    }
    newHargaSetelahDiskon['label'] = 'List Order';
    newHargaSetelahDiskon['value'] = listLabelHargaSetelahDiskon;
    recordsDisplay.add(newHargaSetelahDiskon);

    final jsonList = recordsDisplay.map((item) => jsonEncode(item)).toList();
    final uniqueJsonList = jsonList.toSet().toList();
    var result = uniqueJsonList.map((item) => jsonDecode(item)).toList();
    records.removeWhere((item) => item['label'] == 'List Order');
    Get.toNamed('/form_finish', arguments: {
      'diskon_toko': diskonController.text,
      'diskon_cash': diskonCashController.text == '' ? '0' : diskonCashController.text,
      'tipe_pembayaran': tipePembayaran.toString(),
      'data_order': result,
      'records': records,
      'records_display': result,
      'fields': fields,
      'image': image,
      'typeFile': typeFile,
      'extFile': extFile,
      'fileName': fileName,
      'totalProduk': totalProduk,
      'latitude': latitude,
      'longitude': longitude,
    });
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
          title: 'Diskon',
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
                  if (_formKey.currentState!.validate()) {
                    FocusScope.of(context).requestFocus(FocusNode());

                    getSubmit();
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
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20.h,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: StyledText(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            text:
                                'Tipe Pembayaran <bold>$tipePembayaran</bold>',
                            tags: {
                              'bold': StyledTextActionTag(
                                  (String? text,
                                      Map<String?, String?> attrs) {},
                                  style: textStyleCustom(context, Colors.black,
                                      12.sp, FontWeight.bold)),
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        ListTile(
                          title: Text(
                            '$title',
                            style: textStyleFormTitle(context),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: TextFormField(
                              controller: diskonController,
                              enableSuggestions: false,
                              style: textStyleFormTitle(context),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                border: InputBorder.none,
                                focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Color(0xFF979797), width: 0.5),
                                    borderRadius: BorderRadius.circular(5.0)),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Color(0xFF979797), width: 0.5),
                                    borderRadius: BorderRadius.circular(5.0)),
                                errorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Color(0xFF979797), width: 0.5),
                                    borderRadius: BorderRadius.circular(5.0)),
                                contentPadding: const EdgeInsets.only(
                                    left: 10.0, top: 18.0),
                                hintText: tipePembayaran == 'TEMPO'
                                    ? 'Masukkan persen diskon Toko'
                                    : 'Masukkan persen diskon CASH',
                                hintStyle: textStyleFormInput(context),
                                errorStyle: textStyleFormError(context),
                              ),
                              validator: (value) {
                                if (value == '') {
                                  if (tipePembayaran == 'TEMPO') {
                                    return 'Persen diskon toko wajib diisi';
                                  } else {
                                    return 'Persen diskon cash wajib diisi';
                                  }
                                }
                                return null;
                              },
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        tipePembayaran == 'CASH'
                            ? ListTile(
                                title: Text(
                                  'Diskon CASH dalam %',
                                  style: textStyleFormTitle(context),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: TextFormField(
                                    controller: diskonCashController,
                                    enableSuggestions: false,
                                    style: textStyleFormTitle(context),
                                    decoration: InputDecoration(
                                      enabled: false,
                                      filled: true,
                                      fillColor: Colors.blueGrey[100],
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
                                      hintText: 'Masukkan persen diskon CASH',
                                      hintStyle: textStyleFormInput(context),
                                      errorStyle: textStyleFormError(context),
                                    ),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                              )
                            : Container(),
                      ],
                    ),
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
