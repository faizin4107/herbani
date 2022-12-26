import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:find_dropdown/find_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:herbani/controller/customer.dart';
import 'package:herbani/controller/detail_order.dart';
import 'package:herbani/controller/form.dart';
import 'package:herbani/helper/alert_custom.dart';
import 'package:herbani/helper/function.dart';
import 'package:herbani/helper/textstyle_custom.dart';
import 'package:herbani/util/constant.dart';
import 'package:herbani/widget/appbar/appbar_default.dart';
import 'package:herbani/widget/loading/loading_app.dart';
import 'package:herbani/widget/message/empty_state.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FormRetur extends StatefulWidget {
  const FormRetur({Key? key}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _FormReturState createState() => _FormReturState();
}

class _FormReturState extends State<FormRetur> {
  final FormController form = Get.put(FormController());
  final CustomerController customer = Get.put(CustomerController());
  final DetailOrderController detail = Get.put(DetailOrderController());
  final _formKey = GlobalKey<FormState>();
  final _dropdownKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController tanggalController = TextEditingController();
  TextEditingController jamController = TextEditingController();
  TextEditingController namaSalesController = TextEditingController();
  TextEditingController customer2Controller = TextEditingController();
  TextEditingController alamatController = TextEditingController();
  TextEditingController kelurahanController = TextEditingController();
  TextEditingController kecamatanController = TextEditingController();
  TextEditingController kotaController = TextEditingController();
  TextEditingController provinsiController = TextEditingController();
  TextEditingController noKontakController = TextEditingController();
  TextEditingController keteranganController = TextEditingController();
  TextEditingController keteranganPembelianController = TextEditingController();
  TextEditingController orderanController = TextEditingController();
  TextEditingController idPoController = TextEditingController();
  String idPembeli = '';
  String idDistributor = '';
  dio.CancelToken token = dio.CancelToken();

  @override
  void initState() {
    form.inputLokasi.value = '';

    super.initState();
  }

  String? ketPembelian;

  String? kota;

  Future getNameSales() async {}
  File? image;
  bool loadingGetFile = false;
  String? fileName;
  String? typeFile;
  String? extFile;
  String? ketFile;
  bool cst1NotEmpty = false;

  Map location = {};

  String? kodePo;

  String? lokasi;
  // ignore: prefer_typing_uninitialized_variables
  var _latitude;
  // ignore: prefer_typing_uninitialized_variables
  var _longitude;
  // List<dynamic> _trecordsest = [];
  List<dynamic> records = [];
  List<dynamic> fields = [];

  getSubmit() async {
    List<dynamic> dataRetur = [];
    Map bodyRetur = {};
    Map combineBodyRetur = {};

    for (var i = 0; i < detail.textEditingControllers.length; i++) {
      debugPrint('id test ${detail.textEditingControllers[i]}');
      bodyRetur['list_po_id'] = detail.textEditingControllersVal[i].text;
      bodyRetur['qty_awal'] = detail.qtyProduk[i];
      bodyRetur['jml_retur'] = detail.textEditingControllers[i].text == ''
          ? '0'
          : detail.textEditingControllers[i].text;

      combineBodyRetur = {...combineBodyRetur, ...bodyRetur};
      dataRetur.add(combineBodyRetur);
    }
    debugPrint('test ${detail.listRecords}');
    debugPrint('dataRetur ${dataRetur}');
    for (var i = 0; i < detail.listRecords.length; i++) {
      for (var j = 0; j < dataRetur.length; j++) {
        if (detail.listRecords[i]['id'] ==
            int.parse(dataRetur[j]['list_po_id'])) {
              // debugPrint('test 1 ${int.parse(detail.listRecords[i]['qty'])}');
          if (int.parse(dataRetur[j]['jml_retur']) >
              detail.listRecords[i]['qty']) {
            return orangeDialog(
                context,
                'Jumlah retur melebihi jumlah order produk ${detail.listRecords[i]['produk']['produk']} yang telah dipesan!',
                AlertType.info);
          }
        }
      }
    }
    dataRetur.removeWhere((element) => element['jml_retur'] == '0');
    debugPrint('statement data retur $dataRetur');

    final prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> body = {
      'preorder_id': idPoController.text,
      'user_id': prefs.getString('id'),
      'distributor_id': prefs.getString('distributor_id'),
      'catatan':
          keteranganController.text == '' ? '' : keteranganController.text
    };
    debugPrint('statement body $body');

    if (dataRetur.isEmpty) {
      // ignore: use_build_context_synchronously
      return orangeDialog(
          context, 'Tidak ada retur yang diajukan!', AlertType.info);
    }

    // ignore: use_build_context_synchronously
    await form.checkReturExist(context, idPoController.text);
    if (form.returExist.value) {
      form.setIsTouch(false);
      EasyLoading.dismiss();
      // ignore: use_build_context_synchronously
      return orangeDialog(
          context,
          'Anda sudah mengajukan retur untuk data preorder $kodePo, sekarang status retur masih dalam proses oleh admin, silahkan tunggu!',
          AlertType.info);
    } else {
      await form.sendDataRetur(body).then((value) {
        debugPrint('statement value $value');
        if (value != null) {
          Map<String, dynamic> body = {};
          body['retur_id'] = value['data']['retur_id'];
          body['retur'] = dataRetur;
          form.sendReturList(body);
        }
      });
    }

    // Map<String, dynamic> myData = {};
    debugPrint('body ${form.returExist.value}');
  }

