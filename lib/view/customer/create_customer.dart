import 'package:dio/dio.dart' as dio;
import 'package:find_dropdown/find_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:herbani/controller/customer.dart';
import 'package:herbani/helper/function.dart';
import 'package:herbani/helper/textstyle_custom.dart';
import 'package:herbani/util/constant.dart';
import 'package:herbani/widget/appbar/appbar_default.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateCustomer extends StatefulWidget {
  const CreateCustomer({Key? key}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _CreateCustomerState createState() => _CreateCustomerState();
}

class _CreateCustomerState extends State<CreateCustomer> {
  final CustomerController customer = Get.put(CustomerController());
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController namaPembeliController = TextEditingController();
  TextEditingController jenisCustomerController = TextEditingController();
  TextEditingController noTelpController = TextEditingController();
  TextEditingController alamatController = TextEditingController();
  TextEditingController provinsiController = TextEditingController();
  TextEditingController kotaController = TextEditingController();
  String idPembeli = '';
  String? provinsi;
  String? provinsiId;
  String? kecamatan;
  String? kelurahan;
  String? kota;
  String? kotaId;
  String? lat;
  String? lng;
  dio.CancelToken token = dio.CancelToken();
  @override
  void initState() {
    final CustomerController customerController = Get.put(CustomerController());
    // customerController.getKelurahan();
    // customerController.getKecamatan();
    // customerController.getKota();
    customerController.getProvinsi();

    super.initState();
  }

  List<String> dropwDownJenisCutomer = [
    'Perorangan',
    'Toko',
    'Perusahaan',
  ];

  Map location = {};

