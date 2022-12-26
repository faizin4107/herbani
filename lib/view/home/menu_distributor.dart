import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:herbani/controller/auth.dart';
import 'package:herbani/controller/customer.dart';
import 'package:herbani/controller/form.dart';
import 'package:herbani/controller/home.dart';
import 'package:herbani/controller/retur.dart';
import 'package:herbani/helper/alert_custom.dart';
import 'package:herbani/helper/textstyle_custom.dart';
import 'package:herbani/util/constant.dart';
import 'package:herbani/view/form/form_retur.dart';
import 'package:herbani/view/home/choose_region_po.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuDistributor extends StatelessWidget {
  MenuDistributor({Key? key}) : super(key: key);
  final HomeController home = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    debugPrint('level ${home.namaLevel.value}');
    return Column(
      // shrinkWrap: true,
      children: [
        Column(
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

                    final FormController form = Get.put(FormController());
                    final CustomerController customerController =
                        Get.put(CustomerController());
                    await customerController.getProvinsi();
                    if (form.listCustomer.isNotEmpty) {
                      if (customerController.listProvinsi.isNotEmpty) {
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
                          'Data customer masih kosong, silahkan daftarkan customer terlebih dahulu');
                    }
                  },
                  child: SizedBox(
                    height: 70.h,
                    width: 80.w,
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
                          textAlign: TextAlign.center,
                              style: textStyleCustomLato(context,
                                  Colors.blue[900], 11.sp, FontWeight.bold))
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    final AuthController auth = Get.put(AuthController());
                    auth.oldPassword.value.clear();
                    auth.newPassword.value.clear();
                    Get.toNamed('/akun_non_dki');
                  },
                  child: SizedBox(
                    height: 70.h,
                    width: 80.w,
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
                          textAlign: TextAlign.center,
                              style: textStyleCustomLato(context,
                                  Colors.blue[900], 11.sp, FontWeight.bold))
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
                    //   builder: (context) => const ChooseRegionPo(route: 'po'),
                    // );
                    Get.toNamed('/order_non_dki', arguments: {
                      'ket': 'membeli',
                      'title': 'Purchase Order',
                      'region': 'non-dki',
                      'level': home.namaLevel.value
                    });
                  },
                  child: SizedBox(
                    height: 70.h,
                    width: 80.w,
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
                          textAlign: TextAlign.center,
                              style: textStyleCustomLato(context,
                                  Colors.blue[900], 11.sp, FontWeight.bold)),
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
                    //       const ChooseRegionPo(route: 'kunjungan'),
                    // );
                    Get.toNamed('/order_non_dki', arguments: {
                      'ket': 'tidak_membeli',
                      'title': 'Data Kunjungan',
                      'region': 'non-dki',
                      'level': home.namaLevel.value
                    });
                  },
                  child: SizedBox(
                    height: 70.h,
                    width: 80.w,
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
                          textAlign: TextAlign.center,
                              style: textStyleCustomLato(context,
                                  Colors.blue[900], 11.sp, FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ),

                GestureDetector(
                  onTap: () {
                    Get.toNamed('/list_customer_non_dki');
                  },
                  child: SizedBox(
                    height: 70.h,
                    width: 80.w,
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
                          textAlign: TextAlign.center,
                              style: textStyleCustomLato(context,
                                  Colors.blue[900], 11.sp, FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    // final prefs = await SharedPreferences.getInstance();
                    // debugPrint('id sales ${prefs.getString('username')}');

                    // EasyLoading.show(status: 'Memuat...');
                    // await Get.put(FormController()).getPreorder();

                    // final FormController form = Get.put(FormController());

                    // if (form.listPreorder.isNotEmpty) {
                    //   EasyLoading.dismiss();
                    //   Get.toNamed('/form_retur');
                    // } else {
                    //   EasyLoading.dismiss();
                    //   EasyLoading.dismiss();
                    //   return EasyLoading.showInfo(
                    //       'Gagal memuat data, silahkan coba lagi!');
                    // }
                    Get.toNamed('/retur', arguments: {'title': 'Data Retur'});
                    // debugPrint('id user $')
                  },
                  child: SizedBox(
                    height: 70.h,
                    width: 80.w,
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
                            Icons.restore,
                            size: 30.sp,
                            color: Colors.blue[900],
                          ),
                          Text('Retur',
                          textAlign: TextAlign.center,
                              style: textStyleCustomLato(context,
                                  Colors.blue[900], 11.sp, FontWeight.bold)),
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
                   
                    Get.toNamed('/distributor', arguments: {
                      'title': 'Data Distributor'
                    });
                  },
                  child: SizedBox(
                    height: 70.h,
                    width: 80.w,
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
                            Icons.house_outlined,
                            size: 30.sp,
                            color: Colors.blue[900],
                          ),
                          Text('Distributor',
                          textAlign: TextAlign.center,
                              style: textStyleCustomLato(context,
                                  Colors.blue[900], 11.sp, FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        )
      ],
    );
  }
}
