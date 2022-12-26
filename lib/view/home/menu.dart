import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:herbani/controller/auth.dart';
import 'package:herbani/controller/customer.dart';
import 'package:herbani/controller/form.dart';
import 'package:herbani/controller/home.dart';
import 'package:herbani/helper/alert_custom.dart';
import 'package:herbani/helper/textstyle_custom.dart';
import 'package:herbani/view/home/choose_region_po.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Menu extends StatelessWidget {
  Menu({Key? key}) : super(key: key);
  final HomeController home = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    debugPrint('level ${home.namaLevel.value}');
    return Obx(() => Column(
          // shrinkWrap: true,
          children: [
            home.namaLevel.value == 'sales'
                ? Column(
                    children: [
                      SizedBox(
                        height: 10.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              EasyLoading.show(status: 'Memuat...');
                              await Get.put(FormController()).getCustomer();

                              final FormController form =
                                  Get.put(FormController());
                              final CustomerController customerController =
                                  Get.put(CustomerController());
                              await customerController.getProvinsi();
                              if (form.listCustomer.isNotEmpty) {
                                if (customerController
                                    .listProvinsi.isNotEmpty) {
                                  EasyLoading.dismiss();
                                  Get.toNamed('/form_field');
                                } else {
                                  form.setErrorCustomer(false);
                                  EasyLoading.dismiss();
                                  return EasyLoading.showInfo(
                                      'Gagal memuat data, silahkan coba lagi!');
                                }
                              } else {
                                EasyLoading.dismiss();
                                EasyLoading.dismiss();
                                return EasyLoading.showInfo(
                                    'Gagal memuat data, silahkan coba lagi!');
                              }
                            },
                            child: SizedBox(
                              height: 80.h,
                              width: 130.w,
                              child: Card(
                                color: Colors.white,
                                elevation: 3.0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.edit_calendar_outlined,
                                      size: 30.sp,
                                      color: Colors.blue[900],
                                    ),
                                    Text('Form',
                                        style: textStyleCustomLato(
                                            context,
                                            Colors.blue[900],
                                            12.sp,
                                            FontWeight.bold))
                                  ],
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              final AuthController auth =
                                  Get.put(AuthController());
                              auth.oldPassword.value.clear();
                              auth.newPassword.value.clear();
                              Get.toNamed('/akun');
                            },
                            child: SizedBox(
                              height: 80.h,
                              width: 130.w,
                              child: Card(
                                color: Colors.white,
                                elevation: 3.0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.person,
                                      size: 30.sp,
                                      color: Colors.blue[900],
                                    ),
                                    Text('Akun',
                                        style: textStyleCustomLato(
                                            context,
                                            Colors.blue[900],
                                            12.sp,
                                            FontWeight.bold))
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: () {
                              // showCupertinoModalBottomSheet(
                              //   duration: const Duration(milliseconds: 300),
                              //   animationCurve: Curves.easeOut,
                              //   previousRouteAnimationCurve: Curves.easeOut,
                              //   expand: false,
                              //   context: context,
                              //   enableDrag: false,
                              //   backgroundColor: Colors.transparent,
                              //   builder: (context) =>
                              //       const ChooseRegionPo(route: 'po'),
                              // );
                              Get.toNamed('/order', arguments: {
                                'ket': 'membeli',
                                'title': 'Purchase Order',
                                'region': 'dki',
                                'level': home.namaLevel.value
                              });
                            },
                            child: SizedBox(
                              height: 80.h,
                              width: 130.w,
                              child: Card(
                                color: Colors.white,
                                elevation: 3.0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.list_alt_outlined,
                                      size: 30.sp,
                                      color: Colors.blue[900],
                                    ),
                                    Text('Purchase Order',
                                        style: textStyleCustomLato(
                                            context,
                                            Colors.blue[900],
                                            12.sp,
                                            FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // showCupertinoModalBottomSheet(
                              //   duration: const Duration(milliseconds: 300),
                              //   animationCurve: Curves.easeOut,
                              //   previousRouteAnimationCurve: Curves.easeOut,
                              //   expand: false,
                              //   context: context,
                              //   enableDrag: false,
                              //   backgroundColor: Colors.transparent,
                              //   builder: (context) =>
                              //       const ChooseRegionPo(route: 'kunjungan'),
                              // );
                              Get.toNamed('/order', arguments: {
                                'ket': 'tidak_membeli',
                                'title': 'Data Kunjungan',
                                'region': 'dki',
                                'level': home.namaLevel.value
                              });
                            },
                            child: SizedBox(
                              height: 80.h,
                              width: 130.w,
                              child: Card(
                                color: Colors.white,
                                elevation: 3.0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.list_alt_outlined,
                                      size: 30.sp,
                                      color: Colors.blue[900],
                                    ),
                                    Text('Data Kunjungan',
                                        style: textStyleCustomLato(
                                            context,
                                            Colors.blue[900],
                                            12.sp,
                                            FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 12.5.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.toNamed('/list_customer');
                            },
                            child: SizedBox(
                              height: 80.h,
                              width: 130.w,
                              child: Card(
                                color: Colors.white,
                                elevation: 3.0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.list_alt_outlined,
                                      size: 30.sp,
                                      color: Colors.blue[900],
                                    ),
                                    Text('Customer',
                                        style: textStyleCustomLato(
                                            context,
                                            Colors.blue[900],
                                            12.sp,
                                            FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              final prefs =
                                  await SharedPreferences.getInstance();
                              debugPrint(
                                  'id sales ${prefs.getString('username')}');

                              Get.toNamed('/invoice', arguments: {
                                'ket': 'membeli',
                                'title': 'PO Ditolak',
                                'id_user': prefs.getString('username'),
                                'status': 'Ditolak'
                              });
                              // debugPrint('id user $')
                            },
                            child: SizedBox(
                              height: 80.h,
                              width: 130.w,
                              child: Card(
                                color: Colors.white,
                                elevation: 3.0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.list_alt_outlined,
                                      size: 30.sp,
                                      color: Colors.blue[900],
                                    ),
                                    Text('PO Ditolak',
                                        style: textStyleCustomLato(
                                            context,
                                            Colors.blue[900],
                                            12.sp,
                                            FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                : home.namaLevel.value == 'delivery'
                    ? Column(
                        children: [
                          SizedBox(
                            height: 10.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  final AuthController auth =
                                      Get.put(AuthController());
                                  auth.oldPassword.value.clear();
                                  auth.newPassword.value.clear();
                                  Get.toNamed('/akun');
                                },
                                child: SizedBox(
                                  height: 100.h,
                                  width: 140.w,
                                  child: Card(
                                    color: Colors.white,
                                    elevation: 3.0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.person,
                                          size: 30.sp,
                                          color: Colors.blue[900],
                                        ),
                                        Text('Akun',
                                            style: textStyleCustomLato(
                                                context,
                                                Colors.blue[900],
                                                12.sp,
                                                FontWeight.bold))
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Get.toNamed('/invoice', arguments: {
                                    'ket': 'membeli',
                                    'title': 'Pengiriman',
                                    'id_user': null,
                                    'status': 'Dikirim'
                                  });
                                  // Get.toNamed('/pesanan_terkirim');
                                },
                                child: SizedBox(
                                  height: 100.h,
                                  width: 140.w,
                                  child: Card(
                                    color: Colors.white,
                                    elevation: 3.0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.send_and_archive,
                                          size: 30.sp,
                                          color: Colors.blue[900],
                                        ),
                                        Text('Pengiriman',
                                            style: textStyleCustomLato(
                                                context,
                                                Colors.blue[900],
                                                12.sp,
                                                FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              // GestureDetector(
                              //   onTap: () {
                              //     Get.toNamed('/order', arguments: {
                              //       'ket': 'membeli',
                              //       'title': 'Purchase Order'
                              //     });
                              //   },
                              //   child: SizedBox(
                              //     height: 100.h,
                              //     width: 140.w,
                              //     child: Card(
                              //       color: Colors.white,
                              //       elevation: 3.0,
                              //       shape: RoundedRectangleBorder(
                              //           borderRadius:
                              //               BorderRadius.circular(10)),
                              //       child: Column(
                              //         mainAxisAlignment:
                              //             MainAxisAlignment.center,
                              //         crossAxisAlignment:
                              //             CrossAxisAlignment.center,
                              //         children: [
                              //           Icon(
                              //             Icons.list_alt_outlined,
                              //             size: 30.sp,
                              //             color: Colors.blue[900],
                              //           ),
                              //           Text('Purchase Order',
                              //               style: textStyleCustomLato(
                              //                   context,
                              //                   Colors.blue[900],
                              //                   12.sp,
                              //                   FontWeight.bold)),
                              //         ],
                              //       ),
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                          //   children: [

                          //   ],
                          // ),
                        ],
                      )
                    : Column(
                        children: [
                          SizedBox(
                            height: 10.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  final AuthController auth =
                                      Get.put(AuthController());
                                  auth.oldPassword.value.clear();
                                  auth.newPassword.value.clear();
                                  Get.toNamed('/akun');
                                },
                                child: SizedBox(
                                  height: 100.h,
                                  width: 140.w,
                                  child: Card(
                                    color: Colors.white,
                                    elevation: 3.0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.person,
                                          size: 30.sp,
                                          color: Colors.blue[900],
                                        ),
                                        Text('Akun',
                                            style: textStyleCustomLato(
                                                context,
                                                Colors.blue[900],
                                                12.sp,
                                                FontWeight.bold))
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  EasyLoading.show(status: 'Memuat...');
                                  await Get.put(FormController()).getCustomer();

                                  final FormController form =
                                      Get.put(FormController());

                                  debugPrint('status ${form.status.isLoading}');
                                  debugPrint('status ${form.listCustomer}');

                                  if (form.listCustomer.isNotEmpty) {
                                    EasyLoading.dismiss();
                                    Get.toNamed('/form_penagihan', arguments: {
                                      // 'ket': 'membeli',
                                      // 'title': 'Form Penagihan',
                                      // 'id_user': null,
                                      // 'status': 'Diterima'
                                    });
                                  } else {
                                    EasyLoading.dismiss();
                                    // if (!mounted) return;
                                    // ignore: use_build_context_synchronously
                                    return orangeDialog(
                                        context,
                                        'Data customer belum tersedia',
                                        AlertType.info);
                                  }
                                },
                                child: SizedBox(
                                  height: 100.h,
                                  width: 140.w,
                                  child: Card(
                                    color: Colors.white,
                                    elevation: 3.0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.monetization_on,
                                          size: 30.sp,
                                          color: Colors.blue[900],
                                        ),
                                        Text('Penagihan',
                                            style: textStyleCustomLato(
                                                context,
                                                Colors.blue[900],
                                                12.sp,
                                                FontWeight.bold))
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Get.toNamed('/laporan_penagihan');
                                },
                                child: SizedBox(
                                  height: 100.h,
                                  width: 140.w,
                                  child: Card(
                                    color: Colors.white,
                                    elevation: 3.0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.history,
                                          size: 30.sp,
                                          color: Colors.blue[900],
                                        ),
                                        Text('Laporan',
                                            style: textStyleCustomLato(
                                                context,
                                                Colors.blue[900],
                                                12.sp,
                                                FontWeight.bold))
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
          ],
        ));
  }
}
