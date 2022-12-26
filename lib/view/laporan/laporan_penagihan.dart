// import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bootstrap/flutter_bootstrap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:herbani/controller/penagihan.dart';
import 'package:herbani/helper/function.dart';
import 'package:herbani/helper/money_formatter.dart';
import 'package:herbani/helper/textstyle_custom.dart';
import 'package:herbani/util/constant.dart';
import 'package:herbani/widget/appbar/appbar_default.dart';
import 'package:herbani/widget/loading/loading_app.dart';
import 'package:herbani/widget/message/empty_state.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class LaporanPenagihan extends StatefulWidget {
  const LaporanPenagihan({Key? key}) : super(key: key);

  @override
  State<LaporanPenagihan> createState() => _LaporanPenagihanState();
}

class _LaporanPenagihanState extends State<LaporanPenagihan> {
  @override
  void initState() {
    Get.put(PenagihanController()).getData();
    super.initState();
  }

  final PenagihanController list = Get.put(PenagihanController());
  // final HomeController home = Get.put(HomeController());
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  List<GlobalKey<ExpansionTileCardState>> card = [];

  void onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    list.onInit();
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
    return Obx(() => AbsorbPointer(
          absorbing: list.touch.value,
          child: Scaffold(
            appBar: const AppBarDefault(
              title: 'Laporan Penagihan',
            ),
            body: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 23.5, right: 23.5, top: 5.0),
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
                          hintStyle: textStyleCustom(
                              context, Colors.black, 12.sp, FontWeight.normal),
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
                  child: list.tapSearch.value == true && list.listSearch.isEmpty
                      ? const DataNotFound(message: 'Data tidak ditemukan')
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
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return AnimationConfiguration
                                          .staggeredList(
                                        position: index,
                                        duration:
                                            const Duration(milliseconds: 375),
                                        child: SlideAnimation(
                                          verticalOffset: 50.0,
                                          child: FadeInAnimation(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 12.0,
                                                  right: 12.0,
                                                  top: 5.0),
                                              child: Column(
                                                children: [
                                                  Card(
                                                    elevation: 1.0,
                                                    child: ExpansionTileCard(
                                                      elevation: 5.0,
                                                      duration: const Duration(
                                                          milliseconds: 500),
                                                      animateTrailing: true,
                                                      baseColor: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(10.0.r),
                                                      ),
                                                      title:
                                                          Transform.translate(
                                                        offset: const Offset(
                                                            -24, 0),
                                                        child: Column(
                                                          children: [
                                                            BootstrapRow(
                                                              children: <
                                                                  BootstrapCol>[
                                                                BootstrapCol(
                                                                  sizes:
                                                                      'col-lg-12',
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        list.listSearch.isEmpty
                                                                            ? '${list.listRecords[index]['nama_pembeli']}'
                                                                            : '${list.listSearch[index]['nama_pembeli']}',
                                                                        style: textStyleCustom(
                                                                            context,
                                                                            Colors.black,
                                                                            12.sp,
                                                                            FontWeight.bold),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 5.h,
                                                            ),
                                                            BootstrapRow(
                                                              children: <
                                                                  BootstrapCol>[
                                                                BootstrapCol(
                                                                  sizes:
                                                                      'col-lg-12',
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        list.listSearch.isEmpty
                                                                            ? '${list.listRecords[index]['alamat']}'
                                                                            : '${list.listSearch[index]['alamat']}',
                                                                        style: textStyleNormal(
                                                                            context),
                                                                      ),
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
                                                            const Divider(
                                                              color:
                                                                  Colors.blue,
                                                            ),
                                                            ListTile(
                                                              dense: true,
                                                              title: Text(
                                                                'Tanggal Penagihan',
                                                                maxLines: 2,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: textStyleCustom(
                                                                    context,
                                                                    Colors
                                                                        .black,
                                                                    12.sp,
                                                                    FontWeight
                                                                        .bold),
                                                              ),
                                                              subtitle: Text(
                                                                list.listSearch
                                                                        .isEmpty
                                                                    ? '${list.listRecords[index]['tgl_penagihan']}'
                                                                    : '${list.listSearch[index]['tgl_penagihan']}',
                                                                maxLines: 2,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style:
                                                                    textStyleNormal(
                                                                        context),
                                                              ),
                                                            ),
                                                            const Divider(
                                                              color:
                                                                  Colors.blue,
                                                            ),
                                                            ListTile(
                                                              title: Text(
                                                                'Total Tagihan',
                                                                maxLines: 2,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: textStyleCustom(
                                                                    context,
                                                                    Colors
                                                                        .black,
                                                                    12.sp,
                                                                    FontWeight
                                                                        .bold),
                                                              ),
                                                              subtitle:
                                                                  MoneyFormatter(
                                                                colorVal: Colors
                                                                    .black,
                                                                money: list
                                                                        .listSearch
                                                                        .isEmpty
                                                                    ? list
                                                                        .listRecords[
                                                                            index]
                                                                            [
                                                                            'total_tagihan']
                                                                        .toString()
                                                                    : list
                                                                        .listSearch[
                                                                            index]
                                                                            [
                                                                            'total_tagihan']
                                                                        .toString(),
                                                                typeStyle: '',
                                                              ),
                                                            ),
                                                            const Divider(
                                                              color:
                                                                  Colors.blue,
                                                            ),
                                                            ListTile(
                                                              title: Text(
                                                                'Nominal Pembayaran',
                                                                maxLines: 2,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: textStyleCustom(
                                                                    context,
                                                                    Colors
                                                                        .black,
                                                                    12.sp,
                                                                    FontWeight
                                                                        .bold),
                                                              ),
                                                              subtitle:
                                                                  MoneyFormatter(
                                                                colorVal: Colors
                                                                    .black,
                                                                money: list
                                                                        .listSearch
                                                                        .isEmpty
                                                                    ? list
                                                                        .listRecords[
                                                                            index]
                                                                            [
                                                                            'nominal_tagihan']
                                                                        .toString()
                                                                    : list
                                                                        .listSearch[
                                                                            index]
                                                                            [
                                                                            'nominal_tagihan']
                                                                        .toString(),
                                                                typeStyle: '',
                                                              ),
                                                            ),
                                                            const Divider(
                                                              color:
                                                                  Colors.blue,
                                                            ),
                                                            ListTile(
                                                              title: Text(
                                                                'Keterangan Penagihan',
                                                                maxLines: 5,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: textStyleCustom(
                                                                    context,
                                                                    Colors
                                                                        .black,
                                                                    12.sp,
                                                                    FontWeight
                                                                        .bold),
                                                              ),
                                                              subtitle: Text(
                                                                list.listSearch
                                                                        .isEmpty
                                                                    ? '${list.listRecords[index]['keterangan']}'
                                                                    : '${list.listSearch[index]['keterangan']}',
                                                                maxLines: 2,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style:
                                                                    textStyleNormal(
                                                                        context),
                                                              ),
                                                            ),
                                                            const Divider(
                                                              color:
                                                                  Colors.blue,
                                                            ),
                                                            ListTile(
                                                                title: Text(
                                                                  'File',
                                                                  maxLines: 2,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: textStyleCustom(
                                                                      context,
                                                                      Colors
                                                                          .black,
                                                                      12.sp,
                                                                      FontWeight
                                                                          .bold),
                                                                ),
                                                                subtitle:
                                                                    Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left:
                                                                          16.0,
                                                                      right:
                                                                          16.0,
                                                                      top: 8.0),
                                                                  child:
                                                                      Container(
                                                                    height:
                                                                        0.35.sh,
                                                                    width:
                                                                        330.w,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .all(
                                                                        Radius.circular(
                                                                            5.0.r),
                                                                      ),
                                                                      border:
                                                                          Border
                                                                              .all(
                                                                        color: const Color(
                                                                            0xFF00B6F1),
                                                                        width:
                                                                            2,
                                                                      ),
                                                                    ),
                                                                    child: Container(
                                                                        height: 0.35.sh,
                                                                        width: 330.w,
                                                                        color: Colors.white,
                                                                        child: CachedNetworkImage(
                                                                          imageUrl:
                                                                              "$urlPenagihan${list.listRecords[index]['file']}",
                                                                          imageBuilder: (context, imageProvider) =>
                                                                              Container(
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                                                                            ),
                                                                          ),
                                                                          placeholder: (context, url) =>
                                                                              const Center(child: CircularProgressIndicator()),
                                                                          errorWidget: (context, url, error) =>
                                                                              const Icon(Icons.error),
                                                                        )),
                                                                  ),
                                                                )),
                                                            const Divider(
                                                              color:
                                                                  Colors.blue,
                                                            ),
                                                            ListTile(
                                                              title: Text(
                                                                'Alamat Penagihan',
                                                                maxLines: 2,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: textStyleCustom(
                                                                    context,
                                                                    Colors
                                                                        .black,
                                                                    12.sp,
                                                                    FontWeight
                                                                        .bold),
                                                              ),
                                                              subtitle: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    list.listSearch
                                                                            .isEmpty
                                                                        ? '${list.listRecords[index]['alamat_penagihan']}'
                                                                        : '${list.listSearch[index]['alamat_penagihan']}',
                                                                    maxLines: 2,
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
                                                                  SizedBox(
                                                                    height:
                                                                        30.h,
                                                                    width: Get
                                                                        .size
                                                                        .width,
                                                                    child:
                                                                        ElevatedButton(
                                                                      style: ElevatedButton
                                                                          .styleFrom(
                                                                        backgroundColor:
                                                                            Colors.red,
                                                                        textStyle:
                                                                            textStyleButtonLogin(context),
                                                                      ),
                                                                      onPressed:
                                                                          () async {
                                                                        double
                                                                            lat =
                                                                            0.0;
                                                                        double
                                                                            lng =
                                                                            0.0;
                                                                        if (list
                                                                            .listSearch
                                                                            .isEmpty) {
                                                                          lat = double.parse(list.listRecords[index]
                                                                              [
                                                                              'lat_penagihan']);
                                                                          lng = double.parse(list.listRecords[index]
                                                                              [
                                                                              'lon_penagihan']);
                                                                        } else {
                                                                          lat = double.parse(list.listSearch[index]
                                                                              [
                                                                              'lat_penagihan']);
                                                                          lng = double.parse(list.listSearch[index]
                                                                              [
                                                                              'lon_penagihan']);
                                                                        }
                                                                        navigateTo(
                                                                            lat,
                                                                            lng);
                                                                      },
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        children: const [
                                                                          Text(
                                                                            'Buka Map',
                                                                          ),
                                                                          Icon(Icons
                                                                              .location_on),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            const Divider(
                                                              color:
                                                                  Colors.blue,
                                                            ),
                                                            SizedBox(
                                                              height: 10.h,
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
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                            padding: EdgeInsets.only(top: 5.0),
                                            child:
                                                Icon(Icons.refresh_outlined)),
                                      )
                                    ],
                                  ),
                                );
                              },
                              onEmpty: Center(
                                child: DataNotFound(
                                  message: list.messageEmpty.value.toString(),
                                ),
                              ),
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ));
  }
}
