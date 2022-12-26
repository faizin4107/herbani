import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:herbani/controller/home.dart';
import 'package:herbani/helper/textstyle_custom.dart';
import 'package:herbani/util/constant.dart';
// import 'package:herbani/widget/button/button_row.dart';

class ChooseRegionPo extends StatefulWidget {
  const ChooseRegionPo({Key? key, this.route}) : super(key: key);
  final String? route;
  @override
  State<ChooseRegionPo> createState() => _ChooseRegionPoState();
}

class _ChooseRegionPoState extends State<ChooseRegionPo> {
  final HomeController home = Get.put(HomeController());
  @override
  void initState() {
    super.initState();
  }

  String? region;

  @override
  Widget build(BuildContext context) {
    return Material(
        child: SafeArea(
      top: false,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: 12.h),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Pilih Wilayah Sales',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textStyleCustom(
                            context, Colors.black, 12.sp, FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        debugPrint('home ${home.namaLevel.value}');
                        if (widget.route == 'po') {
                          Get.toNamed('/order', arguments: {
                            'ket': 'membeli',
                            'title': 'Purchase Order',
                            'region': 'dki',
                            'level': home.namaLevel.value
                          })!
                              .then((value) {
                            if (value == 'true') {
                              Get.back();
                            }
                          });
                        } else {
                          Get.toNamed('/order', arguments: {
                            'ket': 'tidak_membeli',
                            'title': 'Data Kunjungan',
                            'region': 'dki',
                            'level': home.namaLevel.value
                          })!
                              .then((value) {
                            if (value == 'true') {
                              Get.back();
                            }
                          });
                        }

                        // ignore: use_build_context_synchronously
                        // Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 28.0, right: 28.0),
                        child: Container(
                          padding:
                              const EdgeInsets.only(left: 18.0, right: 18.0),
                          height: 40.h,
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.all(
                              Radius.circular(5.r),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'DKI Jakarta',
                                style: textStyleCustom(context, Colors.white,
                                    12.sp, FontWeight.w500),
                              ),
                              const Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),

                    GestureDetector(
                      onTap: () {
                        debugPrint('home ${home.namaLevel.value}');
                        // debugPrint('region ')
                        if (widget.route == 'po') {
                          Get.toNamed('/order', arguments: {
                            'ket': 'membeli',
                            'title': 'Purchase Order',
                            'region': 'non-dki',
                            'level': home.namaLevel.value
                          })!
                              .then((value) {
                            if (value == 'true') {
                              Get.back();
                            }
                          });
                        } else {
                          Get.toNamed('/order', arguments: {
                            'ket': 'tidak_membeli',
                            'title': 'Data Kunjungan',
                            'region': 'non-dki',
                            'level': home.namaLevel.value
                          })!
                              .then((value) {
                            if (value == 'true') {
                              Get.back();
                            }
                          });
                        }

                        // ignore: use_build_context_synchronously
                        // Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 28.0, right: 28.0),
                        child: Container(
                          padding:
                              const EdgeInsets.only(left: 18.0, right: 18.0),
                          height: 40.h,
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.all(
                              Radius.circular(5.r),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Non DKI Jakarta',
                                style: textStyleCustom(context, Colors.white,
                                    12.sp, FontWeight.w500),
                              ),
                              const Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // RadioListTile(
                    //   dense: true,
                    //   value: 'dki',
                    //   groupValue: region,
                    //   title: Text(
                    //     'DKI Jakarta',
                    //     maxLines: 1,
                    //     overflow: TextOverflow.ellipsis,
                    //     style: textStyleCustom(
                    //         context, Colors.black, 12.sp, FontWeight.w400),
                    //   ),
                    //   onChanged: (val) {
                    //     _handleRadio(val.toString());
                    //   },
                    //   activeColor: primaryColor,
                    // ),
                    // RadioListTile(
                    //   dense: true,
                    //   value: 'non-dki',
                    //   groupValue: region,
                    //   title: Text(
                    //     'Non DKI Jakarta',
                    //     maxLines: 1,
                    //     overflow: TextOverflow.ellipsis,
                    //     style: textStyleCustom(
                    //         context, Colors.black, 12.sp, FontWeight.w400),
                    //   ),
                    //   onChanged: (val) {
                    //     _handleRadio(val.toString());
                    //   },
                    //   activeColor: primaryColor,
                    // ),
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
                // Padding(
                //   padding: EdgeInsets.only(
                //       left: 18.0,
                //       right: 18.0,
                //       bottom: GetPlatform.isAndroid ? 15 : 20),
                //   child: Row(
                //     children: [
                //       Expanded(
                //         child: InkWell(
                //           onTap: () {
                //             Navigator.pop(context);
                //           },
                //           child: ButtonRow(
                //               textBtn: 'BATAL',
                //               orangeColor1: const Color(0xFF838383),
                //               orangeColor2: const Color(0xFF838383),
                //               widthBtn: 40.w,
                //               heightBtn: 30.h),
                //         ),
                //       ),
                //       Expanded(
                //         child: InkWell(
                //           onTap: () async {
                //             // Get.toNamed('/order', arguments: {
                //             //     'ket': 'membeli',
                //             //     'title': 'Purchase Order',
                //             //     'region': region
                //             //   });
                //             debugPrint('region $region');
                //             // final box = GetStorage();

                //             // ignore: use_build_context_synchronously
                //             Navigator.pop(context);
                //           },
                //           child: ButtonRow(
                //               textBtn: 'OKE',
                //               orangeColor1: const Color(0xFF00B6F1),
                //               orangeColor2: const Color(0xFF0BA7D6),
                //               widthBtn: 40.w,
                //               heightBtn: 30.h),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}
