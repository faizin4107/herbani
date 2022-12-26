import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:herbani/controller/form.dart';
import 'package:herbani/helper/money_formatter.dart';
import 'package:herbani/helper/textstyle_custom.dart';
import 'package:herbani/util/constant.dart';
import 'package:herbani/widget/appbar/appbar_default.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FormFinish extends StatefulWidget {
  const FormFinish({Key? key}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _FormFinishState createState() => _FormFinishState();
}

class _FormFinishState extends State<FormFinish> {
  final FormController form = Get.put(FormController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController sebelumDiskonController = TextEditingController();
  TextEditingController setelahDiskonController = TextEditingController();
  dio.CancelToken token = dio.CancelToken();
  // ignore: prefer_typing_uninitialized_variables
  var tipePembayaran;
  List<dynamic> dataOrder = [];
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
  var diskonToko;
  // ignore: prefer_typing_uninitialized_variables
  var diskonCash;
  // ignore: prefer_typing_uninitialized_variables
  var totalProduk;
  // ignore: prefer_typing_uninitialized_variables
  var latitude;
  // ignore: prefer_typing_uninitialized_variables
  var longitude;
  @override
  void initState() {
    setState(() {
      diskonToko = Get.arguments['diskon_toko'];
      diskonCash = Get.arguments['diskon_cash'];
      dataOrder = Get.arguments['data_order'];
      records = Get.arguments['records'];
      recordsDisplay = Get.arguments['records_display'];
      fields = Get.arguments['fields'];
      image = Get.arguments['image'];
      typeFile = Get.arguments['typeFile'];
      extFile = Get.arguments['extFile'];
      fileName = Get.arguments['fileName'];
      tipePembayaran = Get.arguments['tipe_pembayaran'];
      totalProduk = Get.arguments['totalProduk'];
      latitude = Get.arguments['latitude'];
      longitude = Get.arguments['longitude'];
    });
    debugPrint('diskonToko $diskonToko');
    debugPrint('diskonCash $diskonCash');
    super.initState();
  }

  List<dynamic> valueList = [];
  Future<dynamic> submit() async {
    valueList.clear();
    Map<String, dynamic> data = {};
    // ignore: prefer_typing_uninitialized_variables
    // var wilayahSales;

    final prefs = await SharedPreferences.getInstance();
    final String? area = prefs.getString('area');
    if (area != null) {
      Map combine = {};
      for (var i = 0; i < fields.length; i++) {
        for (var j = 0; j < records.length; j++) {
          debugPrint('label ${records[j]['label']}');
          if (records[j]['label'] == 'Tanggal') {
            var inputFormat = DateFormat('dd-MM-yyyy');
            var inputDate = inputFormat.parse(records[j]['value']);
            var outputFormat = DateFormat('yyyy-MM-dd');
            var valDate = outputFormat.format(inputDate);
            data[fields[j]] = valDate;
          } else if (records[j]['label'] == 'Jam') {
            var periode = records[j]['value'].split(' ');
            data[fields[j]] = periode.first.toString();
          } else if (records[j]['label'] == 'ID') {
            data['customer_id'] = records[j]['value'];
          } else if (records[j]['label'] == 'Dis ID') {
            data['distributor_id'] = records[j]['value'];
          } else if (records[j]['label'] == 'Tempo') {
            data['tempo_kredit'] = records[j]['value'];
          } else {
            data[fields[j]] = records[j]['value'];
          }
          Map<String, dynamic> valTipeFile = {'tipe_file': typeFile};
          Map<String, dynamic> valExtFile = {'ext_file': extFile};
          Map<String, dynamic> valTipePembayaran = {
            'tipe_pembayaran': tipePembayaran
          };
          final prefs = await SharedPreferences.getInstance();
          Map<String, dynamic> valIdUser = {'user_id': prefs.getString('id')};
          Map<String, dynamic> dataFileName = {
            'file_name': fileName.toString()
          };
          Map<String, dynamic> dataLatitude = {'latitude': latitude.toString()};
          Map<String, dynamic> datalongitude = {
            'longitude': longitude.toString()
          };
          Map<String, dynamic> dataDiskonToko = {'diskon_toko': diskonToko.toString()};
           Map<String, dynamic> dataDiskonCash = {'diskon_cash': diskonCash.toString()};
          Map<String, dynamic> dataTotal = {
            'total_tagihan': totalProduk.toString()
          };

          if (tipePembayaran == 'CASH') {
            Map<String, dynamic> valTempo = {'tempo_kredit': 0};
            Map<String, dynamic> valJatuhTempo = {'jatuh_tempo': '0'};

            combine = {
              ...combine,
              ...data,
              ...dataFileName,
              ...valTipePembayaran,
              ...valTipeFile,
              ...valExtFile,
              ...valIdUser,
              ...dataLatitude,
              ...datalongitude,
              ...valTempo,
              ...valJatuhTempo,
              ...dataDiskonToko,
              ...dataDiskonCash,
              ...dataTotal
            };
          } else {
            combine = {
              ...combine,
              ...data,
              ...dataFileName,
              ...valTipePembayaran,
              ...valTipeFile,
              ...valExtFile,
              ...valIdUser,
              ...dataLatitude,
              ...datalongitude,
              ...dataDiskonToko,
              ...dataDiskonCash,
              ...dataTotal
            };
          }
        }
        valueList.add(combine);
      }
      final jsonList = valueList.map((item) => jsonEncode(item)).toList();
      final uniqueJsonList = jsonList.toSet().toList();
      var result = uniqueJsonList.map((item) => jsonDecode(item)).toList();
      Map<String, dynamic> data2 = {};
      for (var value in result) {
        data2 = value;
      }
      final dio.FormData formData = dio.FormData();

      data2.forEach((k, v) async {
        formData.fields.add(MapEntry(k, v.toString()));
      });
      formData.files.add(MapEntry(
          'file_po',
          await dio.MultipartFile.fromFile(image!.path,
              filename: '$fileName')));

      // await form.sendDataWithOrder(formData);
      List<dynamic> dataOrder2 = [];
      Map combineOrder = {};
      Map newCombineOrdr = {};
      for (var j = 0; j < dataOrder.length; j++) {
        if (dataOrder[j]['label'] == 'List Order') {
          for (var k = 0; k < dataOrder[j]['value'].length; k++) {
            combineOrder['produk_id'] = dataOrder[j]['value'][k]['id_pdk'];
            combineOrder['total_pdk_keluar'] =
                dataOrder[j]['value'][k]['jml_order'];
            
            newCombineOrdr = {...newCombineOrdr, ...combineOrder};
            dataOrder2.add(newCombineOrdr);
          }

          // combineOrder['produk_id'] = dataOrder[j]['value'];
          // combineOrder['qty'] = dataOrder[j]['value'][7];
          // dataOrder2.add(combineOrder);

        }
      }
      // Map<String, dynamic> valOrder = {'order': dataOrder2};
      Map<String, dynamic> body = {};
      return await form.sendDataWithOrder(formData).then((value) {
        if (value != null) {
          debugPrint('value res $value');
          body['order'] = dataOrder2;
          body['distributor_id'] = value['data']['distributor_id'];
          body['preorder_id'] = value['data']['preorder_id'];
          body['ref'] = value['data']['sales'];
          body['customer_id'] = value['data']['customer_id'];
          form.sendOrder(body);
        }
      });
    } else {
      Map combine = {};
      for (var i = 0; i < fields.length; i++) {
        for (var j = 0; j < records.length; j++) {
          if (records[j]['label'] == 'Tanggal') {
            var inputFormat = DateFormat('dd-MM-yyyy');
            var inputDate = inputFormat.parse(records[j]['value']);
            var outputFormat = DateFormat('yyyy-MM-dd');
            var valDate = outputFormat.format(inputDate);
            data[fields[j]] = valDate;
          } else if (records[j]['label'] == 'Jam') {
            var periode = records[j]['value'].split(' ');
            data[fields[j]] = periode.first.toString();
            data['periode'] = periode.last.toString();
          } else {
            data[fields[j]] = records[j]['value'];
            // debugPrint('records ${fields[i]['wilay']}');
            // if (records[j]['label'] == 'Wilayah Sales') {
            //   wilayahSales = records[j]['value'];
            // }
          }
          Map<String, dynamic> valWilayasSales = {'wilayah_sales': 'DKI JAKARTA'};
          Map<String, dynamic> valTipeFile = {'tipe_file': typeFile};
          Map<String, dynamic> valExtFile = {'ext_file': extFile};
          Map<String, dynamic> valTipePembayaran = {
            'tipe_pembayaran': tipePembayaran
          };
          final prefs = await SharedPreferences.getInstance();
          Map<String, dynamic> valIdUser = {
            'id_user': prefs.getString('id_user')
          };
          Map<String, dynamic> dataFileName = {
            'file_name': fileName.toString()
          };
          Map<String, dynamic> dataLatitude = {'latitude': latitude.toString()};
          Map<String, dynamic> datalongitude = {
            'longitude': longitude.toString()
          };
          Map<String, dynamic> dataDiskon = {'diskon': diskonToko.toString()};
          Map<String, dynamic> dataTotal = {
            'total_tagihan': totalProduk.toString()
          };
          if (tipePembayaran == 'CASH') {
            Map<String, dynamic> valTempo = {'tempo': '0'};
            Map<String, dynamic> valJatuhTempo = {'jatuh_tempo': ''};
            combine = {
              ...combine,
              ...data,
              ...dataFileName,
              ...valTipePembayaran,
              ...valTipeFile,
              ...valExtFile,
              ...valIdUser,
              ...dataLatitude,
              ...datalongitude,
              ...valWilayasSales,
              ...valTempo,
              ...valJatuhTempo,
              ...dataDiskon,
              ...dataTotal
            };
          } else {
            combine = {
              ...combine,
              ...data,
              ...dataFileName,
              ...valTipePembayaran,
              ...valTipeFile,
              ...valExtFile,
              ...valIdUser,
              ...dataLatitude,
              ...datalongitude,
              ...valWilayasSales,
              ...dataDiskon,
              ...dataTotal
            };
          }
        }
        valueList.add(combine);
      }
      final jsonList = valueList.map((item) => jsonEncode(item)).toList();
      final uniqueJsonList = jsonList.toSet().toList();
      var result = uniqueJsonList.map((item) => jsonDecode(item)).toList();
      Map<String, dynamic> data2 = {};
      for (var value in result) {
        data2 = value;
      }
      final dio.FormData formData = dio.FormData();

      data2.forEach((k, v) async {
        formData.fields.add(MapEntry(k, v.toString()));
      });
      formData.files.add(MapEntry(
          'gambar',
          await dio.MultipartFile.fromFile(image!.path,
              filename: '$fileName')));
      List<dynamic> dataOrder2 = [];

      for (var j = 0; j < dataOrder.length; j++) {
        if (dataOrder[j]['label'] == 'List Order') {
          for (var k = 0; k < dataOrder[j]['value'].length; k++) {
            dataOrder2.add(dataOrder[j]['value'][k]);
          }
        }
      }
      // debugPrint('wilaya sales ${valWilayasSales.toString()}');

      await form.sendDataWithOrder(formData).then((value) {
        if (value != null) {
          Map<String, dynamic> body = {};
          body['data_order'] = dataOrder2;
          body['kode_po'] = value['kode_po'];
          body['wilayah_sales'] = 'DKI JAKARTA';
          form.sendOrder(body);
        }
      });
    }
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
          title: 'List Form',
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
                  FocusScope.of(context).requestFocus(FocusNode());
                  submit();
                },
                child: const Text(
                  'Submit',
                ),
              ),
            )),
        body: SafeArea(
          child: Container(
            color: const Color(0xFFF9F9F9),
            height: double.infinity,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: ScrollConfiguration(
                  behavior: const ScrollBehavior(),
                  child: ListView.builder(
                      itemCount: recordsDisplay.length,
                      itemBuilder: (BuildContext context, int i) {
                        return recordsDisplay[i]['label'] != 'List Order'
                            ? Column(
                                children: [
                                  recordsDisplay[i]['label'] == 'ID' ||
                                          recordsDisplay[i]['label'] == 'Dis ID'
                                      ? Container()
                                      : ListTile(
                                          dense: true,
                                          title: Visibility(
                                              visible: recordsDisplay[i]
                                                          ['label'] ==
                                                      'File Name'
                                                  ? false
                                                  : true,
                                              child: Text(
                                                '${recordsDisplay[i]['label']}',
                                                style:
                                                    textStyleFormTitle(context),
                                              )),
                                          subtitle: Padding(
                                            padding:
                                                const EdgeInsets.only(top: 5.0),
                                            child: Visibility(
                                                visible: recordsDisplay[i]
                                                            ['label'] ==
                                                        'File Name'
                                                    ? false
                                                    : true,
                                                child:
                                                    recordsDisplay[i]
                                                                ['label'] ==
                                                            'File'
                                                        ? typeFile == 'image'
                                                            ? SizedBox(
                                                                height: 290.h,
                                                                child:
                                                                    Image.file(
                                                                  image!,
                                                                  fit: BoxFit
                                                                      .fill,
                                                                ),
                                                              )
                                                            : Center(
                                                                child: extFile ==
                                                                        'pdf'
                                                                    ? Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        children: [
                                                                          Image
                                                                              .asset(
                                                                            'assets/img/file/pdf.png',
                                                                            width:
                                                                                45.w,
                                                                            height:
                                                                                50.h,
                                                                          ),
                                                                          Padding(
                                                                            padding:
                                                                                EdgeInsets.only(top: 5.sp),
                                                                          ),
                                                                          Text(
                                                                              '$fileName',
                                                                              maxLines: 2,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              style: textStyleCustom(context, Colors.black, 10.sp, FontWeight.normal)),
                                                                        ],
                                                                      )
                                                                    : extFile ==
                                                                            'docx'
                                                                        ? Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.center,
                                                                            children: [
                                                                              Image.asset(
                                                                                'assets/img/file/word.png',
                                                                                width: 45.w,
                                                                                height: 50.h,
                                                                              ),
                                                                              Padding(
                                                                                padding: EdgeInsets.only(top: 5.sp),
                                                                              ),
                                                                              Text('$fileName', maxLines: 2, overflow: TextOverflow.ellipsis, style: textStyleCustom(context, Colors.black, 10.sp, FontWeight.normal)),
                                                                            ],
                                                                          )
                                                                        : extFile ==
                                                                                'pptx'
                                                                            ? Column(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                children: [
                                                                                  Image.asset(
                                                                                    'assets/img/file/excel.png',
                                                                                    width: 45.w,
                                                                                    height: 50.h,
                                                                                  ),
                                                                                  Padding(
                                                                                    padding: EdgeInsets.only(top: 5.sp),
                                                                                  ),
                                                                                  Text('$fileName', maxLines: 2, overflow: TextOverflow.ellipsis, style: textStyleCustom(context, Colors.black, 10.sp, FontWeight.normal)),
                                                                                ],
                                                                              )
                                                                            : extFile == 'txt'
                                                                                ? Column(
                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                                    children: [
                                                                                      Image.asset(
                                                                                        'assets/img/file/book.png',
                                                                                        width: 45.w,
                                                                                        height: 50.h,
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: EdgeInsets.only(top: 5.sp),
                                                                                      ),
                                                                                      Text('$fileName', maxLines: 2, overflow: TextOverflow.ellipsis, style: textStyleCustom(context, Colors.black, 10.sp, FontWeight.normal)),
                                                                                    ],
                                                                                  )
                                                                                : Column(
                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                                    children: [
                                                                                      Text('Tidak ada file/gambar', maxLines: 2, overflow: TextOverflow.ellipsis, style: textStyleCustom(context, Colors.black, 10.sp, FontWeight.normal)),
                                                                                    ],
                                                                                  ),
                                                              )
                                                        : Text(
                                                            recordsDisplay[i][
                                                                        'label'] ==
                                                                    'Tempo'
                                                                ? '${recordsDisplay[i]['value']} hari'
                                                                : '${recordsDisplay[i]['value']}',
                                                            style:
                                                                textStyleFormTitle(
                                                                    context),
                                                          )),
                                          ),
                                        ),
                                  recordsDisplay[i]['label'] == 'ID' ||
                                          recordsDisplay[i]['label'] == 'Dis ID'
                                      ? Container()
                                      : const Divider(
                                          color: Colors.blue,
                                        ),
                                ],
                              )
                            : Column(
                                children: [
                                  ListTile(
                                    title: Text(
                                        '${recordsDisplay[i]['label']}:',
                                        style: textStyleCustom(
                                            context,
                                            Colors.black,
                                            12.sp,
                                            FontWeight.bold)),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.only(top: 5.0),
                                      child: Column(
                                          children: List.generate(
                                              recordsDisplay[i]['value'].length,
                                              (index) {
                                        return Column(
                                          children: [
                                            ListTile(
                                              dense: true,
                                              title: Text(
                                                'Produk',
                                                style:
                                                    textStyleFormTitle(context),
                                              ),
                                              subtitle: Text(
                                                '${recordsDisplay[i]['value'][index]['produk']}',
                                                style:
                                                    textStyleFormTitle(context),
                                              ),
                                            ),
                                            ListTile(
                                              dense: true,
                                              title: Text(
                                                'Harga Jual',
                                                style:
                                                    textStyleFormTitle(context),
                                              ),
                                              subtitle: MoneyFormatter(
                                                colorVal: Colors.black,
                                                money:
                                                    '${recordsDisplay[i]['value'][index]['harga_jual']}',
                                                typeStyle: '',
                                              ),
                                            ),
                                            ListTile(
                                              dense: true,
                                              title: Text(
                                                'Jumlah Order',
                                                style:
                                                    textStyleFormTitle(context),
                                              ),
                                              subtitle: Text(
                                                '${recordsDisplay[i]['value'][index]['jml_order']}',
                                                style:
                                                    textStyleFormTitle(context),
                                              ),
                                            ),
                                            ListTile(
                                              dense: true,
                                              title: Text(
                                                'Harga Sebelum Diskon',
                                                style:
                                                    textStyleFormTitle(context),
                                              ),
                                              subtitle: MoneyFormatter(
                                                colorVal: Colors.black,
                                                money:
                                                    '${recordsDisplay[i]['value'][index]['harga_sebelum_diskon']}',
                                                typeStyle: '',
                                              ),
                                            ),
                                            ListTile(
                                              dense: true,
                                              title: Text(
                                                'Diskon Toko',
                                                style:
                                                    textStyleFormTitle(context),
                                              ),
                                              subtitle: Text(
                                                '${recordsDisplay[i]['value'][index]['diskon_toko']}%',
                                                style:
                                                    textStyleFormTitle(context),
                                              ),
                                            ),
                                            ListTile(
                                              dense: true,
                                              title: Text(
                                                'Diskon CASH',
                                                style:
                                                    textStyleFormTitle(context),
                                              ),
                                              subtitle: Text(
                                                '${recordsDisplay[i]['value'][index]['diskon_cash']}%',
                                                style:
                                                    textStyleFormTitle(context),
                                              ),
                                            ),
                                            ListTile(
                                              dense: true,
                                              title: Text(
                                                'Harga Setelah Diskon',
                                                style:
                                                    textStyleFormTitle(context),
                                              ),
                                              subtitle: MoneyFormatter(
                                                colorVal: Colors.black,
                                                money:
                                                    '${recordsDisplay[i]['value'][index]['harga_setelah_diskon']}',
                                                typeStyle: '',
                                              ),
                                            ),
                                            const Divider(
                                              color: Colors.blue,
                                            ),
                                          ],
                                        );
                                      })),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 18.0, right: 18.0, top: 10.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Total List Orderan',
                                            style: textStyleCustomLato(
                                                context,
                                                Colors.black,
                                                14.sp,
                                                FontWeight.normal),
                                          ),
                                        ),
                                        Expanded(
                                          child: MoneyFormatter(
                                            colorVal: Colors.black,
                                            money: '$totalProduk',
                                            typeStyle: '',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                ],
                              );
                      })),
            ),
          ),
        ),
      ),
    );
  }
}
