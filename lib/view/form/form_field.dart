import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:find_dropdown/find_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:herbani/controller/customer.dart';
import 'package:herbani/controller/form.dart';
import 'package:herbani/helper/function.dart';
import 'package:herbani/helper/textstyle_custom.dart';
import 'package:herbani/util/constant.dart';
import 'package:herbani/widget/appbar/appbar_default.dart';
import 'package:herbani/widget/loading/loading_app.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FormFieldList extends StatefulWidget {
  const FormFieldList({Key? key}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _FormFieldListState createState() => _FormFieldListState();
}

class _FormFieldListState extends State<FormFieldList> {
  final FormController form = Get.put(FormController());
  final CustomerController customer = Get.put(CustomerController());
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
  String idPembeli = '';
  String idDistributor = '';
  dio.CancelToken token = dio.CancelToken();
  @override
  void initState() {
    form.inputLokasi.value = '';

    super.initState();
  }

  List<String> dropwDownType = [
    'RETAIL',
    'GROSIR/AGEN',
    'HOREKA',
    'SEKOLAH',
    'KANTOR',
    'KESEHATAN',
    'RESELLER',
    'MT',
    'END USER'
  ];
  String? ketPembelian;
  void _handleKetPembelian(String value) {
    setState(() {
      ketPembelian = value;
    });
  }

  String? kota;

  Future getNameSales() async {}
  File? image;
  bool loadingGetFile = false;
  String? fileName;
  String? typeFile;
  String? extFile;
  String? ketFile;
  bool cst1NotEmpty = false;
  Future getFileDocument(context) async {
    setState(() {
      ketFile = null;
      loadingGetFile = true;
      fileName = null;
      image = null;
      typeFile = null;
      extFile = null;
    });

    checkPermissionStorage(context).then((permission) {
      if (permission) {
        getFile().then((value) {
          if (value.length == 0) {
            setState(() {
              ketFile = null;
              loadingGetFile = false;
              fileName = null;
              image = null;
              typeFile = null;
              extFile = null;
            });
          } else {
            if (value['type'] == 'file') {
              if (value['ext_file'] != 'pdf' &&
                  value['ext_file'] != 'docx' &&
                  value['ext_file'] != 'pptx' &&
                  value['ext_file'] != 'txt') {
                setState(() {
                  ketFile = 'not-supported';
                  fileName = null;
                  image = null;
                  typeFile = null;
                  extFile = null;
                  loadingGetFile = false;
                });
              } else {
                setState(() {
                  fileName = value['fileName'];
                  image = value['file'];
                  typeFile = 'file';
                  extFile = value['ext_file'];
                  loadingGetFile = false;
                });
              }
            } else {
              setState(() {
                fileName = value['fileName'];
                image = value['file'];
                typeFile = 'image';
                extFile = value['ext_file'];
                loadingGetFile = false;
              });
            }
          }
        });
      } else {
        setState(() {
          fileName = null;
          image = null;
          typeFile = null;
          extFile = null;
        });
      }
    });
  }

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

  Map location = {};

  String? lokasi;
  // ignore: prefer_typing_uninitialized_variables
  var _latitude;
  // ignore: prefer_typing_uninitialized_variables
  var _longitude;
  // List<dynamic> _trecordsest = [];
  List<dynamic> records = [];
  List<dynamic> fields = [];
  getSubmit() async {
    fields.clear();
    records.clear();
    List<String> dataLabel = [
      'Tanggal',
      'Jam',
      'Nama Sales',
      'ID',
      'Dis ID',
      'Customer',
      'Alamat',
      'Keterangan',
      'Keterangan Pembelian',
      'File',
    ];

    List<String> field = [
      'tanggal',
      'jam',
      'nama_sales',
      'id_pembeli',
      'id_distributor',
      'customer',
      'alamat',
      'keterangan',
      'keterangan_pembelian',
      'file',
    ];

    final prefs = await SharedPreferences.getInstance();
    List<String> data = [
      tanggalController.text.toString(),
      jamController.text,
      prefs.getString('username').toString(),
      idPembeli,
      idDistributor,
      customer2Controller.text,
      alamatController.text,
      keteranganController.text,
      ketPembelian.toString(),
      ketPembelian == 'MEMBELI' ? image.toString() : '',
    ];
    // debugPrint('wilayah ${wilayahSalesController.text}');

    Map<String, dynamic> myData = {};
    Map combine = {};

    for (var j = 0; j < dataLabel.length; j++) {
      myData['label'] = dataLabel[j];
      myData['value'] = data[j];
      combine = {...combine, ...myData};
      records.add(combine);
    }
    fields = field;
    EasyLoading.dismiss();
    if (ketPembelian == 'TIDAK MEMBELI') {
      return Get.toNamed('/form_submit', arguments: {
        'records': records,
        'fields': fields,
        'image': '',
        'typeFile': '',
        'extFile': '',
        'fileName': '',
        'latitude': _latitude,
        'longitude': _longitude,
      });
    } else {
      return Get.toNamed('/form_order', arguments: {
        'records': records,
        'fields': fields,
        'image': image!,
        'typeFile': typeFile,
        'extFile': extFile,
        'fileName': fileName,
        'latitude': _latitude,
        'longitude': _longitude,
      });
    }
  }

