import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bootstrap/flutter_bootstrap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:herbani/controller/customer.dart';
import 'package:herbani/controller/home.dart';
import 'package:herbani/helper/textstyle_custom.dart';
import 'package:herbani/util/constant.dart';
import 'package:herbani/widget/appbar/appbar_default.dart';
import 'package:herbani/widget/loading/loading_app.dart';
import 'package:herbani/widget/message/empty_state.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ListCustomer extends StatefulWidget {
  const ListCustomer({Key? key}) : super(key: key);

  @override
  State<ListCustomer> createState() => _ListCustomerState();
}

class _ListCustomerState extends State<ListCustomer> {
  @override
  void initState() {
    Get.put(CustomerController()).getData();
    super.initState();
  }

  final CustomerController list = Get.put(CustomerController());
  final HomeController home = Get.put(HomeController());
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
              title: 'List Customer',
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                final CustomerController customerController =
                    Get.put(CustomerController());
                customerController.provinsiController.value.clear();
                customerController.kotaController.value.clear();
                customerController.kelurahanController.value.clear();
                customerController.kecamatanController.value.clear();
                Get.toNamed('/create_customer');
              },
              backgroundColor: primaryColor,
              child: const Icon(
                Icons.person_add,
                color: Colors.white,
              ),
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
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 5.0,
                                                            bottom: 5.0),
                                                    child: Card(
                                                      elevation: 1.0,
                                                      child: ExpansionTileCard(
                                                        elevation: 5.0,
                                                        duration:
                                                            const Duration(
                                                                milliseconds:
                                                                    500),
                                                        animateTrailing: true,
                                                        baseColor: Colors.white,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                          Radius.circular(
                                                              10.0.r),
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
                                                                        'col-lg-6',
                                                                    child:
                                                                        Column(
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
                                                                              FontWeight.w500),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                height: 5.h,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        children: [
                                                          Column(
                                                            children: [
                                                              ListTile(
                                                                title: Text(
                                                                  'Jenis Cstomer',
                                                                  maxLines: 2,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: textStyleNormal(
                                                                      context),
                                                                ),
                                                                subtitle: Text(
                                                                  list.listSearch
                                                                          .isEmpty
                                                                      ? '${list.listRecords[index]['jenis_p']}'
                                                                      : '${list.listSearch[index]['jenis_p']}',
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
                                                                  'No Telepon',
                                                                  maxLines: 2,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: textStyleNormal(
                                                                      context),
                                                                ),
                                                                subtitle: Text(
                                                                  list.listSearch
                                                                          .isEmpty
                                                                      ? list.listRecords[index]['no_telp'] == null ||
                                                                              list.listRecords[index]['no_telp'] ==
                                                                                  ''
                                                                          ? ''
                                                                          : '${list.listRecords[index]['no_telp']}'
                                                                      : list.listSearch[index]['no_telp'] == null ||
                                                                              list.listSearch[index]['no_telp'] == ''
                                                                          ? ''
                                                                          : '${list.listSearch[index]['no_telp']}',
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
                                                                  'Alamat',
                                                                  maxLines: 5,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: textStyleNormal(
                                                                      context),
                                                                ),
                                                                subtitle: Text(
                                                                  list.listSearch
                                                                          .isEmpty
                                                                      ? '${list.listRecords[index]['alamat']}'
                                                                      : '${list.listSearch[index]['alamat']}',
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
                                                                  'Provinsi',
                                                                  maxLines: 2,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: textStyleNormal(
                                                                      context),
                                                                ),
                                                                subtitle: Text(
                                                                  list.listSearch
                                                                          .isEmpty
                                                                      ? list.listRecords[index]['prov_name'] == null ||
                                                                              list.listRecords[index]['prov_name'] ==
                                                                                  ''
                                                                          ? 'Tidak ada data'
                                                                          : '${list.listRecords[index]['prov_name']}'
                                                                      : list.listSearch[index]['prov_name'] == null ||
                                                                              list.listSearch[index]['prov_name'] == ''
                                                                          ? 'Tidak ada data'
                                                                          : '${list.listSearch[index]['prov_name']}',
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
                                                                      list.listSearch
                                                                              .isEmpty
                                                                          ? list.listRecords[index]['city_name'] == null || list.listRecords[index]['city_name'] == ''
                                                                              ? 'Tidak ada data'
                                                                              : '${list.listRecords[index]['city_name']}'
                                                                          : list.listSearch[index]['city_name'] == null || list.listSearch[index]['city_name'] == ''
                                                                              ? 'Tidak ada data'
                                                                              : '${list.listSearch[index]['city_name']}',
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
                                                                  list.listSearch
                                                                          .isEmpty
                                                                      ? list.listRecords[index]['subdis_name'] == null ||
                                                                              list.listRecords[index]['subdis_name'] ==
                                                                                  ''
                                                                          ? 'Tidak ada data'
                                                                          : '${list.listRecords[index]['subdis_name']}'
                                                                      : list.listSearch[index]['subdis_name'] == null ||
                                                                              list.listSearch[index]['subdis_name'] == ''
                                                                          ? 'Tidak ada data'
                                                                          : '${list.listSearch[index]['subdis_name']}',
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
                                                                  list.listSearch
                                                                          .isEmpty
                                                                      ? list.listRecords[index]['dis_name'] == null ||
                                                                              list.listRecords[index]['dis_name'] ==
                                                                                  ''
                                                                          ? 'Tidak ada data'
                                                                          : '${list.listRecords[index]['dis_name']}'
                                                                      : list.listSearch[index]['dis_name'] == null ||
                                                                              list.listSearch[index]['dis_name'] == ''
                                                                          ? 'Tidak ada data'
                                                                          : '${list.listSearch[index]['dis_name']}',
                                                                  maxLines: 2,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: textStyleNormal(
                                                                      context),
                                                                ),
                                                              ),
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
