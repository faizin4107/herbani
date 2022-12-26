import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bootstrap/flutter_bootstrap.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:herbani/controller/form.dart';
// import 'package:herbani/controller/home.dart';
// import 'package:herbani/controller/order.dart';
import 'package:herbani/controller/retur.dart';
import 'package:herbani/helper/alert_custom.dart';
import 'package:herbani/helper/function.dart';
import 'package:herbani/helper/money_formatter.dart';
import 'package:herbani/helper/textstyle_custom.dart';
import 'package:herbani/util/constant.dart';
import 'package:herbani/widget/appbar/appbar_default.dart';
import 'package:herbani/widget/loading/loading_app.dart';
import 'package:herbani/widget/message/empty_state.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Retur extends StatefulWidget {
  const Retur({Key? key}) : super(key: key);

  @override
  State<Retur> createState() => _ReturState();
}

class _ReturState extends State<Retur> {
  // ignore: prefer_typing_uninitialized_variables
  var title;

  @override
  void initState() {
    // final HomeController home = Get.put(HomeController());
    setState(() {
      title = Get.arguments['title'];
      // ketPembelian = Get.arguments['ket'];
      // region = Get.arguments['region'];
      // level = Get.arguments['level'];
    });
    Get.put(ReturController()).getData();
    super.initState();
  }

  final ReturController list = Get.put(ReturController());
  // final HomeController home = Get.put(HomeController());
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  List<GlobalKey<ExpansionTileCardState>> card = [];

