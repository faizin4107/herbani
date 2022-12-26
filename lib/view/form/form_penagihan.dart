import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter_multi_formatter/formatters/money_input_formatter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:herbani/controller/form.dart';
import 'package:herbani/helper/alert_custom.dart';
import 'package:herbani/helper/function.dart';
import 'package:herbani/helper/textstyle_custom.dart';
import 'package:herbani/util/constant.dart';
import 'package:herbani/widget/appbar/appbar_default.dart';
import 'package:herbani/widget/loading/loading_app.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FormPenagihan extends StatefulWidget {
  const FormPenagihan({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _FormPenagihanState createState() => _FormPenagihanState();
}

class _FormPenagihanState extends State<FormPenagihan> {
  final FormController form = Get.put(FormController());
  String? idCustomer;
  TextEditingController tagihanController = TextEditingController();
  TextEditingController nominalController = TextEditingController();
  TextEditingController keteranganController = TextEditingController();
  final formKeyInputan = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  dio.CancelToken token = dio.CancelToken();
  // String? lokasi;
  // ignore: prefer_typing_uninitialized_variables
  var idPo;
  // ignore: prefer_typing_uninitialized_variables
  var tagihan;
  // ignore: prefer_typing_uninitialized_variables
  var idUser;
  // ignore: prefer_typing_uninitialized_variables
  var status;
  int totalTagihan = 0;

  // ignore: prefer_typing_uninitialized_variables
  var _latitude;
  // ignore: prefer_typing_uninitialized_variables
  var _longitude;
  // ignore: prefer_typing_uninitialized_variables
  var _address;

  File? image;
  bool loadingGetFile = false;
  String? fileName;
  String? typeFile;
  String? extFile;
  String? ketFile;
  bool cst1NotEmpty = false;

  Future getImage(type) async {
    setState(() {
      loadingGetFile = true;
      fileName = null;
      image = null;
      typeFile = null;
      extFile = null;
    });

    getImagePicture(type).then((img) {
      if (img.length == 0) {
        if (image != null) {
          setState(() {
            loadingGetFile = false;
            fileName = null;
            image = null;
            typeFile = null;
            extFile = null;
          });
        } else {
          setState(() {
            loadingGetFile = false;
            fileName = null;
            image = null;
            typeFile = null;
            extFile = null;
          });
        }
      } else {
        setState(() {
          fileName = img['fileName'];
          image = img['file'];
          typeFile = 'image';
          extFile = img['ext_file'];
          loadingGetFile = false;
        });
      }
    });
  }

  Future<dynamic> submit(address, lat, lng) async {
    final dio.FormData formData = dio.FormData();
    final prefs = await SharedPreferences.getInstance();
    formData.fields.add(MapEntry('id_pembeli', idCustomer.toString()));
    formData.fields
        .add(MapEntry('id_kolektor', prefs.getString('id_user').toString()));
    formData.fields.add(MapEntry('file', fileName.toString()));
    formData.fields.add(MapEntry('total_tagihan', numTotalTagihan.toString()));
    formData.fields.add(MapEntry('nominal_tagihan', nominal.toString()));
    formData.fields.add(MapEntry('alamat', address.toString()));
    formData.fields.add(MapEntry('lat', lat.toString()));
    formData.fields.add(MapEntry('lon', lng.toString()));
    formData.fields
        .add(MapEntry('keterangan', keteranganController.text.toString()));
    formData.files.add(MapEntry('image',
        await dio.MultipartFile.fromFile(image!.path, filename: fileName)));
    debugPrint('file ${formData.fields}');
    debugPrint('file ${formData.files}');
    await form.konfirmasiPenagihan(formData);
  }

  bool showKeterangan = false;
  bool clearText = false;
  String? nominal;

  int newTotalTagihan = 0;
  final _dropdownKey = GlobalKey<FormState>();

  // ignore: prefer_typing_uninitialized_variables
  var totalTagihanOld;
  int numTotalTagihan = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        form.token.cancel();
        EasyLoading.dismiss();
        if (mounted) {
          setState(() {
            form.setIsTouch(false);
          });
        }
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        key: _scaffoldKey,
        appBar: const AppBarDefault(
          title: 'Form Konfirmasi Penagihan',
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
                  if (formKeyInputan.currentState!.validate()) {
                    FocusScope.of(context).requestFocus(FocusNode());
                    if (image == null) {
                      return orangeDialog(
                          context,
                          'Mohon tambahkan foto terlebih dahulu',
                          AlertType.info);
                    }
                    debugPrint('total1 $newTotalTagihan');
                    debugPrint('total2 $numTotalTagihan');
                    if (newTotalTagihan > numTotalTagihan) {
                      return orangeDialog(
                          context,
                          'Jumlah nominal penagihan lebih besar dari jumlah total tagihan!',
                          AlertType.info);
                    }
                    EasyLoading.show(status: 'Memuat');
                    await requestPermissionLocation(context)
                        .then((permission) async {
                      if (permission == true) {
                        // // ignore: prefer_typing_uninitialized_variables
                        //     var address;
                        //     // ignore: prefer_typing_uninitialized_variables
                        //     var lat;
                        //     // ignore: prefer_typing_uninitialized_variables
                        //     var lng;
                            if(_latitude == null || _longitude == null){
                              await getLocation().then((loc) {
                                if (loc != null) {
                                  _address = loc['address'];
                                  _latitude = loc['latitude'];
                                  _longitude = loc['longitude'];
                                }
                              });
                            }

                            submit(_address, _latitude, _longitude);
                      } else if (permission == 'location-denied-forever' ||
                          permission == 'location-denied') {
                        EasyLoading.dismiss();
                      }
                    });
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
              key: formKeyInputan,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: ScrollConfiguration(
                  behavior: const ScrollBehavior(),
                  child: ListView(
                    shrinkWrap: true,
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
                            ListTile(
                              title: Text(
                                'Nama Customer',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: textStyleFormTitle(context),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: DropdownFormField<Map<String, dynamic>>(
                                  // controller: customer2Controller.,
                                  key: _dropdownKey,
                                  onEmptyActionPressed: () async {
                                    Get.put(FormController()).getCustomer();
                                  },
                                  emptyText: 'Tidak ada data',
                                  emptyActionText: 'reload',

                                  dropdownHeight: 200.h,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey)),
                                    suffixIcon: Icon(Icons.arrow_drop_down),
                                    // labelText: "Pilih Nama Customer"
                                  ),
                                  onSaved: (dynamic str) async {
                                    if (str != '') {
                                      setState(() {
                                        idCustomer = str['id_pembeli'];
                                        _address =
                                                str['alamat'].toString();
                                        _latitude =
                                                str['lat_cst'].toString();
                                        _longitude =
                                                str['lon_cst'].toString();
                                      });
                                    }
                                  },
                                  onChanged: (dynamic str) async {
                                    if (str != '') {
                                      setState(() {
                                        idCustomer = str['id_pembeli'];
                                        _address =
                                                str['alamat'].toString();
                                        _latitude =
                                                str['lat_cst'].toString();
                                        _longitude =
                                                str['lon_cst'].toString();
                                      });
                                    }
                                  },
                                  // validator: (dynamic str) {
                                  //   if (str == '' || str == null) {
                                  //     return 'Orderan wajib diisi';
                                  //   }
                                  //   return null;
                                  // },
                                  displayItemFn: (dynamic item) {
                                    return Text(
                                      (item ?? {})['nama_pembeli'] ?? '',
                                      style: textStyleFormInput(context),
                                    );
                                  },

                                  findFn: (dynamic str) async =>
                                      form.listCustomer,
                                  selectedFn: (dynamic item1, dynamic item2) {
                                    if (item1 != null && item2 != null) {
                                      return item1['nama_pembeli'] ==
                                          item2['nama_pembeli'];
                                    }

                                    return false;
                                  },
                                  filterFn: (dynamic item, str) =>
                                      item['nama_pembeli']
                                          .toLowerCase()
                                          .indexOf(str.toLowerCase()) >=
                                      0,
                                  dropdownItemFn: (dynamic item,
                                          int position,
                                          bool focused,
                                          bool selected,
                                          Function() onTap) =>
                                      ListTile(
                                    title: Text(item['nama_pembeli']),
                                    subtitle: Text(
                                      item['alamat'] ?? '',
                                      style: textStyleFormInput(context),
                                    ),
                                    tileColor: focused
                                        ? const Color.fromARGB(20, 0, 0, 0)
                                        : Colors.transparent,
                                    onTap: onTap,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            ListTile(
                              title: Text(
                                'Total Tagihan',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: textStyleFormTitle(context),
                              ),
                              subtitle: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 2.0, right: 2.0, top: 10.0),
                                  child: TextFormField(
                                    controller: tagihanController,
                                    style: textStyleFormTitle(context),
                                    decoration: InputDecoration(
                                      hintText: 'Masukkan Total Tagihan',
                                      hintStyle: textStyleFormInput(context),
                                      contentPadding: const EdgeInsets.fromLTRB(
                                          20.0, 10.0, 20.0, 10.0),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        borderSide: const BorderSide(
                                            color: Color(0xFF00B6F1)),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        borderSide: const BorderSide(
                                            color: Color(0xFF00B6F1)),
                                      ),
                                    ),
                                    onChanged: (val) {
                                      setState(() {
                                        tagihanController.text = val;
                                        tagihanController.selection =
                                            TextSelection(
                                                baseOffset: val.length,
                                                extentOffset: val.length);
                                        String newVal1 =
                                            val.toString().replaceAll('Rp', '');
                                        String newVal2 = newVal1
                                            .toString()
                                            .replaceAll(',', '');
                                        totalTagihanOld =
                                            newVal2.toString().trim();
                                        numTotalTagihan = int.parse(newVal2);
                                      });
                                    },
                                    validator: (val) {
                                      if (val!.isEmpty) {
                                        return "Total tagihan harus diisi";
                                      }
                                      return null;
                                    },
                                    maxLines: 1,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      MoneyInputFormatter(
                                        leadingSymbol: 'Rp ',
                                        mantissaLength: 0,
                                      )
                                    ],
                                  )),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            ListTile(
                              title: Text(
                                'Nominal Penagihan',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: textStyleFormTitle(context),
                              ),
                              subtitle: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 2.0, right: 2.0, top: 10.0),
                                  child: TextFormField(
                                    controller: nominalController,
                                    style: textStyleFormTitle(context),
                                    decoration: InputDecoration(
                                      hintText: 'Masukkan Nominal',
                                      hintStyle: textStyleFormInput(context),
                                      contentPadding: const EdgeInsets.fromLTRB(
                                          20.0, 10.0, 20.0, 10.0),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        borderSide: const BorderSide(
                                            color: Color(0xFF00B6F1)),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        borderSide: const BorderSide(
                                            color: Color(0xFF00B6F1)),
                                      ),
                                    ),
                                    onChanged: (val) {
                                      nominalController.text = val;
                                      nominalController.selection =
                                          TextSelection(
                                              baseOffset: val.length,
                                              extentOffset: val.length);
                                      String newVal1 =
                                          val.toString().replaceAll('Rp', '');
                                      String newVal2 = newVal1
                                          .toString()
                                          .replaceAll(',', '');
                                      String newVal3 =
                                          newVal2.toString().trim();
                                      if (mounted) {
                                        setState(() {
                                          newTotalTagihan = int.parse(newVal3);
                                        });
                                      }

                                      if (newVal3.contains(
                                          totalTagihanOld.toString())) {
                                        if (mounted) {
                                          setState(() {
                                            showKeterangan = false;
                                            keteranganController.clear();
                                          });
                                        }
                                      } else {
                                        if (mounted) {
                                          setState(() {
                                            showKeterangan = true;
                                          });
                                        }
                                      }
                                      if (mounted) {
                                        setState(() {
                                          nominal = newVal3;
                                        });
                                      }
                                    },
                                    validator: (val) {
                                      if (val!.isEmpty) {
                                        return "Nominal penagihan harus diisi";
                                      }
                                      return null;
                                    },
                                    maxLines: 1,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      MoneyInputFormatter(
                                        leadingSymbol: 'Rp ',
                                        mantissaLength: 0,
                                      )
                                    ],
                                  )),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            showKeterangan
                                ? ListTile(
                                    title: Text(
                                      'Nominal Penagihan tidak sesuai dengan Total Tagihan, mohon masukkan keterangan',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        color: Colors.red[900],
                                        // fontFamily: ''
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                    subtitle: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 2.0, right: 2.0, top: 10.0),
                                        child: TextFormField(
                                          controller: keteranganController,
                                          style: textStyleFormTitle(context),
                                          decoration: InputDecoration(
                                            hintText: 'Masukkan Keterangan',
                                            hintStyle:
                                                textStyleFormInput(context),
                                            contentPadding:
                                                const EdgeInsets.fromLTRB(
                                                    10.0, 10.0, 20.0, 10.0),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                              borderSide: const BorderSide(
                                                  color: Color(0xFF00B6F1)),
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                              borderSide: const BorderSide(
                                                  color: Color(0xFF00B6F1)),
                                            ),
                                          ),
                                          validator: (val) {
                                            if (val!.isEmpty) {
                                              if (showKeterangan) {
                                                return "Keterangan harus diisi";
                                              }
                                            }

                                            return null;
                                          },
                                          maxLines: 6,
                                          keyboardType: TextInputType.text,
                                        )),
                                  )
                                : Container(),
                            SizedBox(
                              height: 5.h,
                            ),
                            Column(
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 16.0, right: 16.0, top: 8.0),
                                      child: SizedBox(
                                        height: 0.35.sh,
                                        width: 330.w,
                                        // decoration: BoxDecoration(
                                        //   borderRadius: BorderRadius.all(
                                        //     Radius.circular(10.0.r),
                                        //   ),
                                        //   border: Border.all(
                                        //     color: const Color(0xFF00B6F1),
                                        //     width: 2,
                                        //   ),
                                        // ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10.0.r),
                                          ),
                                          child: fileName == null
                                              ? Icon(
                                                  Icons.image,
                                                  size: 300.sp,
                                                  color: Colors.blueGrey,
                                                )
                                              : loadingGetFile
                                                  ? const LoadingApp(
                                                      topPaddingLoading: 0)
                                                  : typeFile == 'image' &&
                                                          fileName != null
                                                      ? Image.file(
                                                          image!,
                                                          fit: BoxFit.fill,
                                                        )
                                                      : ketFile ==
                                                              'not-supported'
                                                          ? Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                    'File tidak didukung',
                                                                    maxLines: 2,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style: textStyleCustom(
                                                                        context,
                                                                        Colors
                                                                            .black,
                                                                        10.sp,
                                                                        FontWeight
                                                                            .normal)),
                                                              ],
                                                            )
                                                          : Container(),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 13.0, right: 13.0, top: 15.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: InkWell(
                                            onTap: () async {
                                              await getImage('gallery');
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      3.0, 5.0, 3.0, 0),
                                              child: Container(
                                                  height: 35.5.h,
                                                  width: 82.5.w,
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 10),
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius
                                                                  .all(
                                                              Radius.circular(
                                                                  5)),
                                                      boxShadow: <BoxShadow>[
                                                        BoxShadow(
                                                            color: Colors
                                                                .grey.shade200,
                                                            offset:
                                                                const Offset(
                                                                    2, 2),
                                                            blurRadius: 1,
                                                            spreadRadius: 1)
                                                      ],
                                                      gradient:
                                                          const LinearGradient(
                                                              begin: Alignment
                                                                  .centerLeft,
                                                              end: Alignment
                                                                  .centerRight,
                                                              colors: [
                                                            Color.fromARGB(255,
                                                                108, 194, 43),
                                                            Color.fromARGB(255,
                                                                92, 206, 21),
                                                          ])),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      Text('Galeri',
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style:
                                                              textStyleCustom(
                                                                  context,
                                                                  Colors.white,
                                                                  12.sp,
                                                                  FontWeight
                                                                      .bold)),
                                                      Icon(
                                                        Icons.image,
                                                        color: Colors.white,
                                                        size: 15.sp,
                                                      ),
                                                    ],
                                                  )),
                                            )),
                                      ),
                                      Expanded(
                                        child: InkWell(
                                            onTap: () async {
                                              await getImage('camera');
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      3.0, 5.0, 3.0, 0),
                                              child: Container(
                                                  height: 35.5.h,
                                                  width: 82.5.w,
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 10),
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  5.r)),
                                                      boxShadow: <BoxShadow>[
                                                        BoxShadow(
                                                            color: Colors
                                                                .grey.shade200,
                                                            offset:
                                                                const Offset(
                                                                    2, 2),
                                                            blurRadius: 1,
                                                            spreadRadius: 1)
                                                      ],
                                                      gradient:
                                                          const LinearGradient(
                                                              begin: Alignment
                                                                  .centerLeft,
                                                              end: Alignment
                                                                  .centerRight,
                                                              colors: [
                                                            Color.fromARGB(255,
                                                                108, 194, 43),
                                                            Color.fromARGB(255,
                                                                92, 206, 21),
                                                          ])),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      Text('Kamera',
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style:
                                                              textStyleCustom(
                                                                  context,
                                                                  Colors.white,
                                                                  12.sp,
                                                                  FontWeight
                                                                      .bold)),
                                                      Icon(
                                                        Icons.camera_alt,
                                                        color: Colors.white,
                                                        size: 15.sp,
                                                      ),
                                                    ],
                                                  )),
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 12.h,
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                              ],
                            ),
                          ],
                        ),
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