  bool errorCustomer = false;
  bool showListProduk = false;

  @override
  Widget build(BuildContext context) {
    debugPrint('${form.listCustomer}');
    return WillPopScope(
      onWillPop: () async {
        EasyLoading.dismiss();
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        key: _scaffoldKey,
        appBar: const AppBarDefault(
          title: 'Form',
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
                  // debugPrint('submit');
                  if (_formKey.currentState!.validate()) {
                    FocusScope.of(context).requestFocus(FocusNode());
                    // EasyLoading.show(status: 'Memuat');
                    await getSubmit();
                    // debugPrint('$ketPembelian');
                  }
                },
                child: const Text(
                  'Kirim',
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
                                'Daftar Preorder',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: textStyleFormTitle(context),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    DropdownFormField<Map<String, dynamic>>(
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
                                      ),
                                      validator: (dynamic val) {
                                        if (val == null) {
                                          debugPrint('csa validator 1 $val');
                                          // setState(() {
                                          // errorCustomer = true;
                                          // });
                                          form.setErrorCustomer(true);
                                          return "Nama customer wajib dipilih";
                                        } else {
                                          form.setErrorCustomer(false);
                                        }
                                        return null;
                                        // debugPrint('csa validator $val');
                                        // return null;
                                      },
                                      onSaved: (dynamic str) async {
                                        if (str != '') {
                                          setState(() {
                                            idPoController.text = str['id'];
                                          });
                                          // Get.put(DetailOrderController()).getListOrderNonDki(idPoController.text);
                                        }
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                      },

                                      onChanged: (dynamic str) async {
                                        if (str != '') {
                                          setState(() {
                                            idPoController.text = str['id'];
                                            kodePo = str['kode'];
                                            form.setErrorCustomer(false);
                                            showListProduk = true;
                                          });

                                          Get.put(DetailOrderController())
                                              .getListOrderNonDki(
                                                  idPoController.text);
                                        }
                                      },

                                      displayItemFn: (dynamic item) {
                                        return Text(
                                          (item ?? {})['nama_pembeli'] ?? '',
                                          style: textStyleFormInput(context),
                                        );
                                      },

                                      findFn: (dynamic str) async =>
                                          form.listPreorder,
                                      selectedFn:
                                          (dynamic item1, dynamic item2) {
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
                                        subtitle: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 3.h,
                                            ),
                                            Text(
                                              'Kode PO: ${item['kode']}',
                                              style:
                                                  textStyleFormInput(context),
                                            ),
                                            SizedBox(
                                              height: 3.h,
                                            ),
                                            Text(
                                              'Tanggal Preorder: ${item['tgl_po']}',
                                              style:
                                                  textStyleFormInput(context),
                                            ),
                                            SizedBox(
                                              height: 3.h,
                                            ),
                                            Text(
                                              'Alamat: ${item['alamat']}',
                                              style:
                                                  textStyleFormInput(context),
                                            ),
                                            SizedBox(
                                              height: 3.h,
                                            ),
                                          ],
                                        ),
                                        tileColor: focused
                                            ? const Color.fromARGB(20, 0, 0, 0)
                                            : Colors.transparent,
                                        onTap: onTap,
                                      ),
                                    ),
                                    form.errorCustomer.value
                                        ? const Text(
                                            'Silahkan pilih distributor')
                                        : const Text(''),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            showListProduk
                                ? detail.obx(
                                    (state) {
                                      return SizedBox(
                                        height:
                                            detail.listRecords.length * 110.h,
                                        child: ListView.separated(
                                            separatorBuilder:
                                                (BuildContext context,
                                                        int index) =>
                                                    const Divider(
                                                      color: Colors.blue,
                                                      endIndent: 16.0,
                                                      indent: 16.0,
                                                    ),
                                            itemCount:
                                                detail.listRecords.length,
                                            itemBuilder:
                                                (BuildContext context, int i) {
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10.0),
                                                child: ListTile(
                                                  title: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        detail.listRecords[i]
                                                                ['produk']
                                                            ['produk'],
                                                        style: textStyleCustom(
                                                            context,
                                                            Colors.black,
                                                            12.sp,
                                                            FontWeight.bold),
                                                      ),
                                                      SizedBox(
                                                        height: 5.h,
                                                      ),
                                                      Text(
                                                        'Jumlah order produk: ${detail.listRecords[i]['qty']}',
                                                        style:
                                                            textStyleFormTitle(
                                                                context),
                                                      ),
                                                      SizedBox(
                                                        height: 5.h,
                                                      ),
                                                    ],
                                                  ),
                                                  subtitle: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      top: 5.0,
                                                    ),
                                                    child: TextFormField(
                                                        controller: detail
                                                                .textEditingControllers[
                                                            i],
                                                        // enableSuggestions: false,
                                                        style:
                                                            textStyleFormTitle(
                                                                context),
                                                        decoration:
                                                            InputDecoration(
                                                          filled: true,
                                                          fillColor:
                                                              Colors.white,
                                                          border:
                                                              InputBorder.none,
                                                          focusedBorder: OutlineInputBorder(
                                                              borderSide:
                                                                  const BorderSide(
                                                                      color: Color(
                                                                          0xFF979797),
                                                                      width:
                                                                          0.5),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5.0)),
                                                          enabledBorder: OutlineInputBorder(
                                                              borderSide:
                                                                  const BorderSide(
                                                                      color: Color(
                                                                          0xFF979797),
                                                                      width:
                                                                          0.5),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5.0)),
                                                          errorBorder: OutlineInputBorder(
                                                              borderSide:
                                                                  const BorderSide(
                                                                      color: Color(
                                                                          0xFF979797),
                                                                      width:
                                                                          0.5),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5.0)),
                                                          contentPadding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 10.0,
                                                                  top: 10.0),
                                                          hintText:
                                                              'Masukkan jumlah retur',
                                                          hintStyle:
                                                              textStyleFormInput(
                                                                  context),
                                                          errorStyle:
                                                              textStyleFormError(
                                                                  context),
                                                        ),
                                                        // validator: (value) {
                                                        //   if (detail
                                                        //           .textEditingControllers[
                                                        //               i]
                                                        //           .text ==
                                                        //       '') {
                                                        //     if (value == null ||
                                                        //         value.isEmpty) {
                                                        //       return 'Jumlah wajib diisi';
                                                        //     }
                                                        //   }

                                                        //   return null;
                                                        // },
                                                        keyboardType:
                                                            TextInputType.number
                                                        // onFieldSubmitted: (val) {
                                                        //   FocusManager
                                                        //       .instance.primaryFocus
                                                        //       ?.unfocus();
                                                        // }
                                                        ),
                                                  ),
                                                ),
                                              );
                                            }),
                                      );
                                    },
                                    onLoading: const LoadingApp(
                                      topPaddingLoading: 40,
                                    ),
                                    onError: (error) {
                                      return Obx(
                                        () => SizedBox(
                                          height: 80.h,
                                          child: Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                FailedRequest(
                                                  message: error.toString(),
                                                ),
                                                GestureDetector(
                                                  onTap: () async {
                                                    detail.getListOrderNonDki(
                                                        idPoController.text);
                                                  },
                                                  child: const Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 5.0),
                                                      child: Icon(Icons
                                                          .refresh_outlined)),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    onEmpty: Obx(
                                      () {
                                        return SizedBox(
                                          height: 80.h,
                                          child: Center(
                                            child: DataNotFound(
                                              message: detail.messageEmpty.value
                                                  .toString(),
                                            ),
                                          ),
                                        );
                                      },
                                    ))
                                : Container(),
                            SizedBox(
                              height: 10.h,
                            ),
                            ListTile(
                              title: Text(
                                'Catatan',
                                style: textStyleFormTitle(context),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(
                                  top: 5.0,
                                ),
                                child: TextFormField(
                                    controller: keteranganController,
                                    // enableSuggestions: false,
                                    onFieldSubmitted: (value) {
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                    },
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
                                          left: 10.0, top: 10.0),
                                      hintText: 'Masukkan Keterangan',
                                      hintStyle: textStyleFormInput(context),
                                      errorStyle: textStyleFormError(context),
                                    ),
                                    maxLines: 5,
                                    keyboardType: TextInputType.text),
                              ),
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