  void onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    list.onInit();
    Get.put(ReturController()).getData();
    _refreshController.refreshToIdle();
    _refreshController.resetNoData();
    _refreshController.refreshCompleted();
  }

  void onLoading() async {
    await Future.delayed(const Duration(milliseconds: 500));
    for (int i = list.currentMax.value; i < list.currentMax.value + 20; i++) {
      if (list.listSearch.isEmpty) {
        if (list.listRecords.length < list.records.length) {
          list.listRecords.add(list.records[i - 1]);
        } else {
          list.currentMax.value = 20;
          if (mounted) setState(() {});
          return _refreshController.loadNoData();
        }
      } else {
        if (list.listSearch.length < list.records.length) {
          list.listSearch.add(list.records[i - 1]);
        } else {
          list.currentMax.value = 20;
          if (mounted) setState(() {});
          return _refreshController.loadNoData();
        }
      }
    }
    list.currentMax.value = list.currentMax.value + 20;
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.back(result: 'true');
        return true;
      },
      child: Obx(() => AbsorbPointer(
            absorbing: list.touch.value,
            child: Scaffold(
              appBar: AppBarDefault(
                title: '$title',
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () async {
                  EasyLoading.show(status: 'Memuat...');
                  await Get.put(FormController()).getPreorder();

                  final FormController form = Get.put(FormController());

                  if (form.listPreorder.isNotEmpty) {
                    EasyLoading.dismiss();
                    Get.toNamed('/form_retur');
                  } else {
                    EasyLoading.dismiss();
                    return EasyLoading.showInfo(
                        'Data preorder masih kosong, silahkan lakukan preorder terlebih dahulu');
                  }
                },
                backgroundColor: primaryColor,
                child: const Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
              ),
              body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 23.5, right: 23.5, top: 5.0),
                    child: Card(
                      color: Colors.white,
                      elevation: 1.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      child: ListTile(
                        leading: Icon(
                          Icons.search,
                          color: Colors.blue[900],
                        ),
                        title: TextField(
                          controller: list.searchController.value,
                          onChanged: list.onsearch,
                          autofocus: false,
                          decoration: InputDecoration(
                            hintText: "Cari",
                            border: InputBorder.none,
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: -20),
                            hintStyle: textStyleCustom(context, Colors.black,
                                12.sp, FontWeight.normal),
                          ),
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            list.searchController.value.clear();
                            list.onsearch('');
                            FocusScope.of(context).requestFocus(FocusNode());
                            list.setTapSearch(false);
                          },
                          icon: Icon(
                            Icons.clear,
                            color: Colors.blue,
                            size: 18.0.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child:
                        list.tapSearch.value == true && list.listSearch.isEmpty
                            ? const DataNotFound(
                                message: 'Data tidak ditemukan')
                            : ScrollConfiguration(
                                behavior: const ScrollBehavior(),
                                child: SmartRefresher(
                                  enablePullDown: true,
                                  enablePullUp: true,
                                  controller: _refreshController,
                                  onLoading: onLoading,
                                  onRefresh: onRefresh,
                                  child: list.obx(
                                    (data) {
                                      return AnimationLimiter(
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: list.listSearch.isEmpty
                                              ? list.listRecords.length
                                              : list.listSearch.length,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return AnimationConfiguration
                                                .staggeredList(
                                              position: index,
                                              duration: const Duration(
                                                  milliseconds: 375),
                                              child: SlideAnimation(
                                                verticalOffset: 50.0,
                                                child: FadeInAnimation(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 12.0,
                                                            right: 12.0,
                                                            top: 5.0),
                                                    child: Column(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 5.0,
                                                                  bottom: 5.0),
                                                          child: Card(
                                                            elevation: 1.0,
                                                            child:
                                                                ExpansionTileCard(
                                                              elevation: 5.0,
                                                              duration:
                                                                  const Duration(
                                                                      milliseconds:
                                                                          500),
                                                              animateTrailing:
                                                                  true,
                                                              baseColor:
                                                                  Colors.white,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .all(
                                                                Radius.circular(
                                                                    10.0.r),
                                                              ),
                                                              title: Transform
                                                                  .translate(
                                                                offset:
                                                                    const Offset(
                                                                        -24, 0),
                                                                child: Column(
                                                                  children: [
                                                                    BootstrapRow(
                                                                      children: <
                                                                          BootstrapCol>[
                                                                        BootstrapCol(
                                                                          sizes:
                                                                              'col-lg-12',
                                                                          child:
                                                                              Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Text(
                                                                                list.listSearch.isEmpty ? '${list.listRecords[index]['preorder']['kode']}' : '${list.listSearch[index]['preorder']['preorder']}',
                                                                                style: textStyleCustom(context, Colors.black, 12.sp, FontWeight.bold),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          5.h,
                                                                    ),
                                                                    BootstrapRow(
                                                                      children: <
                                                                          BootstrapCol>[
                                                                        BootstrapCol(
                                                                          sizes:
                                                                              'col-lg-12',
                                                                          child:
                                                                              Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Text(
                                                                                list.listSearch.isEmpty ? '${list.listRecords[index]['keterangan']}' : '${list.listSearch[index]['keterangan']}',
                                                                                style: textStyleNormal(context),
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              children: [
                                                                Column(
                                                                  children: [
                                                                    ListTile(
                                                                      title:
                                                                          Text(
                                                                        'Tanggal Pengajuan Retur',
                                                                        maxLines:
                                                                            2,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        style: textStyleCustom(
                                                                            context,
                                                                            Colors.black,
                                                                            12.sp,
                                                                            FontWeight.bold),
                                                                      ),
                                                                      subtitle:
                                                                          Text(
                                                                        list.listSearch.isEmpty
                                                                            ? '${list.listRecords[index]['tanggal']}'
                                                                            : '${list.listSearch[index]['tanggal']}',
                                                                        maxLines:
                                                                            2,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        style: textStyleNormal(
                                                                            context),
                                                                      ),
                                                                    ),
                                                                    const Divider(
                                                                      color: Colors
                                                                          .blue,
                                                                    ),
                                                                    ListTile(
                                                                      title:
                                                                          Text(
                                                                        'Catatan Sales',
                                                                        maxLines:
                                                                            2,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        style: textStyleCustom(
                                                                            context,
                                                                            Colors.black,
                                                                            12.sp,
                                                                            FontWeight.bold),
                                                                      ),
                                                                      subtitle:
                                                                          Text(
                                                                        list.listSearch.isEmpty
                                                                            ? '${list.listRecords[index]['catatan']}'
                                                                            : '${list.listSearch[index]['catatan']}',
                                                                        maxLines:
                                                                            2,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        style: textStyleNormal(
                                                                            context),
                                                                      ),
                                                                    ),
                                                                    list.listRecords[index]['alasan'] !=
                                                                            ''
                                                                        ? const Divider(
                                                                            color:
                                                                                Colors.blue,
                                                                          )
                                                                        : Container(),
                                                                    list.listRecords[index]['alasan'] !=
                                                                            ''
                                                                        ? ListTile(
                                                                            title:
                                                                                Text(
                                                                              'Keterangan dari admin',
                                                                              maxLines: 2,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              style: textStyleCustom(context, Colors.black, 12.sp, FontWeight.bold),
                                                                            ),
                                                                            subtitle:
                                                                                Text(
                                                                              list.listSearch.isEmpty ? '${list.listRecords[index]['alasan']}' : '${list.listSearch[index]['alasan']}',
                                                                              maxLines: 2,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              style: textStyleNormal(context),
                                                                            ),
                                                                          )
                                                                        : Container(),
                                                                    const Divider(
                                                                      color: Colors
                                                                          .blue,
                                                                    ),
                                                                    ListTile(
                                                                      title:
                                                                          Text(
                                                                        'Customer',
                                                                        maxLines:
                                                                            2,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        style: textStyleCustom(
                                                                            context,
                                                                            Colors.black,
                                                                            12.sp,
                                                                            FontWeight.bold),
                                                                      ),
                                                                      subtitle:
                                                                          Text(
                                                                        list.listSearch.isEmpty
                                                                            ? '${list.listRecords[index]['preorder']['customer']['nama_pembeli']}'
                                                                            : '${list.listSearch[index]['preorder']['customer']['nama_pembeli']}',
                                                                        maxLines:
                                                                            2,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        style: textStyleNormal(
                                                                            context),
                                                                      ),
                                                                    ),
                                                                    const Divider(
                                                                      color: Colors
                                                                          .blue,
                                                                    ),
                                                                    ListTile(
                                                                      title:
                                                                          Text(
                                                                        'Distributor',
                                                                        maxLines:
                                                                            2,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        style: textStyleCustom(
                                                                            context,
                                                                            Colors.black,
                                                                            12.sp,
                                                                            FontWeight.bold),
                                                                      ),
                                                                      subtitle:
                                                                          Text(
                                                                        list.listSearch.isEmpty
                                                                            ? '${list.listRecords[index]['preorder']['distributor']['nama_perusahaan']}'
                                                                            : '${list.listSearch[index]['preorder']['distributor']['nama_perusahaan']}',
                                                                        maxLines:
                                                                            2,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        style: textStyleNormal(
                                                                            context),
                                                                      ),
                                                                    ),
                                                                    const Divider(
                                                                      color: Colors
                                                                          .blue,
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          10.h,
                                                                    ),
                                                                    Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              8.0),
                                                                      child:
                                                                          SizedBox(
                                                                        height:
                                                                            30.h,
                                                                        width: Get
                                                                            .size
                                                                            .width,
                                                                        child:
                                                                            ElevatedButton(
                                                                          style:
                                                                              ElevatedButton.styleFrom(
                                                                            backgroundColor:
                                                                                primaryColor,
                                                                            textStyle:
                                                                                textStyleButtonLogin(context),
                                                                          ),
                                                                          onPressed:
                                                                              () async {
                                                                            debugPrint('statement ${list.listRecords[index]['kode']}');
                                                                            Get.toNamed('/list_retur_non_dki', arguments: {
                                                                              'id_retur': list.listSearch.isEmpty ? list.listRecords[index]['id'] : list.listSearch[index]['id'],

                                                                              // 'region': region
                                                                            });
                                                                          },
                                                                          child:
                                                                              const Text(
                                                                            'List Retur Produk',
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    },
                                    onLoading: const LoadingApp(
                                      topPaddingLoading: 0,
                                    ),
                                    onError: (error) {
                                      return Center(
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
                                                list.getData();
                                              },
                                              child: const Padding(
                                                  padding:
                                                      EdgeInsets.only(top: 5.0),
                                                  child: Icon(
                                                      Icons.refresh_outlined)),
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                    onEmpty: Center(
                                      child: DataNotFound(
                                        message:
                                            list.messageEmpty.value.toString(),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