  bool errorCustomer = false;

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
                  debugPrint('submit');
                  if (_formKey.currentState!.validate()) {
                    FocusScope.of(context).requestFocus(FocusNode());
                    EasyLoading.show(status: 'Memuat');
                    if (ketPembelian == null || ketPembelian == '') {
                      return EasyLoading.showInfo(
                          'Mohon pilih keterangan pembelian terlebih dahulu');
                    } else {
                      if (ketPembelian == 'MEMBELI') {
                        if (image == null) {
                          debugPrint('submit 2');
                          EasyLoading.dismiss();
                          return EasyLoading.showInfo(
                              'Mohon masukkan file / gambar terlebih dahulu');
                        } else {
                          if(_latitude == null || _longitude == null){
                            await getLocation().then((loc) {
                              if (loc != null) {
                                _latitude = loc['latitude'];
                                _longitude = loc['longitude'];
                              }
                            });
                          }
                          await getSubmit();
                        }
                      } else {
                        if(_latitude == null || _longitude == null){
                          await getLocation().then((loc) {
                            if (loc != null) {
                              _latitude = loc['latitude'];
                              _longitude = loc['longitude'];
                            }
                          });
                        }
                        await getSubmit();
                      }
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
                            // ListTile(
                            //   title: Text(
                            //     'Pilih Wilayah Sales',
                            //     maxLines: 2,
                            //     overflow: TextOverflow.ellipsis,
                            //     style: textStyleFormTitle(context),
                            //   ),
                            //   subtitle: Padding(
                            //     padding: const EdgeInsets.only(top: 5.0),
                            //     child: FindDropdown(
                            //       labelVisible: true,
                            //       items: customer.listStringProvinsi,
                            //       labelStyle: textStyleFormTitle(context),
                            //       titleStyle: textStyleFormTitle(context),
                            //       errorBuilder: (context, exception) {
                            //         return Text(exception);
                            //       },
                            //       onChanged: (Object? item) {
                            //         // ignore: prefer_typing_uninitialized_variables

                            //         setState(() {
                            //           // kota = item.toString();
                            //           wilayahSalesController =
                            //               TextEditingController(
                            //                   text: item.toString());
                            //         });
                            //         // debugPrint('kota $kota');
                            //       },
                            //       validate: (String? val) {
                            //         if (val!.isEmpty) {
                            //           debugPrint('csa $val');
                            //           return "Wilayah sales wajib dipilih";
                            //         }
                            //         debugPrint('csa 3 $val');
                            //         return null;
                            //       },
                            //       selectedItem: wilayahSalesController.text,
                            //     ),
                            //   ),
                            // ),
                            ListTile(
                              title: Text(
                                'Tanggal',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: textStyleFormTitle(context),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: DateTimeField(
                                  format: DateFormat('dd-MM-yyyy'),
                                  style: textStyleFormInput(context),
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
                                        left: 10.0, top: 0.0),
                                    hintText: 'Mohon masukkan tanggal',
                                    suffixIcon: const Icon(Icons.close),
                                    hintStyle: textStyleFormInput(context),
                                    errorStyle: textStyleFormError(context),
                                  ),
                                  controller: tanggalController,
                                  onShowPicker: (context, currentValue) async {
                                    return showDatePicker(
                                      context: context,
                                      firstDate: DateTime(1900),
                                      initialDate:
                                          currentValue ?? DateTime.now(),
                                      lastDate: DateTime(2100),
                                      builder: (context, child) {
                                        return Theme(
                                          data: Theme.of(context).copyWith(
                                            colorScheme: ColorScheme.light(
                                              primary:
                                                  primaryColor, // header background color
                                              onPrimary: Colors
                                                  .white, // header text color
                                              onSurface: Colors.blue
                                                  .shade900, // body text color
                                            ),
                                            textButtonTheme:
                                                TextButtonThemeData(
                                              style: TextButton.styleFrom(
                                                backgroundColor: Colors.blue[
                                                    900], // button text color
                                              ),
                                            ),
                                          ),
                                          child: child!,
                                        );
                                      },
                                    );
                                  },
                                  validator: (Object? value) {
                                    if (value == null || value == '') {
                                      return 'Tanggal wajib diisi';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            ListTile(
                              title: Text(
                                'Jam',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: textStyleFormTitle(context),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: DateTimeField(
                                  format: DateFormat('HH:mm:ss a'),
                                  style: textStyleFormInput(context),
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
                                    contentPadding:
                                        const EdgeInsets.only(left: 10.0),
                                    hintText: 'Mohon masukkan jam',
                                    suffixIcon: const Icon(Icons.close),
                                    hintStyle: textStyleFormInput(context),
                                    errorStyle: textStyleFormError(context),
                                  ),
                                  controller: jamController,
                                  onShowPicker: (context, currentValue) async {
                                    final time = await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.fromDateTime(
                                        currentValue ?? DateTime.now(),
                                      ),
                                      builder: (context, child) {
                                        return Theme(
                                          data: Theme.of(context).copyWith(
                                            colorScheme: ColorScheme.light(
                                              primary:
                                                  primaryColor, // header background color
                                              onPrimary: Colors
                                                  .white, // header text color
                                              onSurface: Colors.blue
                                                  .shade900, // body text color
                                            ),
                                            textButtonTheme:
                                                TextButtonThemeData(
                                              style: TextButton.styleFrom(
                                                backgroundColor: Colors.blue[
                                                    900], // button text color
                                              ),
                                            ),
                                          ),
                                          child: child!,
                                        );
                                      },
                                    );
                                    return DateTimeField.convert(time);
                                  },
                                  validator: (Object? value) {
                                    if (value == null || value == '') {
                                      return 'Jam wajib diisi';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
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

                                      dropdownHeight: 180.h,
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
                                          // return "Nama customer wajib dipilih";
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
                                            customer2Controller.text =
                                                str['nama_pembeli'];

                                            debugPrint(
                                                'customer ${customer2Controller.text}');
                                            alamatController.text =
                                                str['alamat'];
                                            idPembeli =
                                                str['id_pembeli'].toString();
                                            idDistributor =
                                                str['id_distributor']
                                                    .toString();
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
                                            customer2Controller.text =
                                                str['nama_pembeli'];
                                            debugPrint(
                                                'customer ${customer2Controller.text}');
                                            alamatController.text =
                                                str['alamat'];
                                            idPembeli =
                                                str['id_pembeli'].toString();
                                            idDistributor =
                                                str['id_distributor']
                                                    .toString();
                                            _latitude =
                                                str['lat_cst'].toString();
                                            _longitude =
                                                str['lon_cst'].toString();
                                            form.setErrorCustomer(false);
                                          });
                                        }
                                      },
                                      displayItemFn: (dynamic item) {
                                        return Text(
                                          (item ?? {})['nama_pembeli'] ?? '',
                                          style: textStyleFormInput(context),
                                        );
                                      },

                                      findFn: (dynamic str) async =>
                                          form.listCustomer,
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
                                    form.errorCustomer.value
                                        ? const Text(
                                            'Pilih customer untuk mengisi alamat')
                                        : const Text(''),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            ListTile(
                              title: Text(
                                'Alamat',
                                style: textStyleFormTitle(context),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: TextFormField(
                                  controller: alamatController,
                                  enableSuggestions: false,
                                  style: textStyleFormTitle(context),
                                  decoration: InputDecoration(
                                    enabled: false,
                                    filled: true,
                                    fillColor: Colors.grey[300],
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
                                    hintText: 'Masukkan alamat',
                                    hintStyle: textStyleFormInput(context),
                                    errorStyle: textStyleFormError(context),
                                  ),
                                  maxLines: 5,
                                ),
                              ),
                            ),
                            Column(
                              children: <Widget>[
                                ketPembelian == 'MEMBELI'
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 16.0,
                                                right: 16.0,
                                                top: 8.0),
                                            child: Container(
                                              height: 0.35.sh,
                                              width: 330.w,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(5.0.r),
                                                ),
                                                border: Border.all(
                                                  color:
                                                      const Color(0xFF00B6F1),
                                                  width: 2,
                                                ),
                                              ),
                                              child: Container(
                                                height: 0.35.sh,
                                                width: 330.w,
                                                color: Colors.white,
                                                child: fileName == ''
                                                    ? Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                              'Silahkan pilih file',
                                                              maxLines: 2,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: textStyleCustom(
                                                                  context,
                                                                  Colors.black,
                                                                  12.sp,
                                                                  FontWeight
                                                                      .normal)),
                                                        ],
                                                      )
                                                    : loadingGetFile
                                                        ? const LoadingApp(
                                                            topPaddingLoading:
                                                                0)
                                                        : typeFile == 'image' &&
                                                                fileName != null
                                                            ? Image.file(
                                                                image!,
                                                                fit:
                                                                    BoxFit.fill,
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
                                                                          maxLines:
                                                                              2,
                                                                          overflow: TextOverflow
                                                                              .ellipsis,
                                                                          style: textStyleCustom(
                                                                              context,
                                                                              Colors.black,
                                                                              10.sp,
                                                                              FontWeight.normal)),
                                                                    ],
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
                                                                              Image.asset(
                                                                                'assets/img/file/pdf.png',
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
                                                                                'docx'
                                                                            ? Column(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                crossAxisAlignment: CrossAxisAlignment.center,
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
                                                                            : extFile == 'pptx'
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
                                                                                          Text('Silahkan pilih file', maxLines: 1, overflow: TextOverflow.ellipsis, style: textStyleCustom(context, Colors.black, 12.sp, FontWeight.normal)),
                                                                                        ],
                                                                                      ),
                                                                  ),
                                              ),
                                            ),
                                          )
                                        ],
                                      )
                                    : Container(),
                                ketPembelian == 'MEMBELI'
                                    ? Padding(
                                        padding: const EdgeInsets.only(
                                            left: 13.0, right: 13.0, top: 15.0),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: InkWell(
                                                  onTap: () async {
                                                    // await global.getImage('gallery');
                                                    await getFileDocument(
                                                        context);
                                                  },
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .fromLTRB(
                                                        3.0, 5.0, 3.0, 0),
                                                    child: Container(
                                                        height: 35.5.h,
                                                        width: 82.5.w,
                                                        padding: const EdgeInsets
                                                                .symmetric(
                                                            vertical: 10),
                                                        alignment:
                                                            Alignment.center,
                                                        decoration:
                                                            BoxDecoration(
                                                                borderRadius:
                                                                    const BorderRadius
                                                                            .all(
                                                                        Radius.circular(
                                                                            5)),
                                                                boxShadow: <
                                                                    BoxShadow>[
                                                                  BoxShadow(
                                                                      color: Colors
                                                                          .grey
                                                                          .shade200,
                                                                      offset:
                                                                          const Offset(2,
                                                                              2),
                                                                      blurRadius:
                                                                          1,
                                                                      spreadRadius:
                                                                          1)
                                                                ],
                                                                gradient: const LinearGradient(
                                                                    begin: Alignment
                                                                        .centerLeft,
                                                                    end: Alignment
                                                                        .centerRight,
                                                                    colors: [
                                                                      Color.fromARGB(
                                                                          255,
                                                                          108,
                                                                          194,
                                                                          43),
                                                                      Color.fromARGB(
                                                                          255,
                                                                          92,
                                                                          206,
                                                                          21),
                                                                    ])),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                          children: [
                                                            Text('Galeri',
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: textStyleCustom(
                                                                    context,
                                                                    Colors
                                                                        .white,
                                                                    12.sp,
                                                                    FontWeight
                                                                        .bold)),
                                                            Icon(
                                                              Icons.image,
                                                              color:
                                                                  Colors.white,
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
                                                    padding: const EdgeInsets
                                                            .fromLTRB(
                                                        3.0, 5.0, 3.0, 0),
                                                    child: Container(
                                                        height: 35.5.h,
                                                        width: 82.5.w,
                                                        padding: const EdgeInsets
                                                                .symmetric(
                                                            vertical: 10),
                                                        alignment:
                                                            Alignment.center,
                                                        decoration:
                                                            BoxDecoration(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(5
                                                                            .r)),
                                                                boxShadow: <
                                                                    BoxShadow>[
                                                                  BoxShadow(
                                                                      color: Colors
                                                                          .grey
                                                                          .shade200,
                                                                      offset:
                                                                          const Offset(2,
                                                                              2),
                                                                      blurRadius:
                                                                          1,
                                                                      spreadRadius:
                                                                          1)
                                                                ],
                                                                gradient: const LinearGradient(
                                                                    begin: Alignment
                                                                        .centerLeft,
                                                                    end: Alignment
                                                                        .centerRight,
                                                                    colors: [
                                                                      Color.fromARGB(
                                                                          255,
                                                                          108,
                                                                          194,
                                                                          43),
                                                                      Color.fromARGB(
                                                                          255,
                                                                          92,
                                                                          206,
                                                                          21),
                                                                    ])),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                          children: [
                                                            Text('Kamera',
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: textStyleCustom(
                                                                    context,
                                                                    Colors
                                                                        .white,
                                                                    12.sp,
                                                                    FontWeight
                                                                        .bold)),
                                                            Icon(
                                                              Icons.camera_alt,
                                                              color:
                                                                  Colors.white,
                                                              size: 15.sp,
                                                            ),
                                                          ],
                                                        )),
                                                  )),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Container(),
                                SizedBox(
                                  height: 12.h,
                                ),
                                ListTile(
                                  title: Text(
                                    'Keterangan Pembelian:',
                                    style: textStyleFormTitle(context),
                                  ),
                                  subtitle: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      RadioListTile(
                                        dense: true,
                                        value: 'MEMBELI',
                                        groupValue: ketPembelian,
                                        title: Text(
                                          'MEMBELI',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: textStyleFormTitle(context),
                                        ),
                                        onChanged: (val) {
                                          _handleKetPembelian(val.toString());
                                        },
                                        activeColor: Colors.blue[900],
                                      ),
                                      RadioListTile(
                                        dense: true,
                                        value: 'TIDAK MEMBELI',
                                        groupValue: ketPembelian,
                                        title: Text(
                                          'TIDAK MEMBELI',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: textStyleFormTitle(context),
                                        ),
                                        onChanged: (val) {
                                          _handleKetPembelian(val.toString());
                                        },
                                        activeColor: Colors.blue[900],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 12.h,
                                ),
                                ketPembelian == 'TIDAK MEMBELI'
                                    ? ListTile(
                                        title: Text(
                                          'Keterangan / Alasan',
                                          style: textStyleFormTitle(context),
                                        ),
                                        subtitle: Padding(
                                          padding: const EdgeInsets.only(
                                            top: 5.0,
                                          ),
                                          child: TextFormField(
                                              controller: keteranganController,
                                              // enableSuggestions: false,
                                              style:
                                                  textStyleFormTitle(context),
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Colors.white,
                                                border: InputBorder.none,
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                                color: Color(
                                                                    0xFF979797),
                                                                width: 0.5),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5.0)),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                                color: Color(
                                                                    0xFF979797),
                                                                width: 0.5),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5.0)),
                                                errorBorder: OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            color: Color(
                                                                0xFF979797),
                                                            width: 0.5),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0)),
                                                contentPadding:
                                                    const EdgeInsets.only(
                                                        left: 10.0, top: 10.0),
                                                hintText: 'Masukkan Keterangan',
                                                hintStyle:
                                                    textStyleFormInput(context),
                                                errorStyle:
                                                    textStyleFormError(context),
                                              ),
                                              validator: (value) {
                                                if (value == '') {
                                                  return 'Keterangan wajib diisi';
                                                }
                                                return null;
                                              },
                                              maxLines: 5,
                                              keyboardType: TextInputType.text
                                              // onFieldSubmitted: (val) {
                                              //   FocusManager
                                              //       .instance.primaryFocus
                                              //       ?.unfocus();
                                              // }
                                              ),
                                        ),
                                      )
                                    : Container(),
                                // SizedBox(
                                //   height: 12.h,
                                // ),
                                // ketPembelian == 'TIDAK MEMBELI'
                                //     ? Padding(
                                //         padding: EdgeInsets.fromLTRB(
                                //             15.0,
                                //             0,
                                //             15.0,
                                //             GetPlatform.isAndroid ? 15 : 20),
                                //         child: SizedBox(
                                //           width: 320.w,
                                //           height: GetPlatform.isAndroid
                                //               ? 30.h
                                //               : 35.h,
                                //           child: ElevatedButton(
                                //             style: ElevatedButton.styleFrom(
                                //               primary: primaryColor,
                                //               textStyle:
                                //                   textStyleButtonLogin(context),
                                //             ),
                                //             onPressed: () async {
                                //               if (_formKey.currentState!
                                //                   .validate()) {
                                //                 FocusScope.of(context)
                                //                     .requestFocus(FocusNode());
                                //                 // EasyLoading.show(status: 'Memuat');
                                //                 if (ketPembelian == null ||
                                //                     ketPembelian == '') {
                                //                   return EasyLoading.showInfo(
                                //                       'Mohon pilih keterangan pembelian terlebih dahulu');
                                //                 } else {
                                //                   await getSubmit();
                                //                 }
                                //               }
                                //             },
                                //             child: const Text(
                                //               'Lanjut',
                                //             ),
                                //           ),
                                //         ),
                                //       )
                                //     : const Text(''),
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
