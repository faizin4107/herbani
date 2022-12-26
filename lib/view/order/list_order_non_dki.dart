import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:herbani/controller/detail_order.dart';
import 'package:herbani/helper/money_formatter.dart';
import 'package:herbani/helper/textstyle_custom.dart';
import 'package:herbani/util/constant.dart';
import 'package:herbani/widget/appbar/appbar_default.dart';
import 'package:herbani/widget/loading/loading_app.dart';
import 'package:herbani/widget/message/empty_state.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ListOrderNonDki extends StatefulWidget {
  const ListOrderNonDki({
    Key? key,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ListOrderNonDkiState createState() => _ListOrderNonDkiState();
}

class _ListOrderNonDkiState extends State<ListOrderNonDki> {
  // ignore: prefer_typing_uninitialized_variables
  var region;
  // ignore: prefer_typing_uninitialized_variables
  var kodePo;
  // ignore: prefer_typing_uninitialized_variables
  var idPo;
  @override
  void initState() {
    setState(() {
      region = Get.arguments['region'];
      kodePo = Get.arguments['kode_po'];
      idPo = Get.arguments['id_po'];
    });
    Get.put(DetailOrderController()).getListOrderNonDki(idPo);
    super.initState();
  }

  List<dynamic>? listRecords = [];
  List<dynamic>? listFields = [];
  final DetailOrderController list = Get.put(DetailOrderController());
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const AppBarDefault(
        title: 'List Orderan',
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
              onPressed: () async {},
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Total Order',
                    ),
                  ),
                  Expanded(
                      child: Obx(
                    () => MoneyFormatter(
                      colorVal: Colors.white,
                      money: '${list.totalProduk}',
                      typeStyle: 'bold',
                    ),
                  )),
                ],
              ),
            ),
          )),
      body: Obx(
        () => SafeArea(
            child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 23.5, right: 23.5, top: 5.0),
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
                      child: list.obx(
                        (state) {
                          return AnimationLimiter(
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemCount: list.listSearch.isEmpty
                                  ? list.listRecords.length
                                  : list.listSearch.length,
                              itemBuilder: (BuildContext context, int i) {
                                return AnimationConfiguration.staggeredList(
                                  position: i,
                                  duration: const Duration(milliseconds: 375),
                                  child: SlideAnimation(
                                    verticalOffset: 50.0,
                                    child: FadeInAnimation(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 24.0,
                                            right: 24.0,
                                            top: 2.0,
                                            bottom: 5.0),
                                        child: Card(
                                            color: Colors.white,
                                            elevation: 5.0,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Column(
                                              children: [
                                                ListTile(
                                                  dense: true,
                                                  title: Text(
                                                    'Produk',
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: textStyleCustom(
                                                        context,
                                                        Colors.black,
                                                        12.sp,
                                                        FontWeight.bold),
                                                  ),
                                                  subtitle: Text(
                                                    list.listSearch.isEmpty
                                                        ? list.listRecords[i]
                                                                ['produk']
                                                                ['produk']
                                                            .toString()
                                                        : list.listSearch[i]
                                                                ['produk']
                                                                ['produk']
                                                            .toString(),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: textStyleNormal(
                                                        context),
                                                  ),
                                                ),
                                                // Divider(
                                                //   color: Colors.blue,
                                                // ),
                                                ListTile(
                                                  dense: true,
                                                  title: Text(
                                                    'Qty',
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: textStyleCustom(
                                                        context,
                                                        Colors.black,
                                                        12.sp,
                                                        FontWeight.bold),
                                                  ),
                                                  subtitle: Text(
                                                    list.listSearch.isEmpty
                                                        ? list.listRecords[i]
                                                                ['qty']
                                                            .toString()
                                                        : list.listSearch[i]
                                                                ['qty']
                                                            .toString(),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: textStyleNormal(
                                                        context),
                                                  ),
                                                ),

                                                ListTile(
                                                  dense: true,
                                                  title: Text(
                                                    'Harga Jual',
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: textStyleCustom(
                                                        context,
                                                        Colors.black,
                                                        12.sp,
                                                        FontWeight.bold),
                                                  ),
                                                  subtitle: MoneyFormatter(
                                                    colorVal: Colors.black,
                                                    money: list
                                                            .listSearch.isEmpty
                                                        ? list.listRecords[i]
                                                                ['produk']
                                                                ['harga_jual']
                                                            .toString()
                                                        : list.listSearch[i]
                                                                ['produk']
                                                                ['harga_jual']
                                                            .toString(),
                                                    typeStyle: '',
                                                  ),
                                                ),

                                                ListTile(
                                                  dense: true,
                                                  title: Text(
                                                    'Stok produk saat ini',
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: textStyleCustom(
                                                        context,
                                                        Colors.black,
                                                        12.sp,
                                                        FontWeight.bold),
                                                  ),
                                                  subtitle: Text(
                                                    list.listSearch.isEmpty
                                                        ? list.listRecords[i]
                                                                ['stok_barang']
                                                            .toString()
                                                        : list.listSearch[i]
                                                                ['stok_barang']
                                                            .toString(),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: textStyleNormal(
                                                        context),
                                                  ),
                                                ),
                                              ],
                                            )),
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
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                FailedRequest(
                                  message: error.toString(),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    list.getListOrderNonDki(idPo);
                                    list.getTotalOrderan(idPo, region);
                                  },
                                  child: const Padding(
                                      padding: EdgeInsets.only(top: 5.0),
                                      child: Icon(Icons.refresh_outlined)),
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
                      )),
            ),
          ],
        )),
      ),
    );
  }
}
