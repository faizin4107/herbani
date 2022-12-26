import 'dart:convert';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:herbani/controller/form.dart';
import 'package:herbani/helper/function.dart';
import 'package:herbani/helper/textstyle_custom.dart';
import 'package:herbani/util/constant.dart';
import 'package:herbani/widget/appbar/appbar_default.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FormSubmit extends StatefulWidget {
  const FormSubmit({Key? key}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _FormSubmitState createState() => _FormSubmitState();
}

class _FormSubmitState extends State<FormSubmit> {
  final FormController form = Get.put(FormController());
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  dio.CancelToken token = dio.CancelToken();
  List<dynamic> records = [];
  List<dynamic> fields = [];
  // File? image;
  // ignore: prefer_typing_uninitialized_variables
  // var typeFile;
  // ignore: prefer_typing_uninitialized_variables
  // var extFile;
  // ignore: prefer_typing_uninitialized_variables
  // var fileName;
  // ignore: prefer_typing_uninitialized_variables
  var latitude;
  // ignore: prefer_typing_uninitialized_variables
  var longitude;
  @override
  void initState() {
    setState(() {
      records = Get.arguments['records'];
      fields = Get.arguments['fields'];
      latitude = Get.arguments['latitude'];
      longitude = Get.arguments['longitude'];
    });
    super.initState();
  }

  List<dynamic> valueList = [];
  Future<dynamic> submit() async {
    EasyLoading.show(status: 'memuat...');
    form.setIsTouch(true);
    valueList.clear();
    Map<String, dynamic> data = {};
    Map combine = {};
    final prefs = await SharedPreferences.getInstance();
    final String? area = prefs.getString('area');
    if (area != null) {
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
          } else if (records[j]['label'] == 'ID') {
            data['customer_id'] = records[j]['value'];
          } else if (records[j]['label'] == 'Dis ID') {
            data['distributor_id'] = records[j]['value'];
          } else if (records[j]['label'] == 'Keterangan') {
            data['ket'] = records[j]['value'];
          } else {
            data[fields[j]] = records[j]['value'];
          }

          Map<String, dynamic> dataLatitude = {'latitude': latitude.toString()};
          Map<String, dynamic> datalongitude = {'longitude': longitude.toString()};
          final prefs = await SharedPreferences.getInstance();
          Map<String, dynamic> valIdUser = {'user_id': prefs.getString('id')};
          combine = {
            ...combine,
            ...data,
            ...valIdUser,
            ...dataLatitude,
            ...datalongitude
          };
        }
        valueList.add(combine);
      }
    } else {
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
          }
          Map<String, dynamic> valWilayahSales = {'wilayah_sales': 'DKI JAKARTA'};

          Map<String, dynamic> dataLatitude = {'latitude': latitude.toString()};
          Map<String, dynamic> datalongitude = {'longitude': longitude.toString()};
          final prefs = await SharedPreferences.getInstance();
          Map<String, dynamic> valIdUser = {
            'id_user': prefs.getString('id_user')
          };
          combine = {
            ...combine,
            ...data,
            ...valIdUser,
            ...dataLatitude,
            ...datalongitude,
            ...valWilayahSales
          };
        }
        valueList.add(combine);
      }
    }

    final jsonList = valueList.map((item) => jsonEncode(item)).toList();
    final uniqueJsonList = jsonList.toSet().toList();
    var result = uniqueJsonList.map((item) => jsonDecode(item)).toList();

    Map<String, dynamic> data2 = {};
    for (var value in result) {
      data2 = value;
    }
    // dio.ListFormat.multi = [];
    final dio.FormData formData = dio.FormData();

    data2.forEach((k, v) async {
      formData.fields.add(MapEntry(k, v.toString()));
    });
    // formData.files.add(MapEntry(
    //     'gambar', await dio.MultipartFile.fromFile(image!.path, filename: '')));
    if (area != null) {
      return await form.sendData('/kunjungan', formData);
    } else {
      return await form.sendData('/form/input_data_kunjungan.php', formData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // form.token.cancel();
        EasyLoading.dismiss();
        if (mounted) {
          setState(() {
            // form.setIsTouch(false);
          });
        }
        Get.back();
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        key: _scaffoldKey,
        appBar: const AppBarDefault(
          title: 'Keterangan Formulir',
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
                    await submit();
                    
                    // await requestPermissionLocation(context)
                    //     .then((permission) async {
                    //   if (permission == true) {
                    //     await checkMockLocation(context).then((mock) async {
                    //       // ignore: prefer_typing_uninitialized_variables
                    //         var lat;
                    //         // ignore: prefer_typing_uninitialized_variables
                    //         var lng;
                    //         await getLocation().then((location) {
                    //           if (location != null) {
                    //             lat = location['latitude'];
                    //             lng = location['longitude'];
                    //           }
                    //         });
                    //         if (lat != null || lat != '') {
                    //           if (lng != null || lng != '') {
                    //             submit();
                    //           } else {
                    //             EasyLoading.dismiss();
                    //             form.setIsTouch(false);
                    //             EasyLoading.showInfo(
                    //                 'Gagal mengambil lokasi, silahkan ulangi kembali');
                    //           }
                    //         } else {
                    //           EasyLoading.dismiss();
                    //           form.setIsTouch(false);
                    //           EasyLoading.showInfo(
                    //               'Gagal mengambil lokasi, silahkan ulangi kembali');
                    //         }
                    //     });
                    //   } else if (permission == 'location-denied-forever' ||
                    //       permission == 'location-denied') {
                    //     EasyLoading.dismiss();
                    //   }
                    // });
                  }
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
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: ScrollConfiguration(
                    behavior: const ScrollBehavior(),
                    child: ListView.builder(
                        itemCount: records.length,
                        itemBuilder: (BuildContext context, int i) {
                          return Column(
                            children: [
                              records[i]['label'] == 'File'
                                  ? Container()
                                  : ListTile(
                                      dense: true,
                                      title: Text(
                                        '${records[i]['label']}',
                                        style: textStyleFormTitle(context),
                                      ),
                                      subtitle: Text(
                                        '${records[i]['value']}',
                                        style: textStyleFormTitle(context),
                                      ),
                                    ),
                              records[i]['label'] == 'File'
                                  ? Container()
                                  : const Divider(
                                      color: Colors.blue,
                                    ),
                            ],
                          );
                        })),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
