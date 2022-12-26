import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:herbani/controller/detail_order.dart';
import 'package:herbani/controller/info.dart';
import 'package:herbani/helper/money_formatter.dart';
import 'package:herbani/helper/textstyle_custom.dart';
import 'package:herbani/util/constant.dart';
import 'package:herbani/widget/appbar/appbar_default.dart';
import 'package:herbani/widget/loading/loading_app.dart';
import 'package:herbani/widget/message/empty_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Distributor extends StatefulWidget {
  const Distributor({Key? key}) : super(key: key);

  @override
  State<Distributor> createState() => _DistributorState();
}

class _DistributorState extends State<Distributor> {
  var title;
  List<dynamic> list = [];
  bool loading = false;
  @override
  void initState() {
    getDistributor();
    setState(() {
      title = Get.arguments['title'];
      
    });
    super.initState();
  }

  getDistributor() async {
    setState(() {
      loading = true;
    });
    final prefs = await SharedPreferences.getInstance();
    final String? listDistributor = prefs.getString('distributor');
    debugPrint('list $listDistributor');
    if(listDistributor != null){
      
      list.add(jsonDecode(listDistributor));
      debugPrint('list 2 $list');
    }else{
      setState(() {
        list = [];
      });
    }
    setState(() {
      loading = false;
    });
  }

  // final DetailOrderController list = Get.put(DetailOrderController());
// final InfoController info = Get.put(InfoController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDefault(
        title:
            title,
      ),
      body:Column(
          children: [
            Expanded(
              child: ScrollConfiguration(
                behavior: const ScrollBehavior(),
                child: 
                   AnimationLimiter(
                      child: 
                      loading ? 
                     const LoadingApp(topPaddingLoading: 0) :
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: list.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          final post = list[index];
                          return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 375),
                            child: SlideAnimation(
                              verticalOffset: 50.0,
                              child: FadeInAnimation(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 12.0, right: 12.0, top: 5.0),
                                  child: Column(
                                    children: [
                                      ListTile(
                                        title: Text(
                                          'Nama Perusahaan',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: textStyleCustom(
                                              context,
                                              Colors.black,
                                              12.sp,
                                              FontWeight.bold),
                                        ),
                                        subtitle: Text(
                                          ' ${post['nama_perusahaan']}',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: textStyleNormal(context),
                                        ),
                                      ),
                                      const Divider(
                                        color: Colors.blue,
                                      ),
                                      ListTile(
                                        title: Text(
                                          'PIC Distributor',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: textStyleCustom(
                                              context,
                                              Colors.black,
                                              12.sp,
                                              FontWeight.bold),
                                        ),
                                        subtitle: Text(
                                          '${post['pic_distributor']}',
                                          style: textStyleNormal(context),
                                        ),
                                      ),
                                      const Divider(
                                              color: Colors.blue,
                                            ),
                                      ListTile(
                                              title: Text(
                                                'Area',
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: textStyleCustom(
                                                    context,
                                                    Colors.black,
                                                    12.sp,
                                                    FontWeight.bold),
                                              ),
                                              subtitle: Text(
                                                '${post['area']}',
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: textStyleNormal(context),
                                              ),
                                            ),
                                      const Divider(
                                        color: Colors.blue,
                                      ),
                                      ListTile(
                                        title: Text(
                                          'Telepon',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: textStyleCustom(
                                              context,
                                              Colors.black,
                                              12.sp,
                                              FontWeight.bold),
                                        ),
                                        subtitle: Text(
                                          '${post['telp']}',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: textStyleNormal(context),
                                        ),
                                      ),
                                     const Divider(
                                              color: Colors.blue,
                                            ),
                                      ListTile(
                                              title: Text(
                                                'Alamat',
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: textStyleCustom(
                                                    context,
                                                    Colors.black,
                                                    12.sp,
                                                    FontWeight.bold),
                                              ),
                                              subtitle: Text(
                                          '${post['alamat']}',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: textStyleNormal(context),
                                        ),
                                            ),
                                     const Divider(
                                              color: Colors.blue,
                                            ),
                                      ListTile(
                                                                title: Text(
                                                                  'Provinsi',
                                                                  maxLines: 2,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: textStyleNormal(
                                                                      context),
                                                                ),
                                                                subtitle: Text(
                                                                  post['provinsi'] == null ||
                                                                              post['provinsi'] ==
                                                                                  ''
                                                                          ? 'Tidak ada data'
                                                                          : '${post['provinsi']['prov_name']}',
                                                                      
                                                                  maxLines: 2,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: textStyleNormal(
                                                                      context),
                                                                ),
                                                              ),
                                                              const Divider(
                                                                color:
                                                                    Colors.blue,
                                                              ),
                                                              ListTile(
                                                                title: Text(
                                                                  'Kota',
                                                                  maxLines: 2,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: textStyleNormal(
                                                                      context),
                                                                ),
                                                                subtitle:
                                                                    Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      post['kota'] == null || post['kota'] == ''
                                                                              ? 'Tidak ada data'
                                                                              : '${post['kota']['city_name']}',
                                                                         
                                                                      maxLines:
                                                                          2,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      style: textStyleNormal(
                                                                          context),
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          10.h,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              const Divider(
                                                                color:
                                                                    Colors.blue,
                                                              ),
                                                              ListTile(
                                                                title: Text(
                                                                  'Kelurahan',
                                                                  maxLines: 2,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: textStyleNormal(
                                                                      context),
                                                                ),
                                                                subtitle: Text(
                                                                   post['kelurahan'] == null ||
                                                                              post['kelurahan'] ==
                                                                                  ''
                                                                          ? 'Tidak ada data'
                                                                          : '${post['kelurahan']['subdis_name']}',
                                                                      
                                                                  maxLines: 2,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: textStyleNormal(
                                                                      context),
                                                                ),
                                                              ),
                                                              const Divider(
                                                                color:
                                                                    Colors.blue,
                                                              ),
                                                              ListTile(
                                                                title: Text(
                                                                  'Kecamatan',
                                                                  maxLines: 2,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: textStyleNormal(
                                                                      context),
                                                                ),
                                                                subtitle: Text(
                                                                  post['kecamatan'] == null ||
                                                                              post['kecamatan'] ==
                                                                                  ''
                                                                          ? 'Tidak ada data'
                                                                          : '${post['kecamatan']['dis_name']}',
                                                                      
                                                                  maxLines: 2,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: textStyleNormal(
                                                                      context),
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
                          );
                        },
                      ),
                    ),
                
              ),
            ),
          ],
        ),
    );
  }
}
