import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:herbani/controller/form.dart';
import 'package:herbani/helper/textstyle_custom.dart';
import 'package:herbani/util/constant.dart';
import 'package:herbani/widget/appbar/appbar_default.dart';

class FormPurchaseOrder extends StatefulWidget {
  const FormPurchaseOrder({Key? key}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _FormPurchaseOrderState createState() => _FormPurchaseOrderState();
}

class _FormPurchaseOrderState extends State<FormPurchaseOrder> {
  final FormController form = Get.put(FormController());
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController tipePembayaranController = TextEditingController();
  dio.CancelToken token = dio.CancelToken();
  List<dynamic> dataHarga = [];
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
      dataHarga = Get.arguments['data_harga'];
      records = Get.arguments['records'];
      fields = Get.arguments['fields'];
      image = Get.arguments['image'];
      typeFile = Get.arguments['typeFile'];
      extFile = Get.arguments['extFile'];
      fileName = Get.arguments['fileName'];
      latitude = Get.arguments['latitude'];
      longitude = Get.arguments['longitude'];
    });
    super.initState();
  }

  String? tipePembayaran;

  void _handleRadio(String value) {
    setState(() {
      tipePembayaran = value;
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
          title: 'Tipe Pembayaran',
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
                  if (tipePembayaran == null || tipePembayaran == '') {
                    EasyLoading.showInfo('Mohon pilih tipe pembayaran');
                  } else {
                    records
                        .removeWhere((item) => item['label'] == 'List Order');
                    FocusScope.of(context).requestFocus(FocusNode());
                    if (tipePembayaran == 'CASH') {
                      return Get.toNamed('/form_diskon', arguments: {
                        'tipe_pembayaran': tipePembayaran.toString(),
                        'data_harga': dataHarga,
                        'records': records,
                        'records_display': records,
                        'fields': fields,
                        'image': image,
                        'typeFile': typeFile,
                        'extFile': extFile,
                        'fileName': fileName,
                        'title': tipePembayaran == 'TEMPO'
                            ? 'Persen Diskon dan TOP'
                            : 'Diskon',
                        'latitude': latitude,
                        'longitude': longitude,
                      });
                    } else {
                      return Get.toNamed('/form_tempo', arguments: {
                        'tipe_pembayaran': tipePembayaran.toString(),
                        'data_harga': dataHarga,
                        'records': records,
                        'records_display': records,
                        'fields': fields,
                        'image': image,
                        'typeFile': typeFile,
                        'extFile': extFile,
                        'fileName': fileName,
                        'title': tipePembayaran == 'TEMPO'
                            ? 'Persen Diskon dan TOP'
                            : 'Diskon',
                        'latitude': latitude,
                        'longitude': longitude,
                      });
                    }
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
                            SizedBox(
                              height: 10.h,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 18.0),
                              child: Text(
                                'Tipe Pembayaran',
                                style: textStyleFormTitle(context),
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            RadioListTile(
                              dense: true,
                              value: 'TEMPO',
                              groupValue: tipePembayaran,
                              title: Text(
                                'TEMPO',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: textStyleFormTitle(context),
                              ),
                              onChanged: (val) {
                                _handleRadio(val.toString());
                              },
                              activeColor: Colors.blue[900],
                            ),
                            RadioListTile(
                              dense: true,
                              value: 'CASH',
                              groupValue: tipePembayaran,
                              title: Text(
                                'CASH',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: textStyleFormTitle(context),
                              ),
                              onChanged: (val) {
                                _handleRadio(val.toString());
                              },
                              activeColor: Colors.blue[900],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
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
