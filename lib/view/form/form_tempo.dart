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
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:styled_text/styled_text.dart';

class FormTempo extends StatefulWidget {
  const FormTempo({Key? key}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _FormTempoState createState() => _FormTempoState();
}

class _FormTempoState extends State<FormTempo> {
  final FormController form = Get.put(FormController());
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController hariController = TextEditingController();

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

                    for (var j = 0; j < records.length; j++) {
                      if (records[j]['label'] == 'Tempo') {
                        records.removeWhere(
                            (element) => element["label"] == 'Tempo');
                      }

                      if (records[j]['label'] == 'Jatuh Tempo') {
                        records.removeWhere(
                            (element) => element["label"] == 'Jatuh Tempo');
                      }
                    }

                    Map temp = {'label': 'Tempo', 'value': hariController.text};

                    // ignore: prefer_typing_uninitialized_variables
                    var tanggal;
                    for (var i = 0; i < records.length; i++) {
                      if (records[i]['label'] == 'Tanggal') {
                        tanggal = records[i]['value'];
                      }
                    }

                    var newTgl = Jiffy('$tanggal', 'dd-MM-yyyy')
                        .add(days: int.parse(hariController.text));
                    var inputFormat = DateFormat('M/d/yyyy');
                    var inputDate = inputFormat.parse(newTgl.yMd.toString());
                    var outputFormat = DateFormat('dd-MM-yyyy');
                    var valDate = outputFormat.format(inputDate);
                    Map jatuhTempo = {'label': 'Jatuh Tempo', 'value': valDate};
                    records.add(temp);
                    records.add(jatuhTempo);
                    fields.add('tempo');
                    fields.add('jatuh_tempo');
                    Get.toNamed('/form_diskon', arguments: {
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
                          ? 'Diskon Toko'
                          : 'Diskon CASH',
                      'latitude': latitude,
                      'longitude': longitude,
                    });
                  }

                  // print('data order $dataOrder');
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
                            'Tempo',
                            style: textStyleFormTitle(context),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: TextFormField(
                              controller: hariController,
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
                                hintText: 'Masukkan jumlah hari',
                                hintStyle: textStyleFormInput(context),
                                errorStyle: textStyleFormError(context),
                              ),
                              validator: (value) {
                                if (value == '') {
                                  return 'Jumlah hari wajib diisi';
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