  List<dynamic> records = [];
  bool changeProv = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        EasyLoading.dismiss();
        return true;
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: const AppBarDefault(
          title: 'Tambah Customer',
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
                    EasyLoading.show(status: 'Memuat');
                    await requestPermissionLocation(context)
                        .then((permission) async {
                      if (permission == true) {
                        
                            // ignore: prefer_typing_uninitialized_variables
                            var address;
                            // ignore: prefer_typing_uninitialized_variables
                            var lat;
                            // ignore: prefer_typing_uninitialized_variables
                            var lng;
                            await getLocation().then((location) {
                              if (location != null) {
                                address = location['address'];
                                lat = location['latitude'];
                                lng = location['longitude'];
                              }
                            });
                            final prefs = await SharedPreferences.getInstance();
                            final String? area = prefs.getString('area');
                            final String? disId =
                                prefs.getString('distributor_id');
                            Map body = {};

                            if (area != null) {
                              body = {
                                'nama_pembeli': namaPembeliController.text,
                                'jenis_p': jenisCustomerController.text,
                                'no_telp': noTelpController.text,
                                'distributor_id': disId,
                                'alamat': address,
                                'provinsi_id':
                                    customer.provinsiController.value.text,
                                'kota_id': customer.kotaController.value.text,
                                'kecamatan_id':
                                    customer.kecamatanController.value.text,
                                'kelurahan_id':
                                    customer.kelurahanController.value.text,
                                'latitude': lat,
                                'longitude': lng
                              };
                            } else {
                              body = {
                                'nama_pembeli': namaPembeliController.text,
                                'jenis_p': jenisCustomerController.text,
                                'no_telp': noTelpController.text,
                                'provinsi':
                                    customer.provinsiController.value.text,
                                'kota': customer.kotaController.value.text,
                                'kelurahan':
                                    customer.kelurahanController.value.text,
                                'kecamatan':
                                    customer.kecamatanController.value.text,
                                'alamat': address,
                                'lat_cst': lat,
                                'lon_cst': lng
                              };
                            }
                            debugPrint('body $body');
                            await customer.createCustomer(body);
                      } else if (permission == 'location-denied-forever' ||
                          permission == 'location-denied') {
                        EasyLoading.dismiss();
                      }
                    });
                  }
                },
                child: const Text(
                  'Tambah',
                ),
              ),
            )),
        body: Obx(
          () => SafeArea(
            maintainBottomViewPadding: true,
            bottom: false,
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
                                  'Nama pembeli',
                                  style: textStyleFormTitle(context),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: TextFormField(
                                    controller: namaPembeliController,
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
                                          left: 10.0, top: 10.0),
                                      hintText: 'Masukkan nama pembeli',
                                      hintStyle: textStyleFormInput(context),
                                      errorStyle: textStyleFormError(context),
                                    ),
                                    validator: (value) {
                                      if (value == '') {
                                        return 'Nama pembeli wajib diisi';
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
                                  'Jenis Customer',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: textStyleFormTitle(context),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: FindDropdown(
                                    labelVisible: true,
                                    items: dropwDownJenisCutomer,
                                    labelStyle: textStyleFormTitle(context),
                                    titleStyle: textStyleFormTitle(context),
                                    validate: (value) {
                                      if (value == '') {
                                        return 'Jenis customer wajib diisi';
                                      }
                                      return null;
                                    },
                                    onChanged: (Object? item) {
                                      setState(() {
                                        jenisCustomerController =
                                            TextEditingController(
                                                text: item.toString());
                                      });
                                    },
                                    selectedItem: jenisCustomerController.text,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              ListTile(
                                title: Text(
                                  'No Telepon',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: textStyleFormTitle(context),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: TextFormField(
                                    controller: noTelpController,
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
                                          left: 10.0, top: 10.0),
                                      hintText: 'Masukkan no telepon',
                                      hintStyle: textStyleFormInput(context),
                                      errorStyle: textStyleFormError(context),
                                    ),
                                    validator: (value) {
                                      if (value == '') {
                                        return 'No Telepon wajib diisi';
                                      }
                                      return null;
                                    },
                                    maxLength: 14,
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              ListTile(
                                title: Text(
                                  'Provinsi',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: textStyleFormTitle(context),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: FindDropdown(
                                    labelVisible: true,
                                    items: customer.listStringProvinsi,
                                    labelStyle: textStyleFormTitle(context),
                                    titleStyle: textStyleFormTitle(context),
                                    onChanged: (Object? item) async {
                                      final prefs =
                                          await SharedPreferences.getInstance();
                                      final area = prefs.getString('area');
                                      // ignore: prefer_typing_uninitialized_variables
                                      var id;
                                      for (var j = 0;
                                          j < customer.listProvinsi.length;
                                          j++) {
                                        if (customer.listProvinsi[j]
                                                ['prov_name'] ==
                                            item) {
                                          if (area != null) {
                                            id = customer.listProvinsi[j]['id'];
                                          } else {
                                            id = customer.listProvinsi[j]
                                                ['prov_id'];
                                          }
                                        }
                                      }

                                      setState(() {
                                        changeProv = true;
                                        customer.provinsiController.value =
                                            TextEditingController(
                                                text: id.toString());
                                        customer
                                            .generateProvinsi(item.toString());
                                      });
                                    },
                                    selectedItem:
                                        customer.provinsiController.value.text,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              ListTile(
                                title: Text(
                                  'Kota',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: textStyleFormTitle(context),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: FindDropdown(
                                    labelVisible: true,
                                    items: customer.listStringKota,
                                    labelStyle: textStyleFormTitle(context),
                                    titleStyle: textStyleFormTitle(context),
                                    onChanged: (Object? item) async {
                                      final prefs =
                                          await SharedPreferences.getInstance();
                                      final area = prefs.getString('area');
                                      // ignore: prefer_typing_uninitialized_variables
                                      var id;
                                      for (var j = 0;
                                          j < customer.listKota.length;
                                          j++) {
                                        if (customer.listKota[j]['city_name'] ==
                                            item) {
                                          if (area != null) {
                                            id = customer.listKota[j]['id'];
                                          } else {
                                            id =
                                                customer.listKota[j]['city_id'];
                                          }
                                        }
                                      }
                                      setState(() {
                                        customer.kotaController.value =
                                            TextEditingController(
                                                text: id.toString());
                                        customer.generateKota(item.toString());
                                      });
                                    },
                                    selectedItem:
                                        customer.kotaController.value.text,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              ListTile(
                                title: Text(
                                  'Kecamatan',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: textStyleFormTitle(context),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: FindDropdown(
                                    labelVisible: true,
                                    items: customer.listStringKecamatan,
                                    labelStyle: textStyleFormTitle(context),
                                    titleStyle: textStyleFormTitle(context),
                                    onChanged: (Object? item) async {
                                      final prefs =
                                          await SharedPreferences.getInstance();
                                      final area = prefs.getString('area');
                                      // ignore: prefer_typing_uninitialized_variables
                                      var id;
                                      for (var j = 0;
                                          j < customer.listKecamatan.length;
                                          j++) {
                                        if (customer.listKecamatan[j]
                                                ['dis_name'] ==
                                            item) {
                                          if (area != null) {
                                            id =
                                                customer.listKecamatan[j]['id'];
                                          } else {
                                            id = customer.listKecamatan[j]
                                                ['dis_id'];
                                          }
                                        }
                                      }
                                      setState(() {
                                        customer.kecamatanController.value =
                                            TextEditingController(
                                                text: id.toString());
                                        customer
                                            .generateKecamatan(item.toString());
                                      });
                                    },
                                    selectedItem:
                                        customer.kecamatanController.value.text,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              ListTile(
                                title: Text(
                                  'Kelurahan',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: textStyleFormTitle(context),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: FindDropdown(
                                    labelVisible: true,
                                    items: customer.listStringKelurahan,
                                    labelStyle: textStyleFormTitle(context),
                                    titleStyle: textStyleFormTitle(context),
                                    onChanged: (Object? item) async {
                                      final prefs =
                                          await SharedPreferences.getInstance();
                                      final area = prefs.getString('area');
                                      // ignore: prefer_typing_uninitialized_variables
                                      var id;
                                      for (var j = 0;
                                          j < customer.listKelurahan.length;
                                          j++) {
                                        if (customer.listKelurahan[j]
                                                ['subdis_name'] ==
                                            item) {
                                          if (area != null) {
                                            id =
                                                customer.listKelurahan[j]['id'];
                                          } else {
                                            id = customer.listKelurahan[j]
                                                ['subdis_id'];
                                          }
                                        }
                                      }
                                      setState(() {
                                        customer.kelurahanController.value =
                                            TextEditingController(
                                                text: id.toString());
                                        // form.generateKecamatan(
                                        //     item.toString());
                                      });
                                    },
                                    selectedItem:
                                        customer.kelurahanController.value.text,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10.h,
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
      ),
    );
  }
}
