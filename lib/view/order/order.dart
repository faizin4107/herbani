import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bootstrap/flutter_bootstrap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
// import 'package:herbani/controller/home.dart';
import 'package:herbani/controller/order.dart';
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

class Order extends StatefulWidget {
  const Order({Key? key}) : super(key: key);

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  // ignore: prefer_typing_uninitialized_variables
  var ketPembelian;
  // ignore: prefer_typing_uninitialized_variables
  var title;

  // ignore: prefer_typing_uninitialized_variables
  var region;
  // ignore: prefer_typing_uninitialized_variables
  var level;
  @override
  void initState() {
    // final HomeController home = Get.put(HomeController());
    setState(() {
      title = Get.arguments['title'];
      ketPembelian = Get.arguments['ket'];
      region = Get.arguments['region'];
      level = Get.arguments['level'];
    });
    Get.put(OrderController()).getData(Get.arguments['ket'], level, region);
    super.initState();
  }

  final OrderController list = Get.put(OrderController());
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
                                                        Card(
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
                                                              child:
                                                               Column(
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
                                                                              MainAxisAlignment.start,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              list.listSearch.isEmpty ? '${list.listRecords[index]['nama_pembeli']}' : '${list.listSearch[index]['nama_pembeli']}',
                                                                              style: textStyleCustom(context, Colors.black, 12.sp, FontWeight.bold),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      BootstrapCol(
                                                                        sizes:
                                                                            'col-6',
                                                                        child:
                                                                            Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              list.listSearch.isEmpty ? '${list.listRecords[index]['progress_po']}' : '${list.listSearch[index]['progress_po']}',
                                                                              style: textStyleCustom(context, Colors.black, 12.sp, FontWeight.bold),
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
                                                                            'col-6',
                                                                        child:
                                                                            Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              list.listSearch.isEmpty ? '${list.listRecords[index]['tgl_po']}' : '${list.listSearch[index]['tgl_po']}',
                                                                              style: textStyleNormal(context),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      BootstrapCol(
                                                                        sizes:
                                                                            'col-6',
                                                                        child:
                                                                            Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            ketPembelian == 'membeli'
                                                                                ? Text(
                                                                                    list.listSearch.isEmpty ? '${list.listRecords[index]['jenis_transaksi']}' : '${list.listSearch[index]['jenis_transaksi']}',
                                                                                    style: textStyleNormal(context),
                                                                                  )
                                                                                : Container()
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
                                                                  ketPembelian ==
                                                                          'tidak_membeli'
                                                                      ? ListTile(
                                                                          title:
                                                                              Text(
                                                                            'Keterangan PO',
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
                                                                                ? '${list.listRecords[index]['ket_po']}'
                                                                                : '${list.listSearch[index]['ket_po']}',
                                                                            maxLines:
                                                                                2,
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            style:
                                                                                textStyleNormal(context),
                                                                          ),
                                                                        )
                                                                      : Container(),
                                                                  ketPembelian ==
                                                                          'membeli'
                                                                      ? const Divider(
                                                                          color:
                                                                              Colors.blue,
                                                                        )
                                                                      : Container(),
                                                                  ketPembelian ==
                                                                          'membeli'
                                                                      ? ListTile(
                                                                          title:
                                                                              Text(
                                                                            'Total Tagihan',
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
                                                                              MoneyFormatter(
                                                                            colorVal:
                                                                                Colors.black,
                                                                            money: list.listSearch.isEmpty
                                                                                ? list.listRecords[index]['total_tagihan'].toString()
                                                                                : list.listSearch[index]['total_tagihan'].toString(),
                                                                            typeStyle:
                                                                                '',
                                                                          ),
                                                                        )
                                                                      : Container(),
                                                                  ketPembelian ==
                                                                          'membeli'
                                                                      ? const Divider(
                                                                          color:
                                                                              Colors.blue,
                                                                        )
                                                                      : Container(),
                                                                  ketPembelian ==
                                                                          'membeli'
                                                                      ? ListTile(
                                                                          title:
                                                                              Text(
                                                                            'Tempo Kredit',
                                                                            maxLines:
                                                                                5,
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
                                                                                ? '${list.listRecords[index]['tempo_kredit']}'
                                                                                : '${list.listSearch[index]['tempo_kredit']}',
                                                                            maxLines:
                                                                                2,
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            style:
                                                                                textStyleNormal(context),
                                                                          ),
                                                                        )
                                                                      : Container(),
                                                                  ketPembelian ==
                                                                          'membeli'
                                                                      ? const Divider(
                                                                          color:
                                                                              Colors.blue,
                                                                        )
                                                                      : Container(),
                                                                  ketPembelian ==
                                                                          'membeli'
                                                                      ? ListTile(
                                                                          title:
                                                                              Text(
                                                                            'Diskon',
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
                                                                                ? '${list.listRecords[index]['diskon']} %'
                                                                                : '${list.listSearch[index]['diskon']} %',
                                                                            maxLines:
                                                                                2,
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            style:
                                                                                textStyleNormal(context),
                                                                          ),
                                                                        )
                                                                      : Container(),
                                                                  ketPembelian ==
                                                                          'membeli'
                                                                      ? const Divider(
                                                                          color:
                                                                              Colors.blue,
                                                                        )
                                                                      : Container(),
                                                                  ketPembelian ==
                                                                          'membeli'
                                                                      ? ListTile(
                                                                          title:
                                                                              Text(
                                                                            'Tanggal Order',
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
                                                                                ? '${list.listRecords[index]['tgl_order']}'
                                                                                : '${list.listSearch[index]['tgl_order']}',
                                                                            maxLines:
                                                                                2,
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            style:
                                                                                textStyleNormal(context),
                                                                          ),
                                                                        )
                                                                      : Container(),
                                                                  ketPembelian ==
                                                                          'membeli'
                                                                      ? const Divider(
                                                                          color:
                                                                              Colors.blue,
                                                                        )
                                                                      : Container(),
                                                                  ketPembelian ==
                                                                          'membeli'
                                                                      ? ListTile(
                                                                          title:
                                                                              Text(
                                                                            'Tanggal Selesai',
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
                                                                                ? '${list.listRecords[index]['tgl_selesai']}'
                                                                                : '${list.listSearch[index]['tgl_selesai']}',
                                                                            maxLines:
                                                                                2,
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            style:
                                                                                textStyleNormal(context),
                                                                          ),
                                                                        )
                                                                      : Container(),
                                                                  const Divider(
                                                                    color: Colors
                                                                        .blue,
                                                                  ),
                                                                  ListTile(
                                                                    title: Text(
                                                                      'Lokasi',
                                                                      maxLines:
                                                                          2,
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
                                                                              ? '${list.listRecords[index]['alamat']}'
                                                                              : '${list.listSearch[index]['alamat']}',
                                                                          maxLines:
                                                                              2,
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          style:
                                                                              textStyleNormal(context),
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              10.h,
                                                                        ),
                                                                        level ==
                                                                                'kolektor'
                                                                            ? SizedBox(
                                                                                height: 30.h,
                                                                                width: Get.size.width,
                                                                                child: ElevatedButton(
                                                                                  style: ElevatedButton.styleFrom(
                                                                                    backgroundColor: Colors.red,
                                                                                    textStyle: textStyleButtonLogin(context),
                                                                                  ),
                                                                                  onPressed: () async {
                                                                                    //     MapUtils.openMap(-3.823216,-38.481700);
                                                                                    // Get.toNamed(
                                                                                    //     '/tracking_location');
                                                                                    double lat = 0.0;
                                                                                    double lng = 0.0;
                                                                                    if (list.listSearch.isEmpty) {
                                                                                      lat = double.parse(list.listRecords[index]['lat']);
                                                                                      lng = double.parse(list.listRecords[index]['lon']);
                                                                                    } else {
                                                                                      lat = double.parse(list.listSearch[index]['lat']);
                                                                                      lng = double.parse(list.listSearch[index]['lon']);
                                                                                    }
                                                                                    navigateTo(lat, lng);
                                                                                  },
                                                                                  child: Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                                    children: const [
                                                                                      Text(
                                                                                        'Buka Map',
                                                                                      ),
                                                                                      Icon(Icons.location_on),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              )
                                                                            : Container()
                                                                      ],
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
                                                                  level ==
                                                                          'sales'
                                                                      ? ketPembelian ==
                                                                              'membeli'
                                                                          ? Row(
                                                                              children: [
                                                                                Expanded(
                                                                                    child: Padding(
                                                                                  padding: const EdgeInsets.all(8.0),
                                                                                  child: SizedBox(
                                                                                    height: 30.h,
                                                                                    width: Get.size.width,
                                                                                    child: ElevatedButton(
                                                                                      style: ElevatedButton.styleFrom(
                                                                                        backgroundColor: Colors.blue,
                                                                                        textStyle: textStyleButtonLogin(context),
                                                                                      ),
                                                                                      onPressed: () async {
                                                                                        Get.toNamed('/detail_order', arguments: {
                                                                                          'id_po': list.listSearch.isEmpty ? list.listRecords[index]['id_po'] : list.listSearch[index]['id_po'],
                                                                                          'ket': ketPembelian,
                                                                                          'region': region
                                                                                        });
                                                                                      },
                                                                                      child: const Text(
                                                                                        'Detail',
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                )),
                                                                                Expanded(
                                                                                    child: Padding(
                                                                                  padding: const EdgeInsets.all(8.0),
                                                                                  child: SizedBox(
                                                                                    height: 30.h,
                                                                                    width: Get.size.width,
                                                                                    child: ElevatedButton(
                                                                                      style: ElevatedButton.styleFrom(
                                                                                        backgroundColor: primaryColor,
                                                                                        textStyle: textStyleButtonLogin(context),
                                                                                      ),
                                                                                      onPressed: () async {
                                                                                        Get.toNamed('/list_order', arguments: {
                                                                                          'id_po': list.listSearch.isEmpty ? list.listRecords[index]['id_po'] : list.listSearch[index]['id_po'],
                                                                                          'kode_po': list.listSearch.isEmpty ? list.listRecords[index]['kode_po'] : list.listSearch[index]['kode_po'],
                                                                                          'region': region
                                                                                        });
                                                                                      },
                                                                                      child: const Text(
                                                                                        'List Orderan',
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                )),
                                                                              ],
                                                                            )
                                                                          : Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: SizedBox(
                                                                                height: 30.h,
                                                                                width: Get.size.width,
                                                                                child: ElevatedButton(
                                                                                  style: ElevatedButton.styleFrom(
                                                                                    backgroundColor: Colors.blue,
                                                                                    textStyle: textStyleButtonLogin(context),
                                                                                  ),
                                                                                  onPressed: () async {
                                                                                    // ignore: prefer_typing_uninitialized_variables
                                                                                    var idPesanan;
                                                                                    idPesanan = list.listSearch.isEmpty ? list.listRecords[index]['id_po'] : list.listSearch[index]['id_po'];
                                                                                    Get.toNamed('/detail_order', arguments: {
                                                                                      'id_po': idPesanan,
                                                                                      'ket': ketPembelian,
                                                                                      'region': region
                                                                                    });
                                                                                    debugPrint('order ${list.listRecords[index]['id_po']}');
                                                                                  },
                                                                                  child: const Text(
                                                                                    'Detail',
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            )
                                                                      : level ==
                                                                              'Delivery'
                                                                          ? ketPembelian == 'membeli'
                                                                              ? Row(
                                                                                  children: [
                                                                                    Expanded(
                                                                                        child: Padding(
                                                                                      padding: const EdgeInsets.all(8.0),
                                                                                      child: SizedBox(
                                                                                        height: 30.h,
                                                                                        width: Get.size.width,
                                                                                        child: ElevatedButton(
                                                                                          style: ElevatedButton.styleFrom(
                                                                                            backgroundColor: Colors.blue,
                                                                                            textStyle: textStyleButtonLogin(context),
                                                                                          ),
                                                                                          onPressed: () async {
                                                                                            Get.toNamed('/detail_order', arguments: {
                                                                                              'id_pesanan': list.listSearch.isEmpty ? list.listRecords[index]['id_pesanan'] : list.listSearch[index]['id_pesanan'],
                                                                                              'ket': ketPembelian
                                                                                            });
                                                                                          },
                                                                                          child: const Text(
                                                                                            'Detail',
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    )),
                                                                                    Expanded(
                                                                                        child: Padding(
                                                                                      padding: const EdgeInsets.all(8.0),
                                                                                      child: SizedBox(
                                                                                        height: 30.h,
                                                                                        width: Get.size.width,
                                                                                        child: ElevatedButton(
                                                                                          style: ElevatedButton.styleFrom(
                                                                                            backgroundColor: primaryColor,
                                                                                            textStyle: textStyleButtonLogin(context),
                                                                                          ),
                                                                                          onPressed: () async {
                                                                                            Get.toNamed('/list_order', arguments: {
                                                                                              'id_pesanan': list.listSearch.isEmpty ? list.listRecords[index]['id_pesanan'] : list.listSearch[index]['id_pesanan']
                                                                                            });
                                                                                          },
                                                                                          child: const Text(
                                                                                            'Orderan',
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    )),
                                                                                    Expanded(
                                                                                        child: Padding(
                                                                                      padding: const EdgeInsets.all(8.0),
                                                                                      child: SizedBox(
                                                                                        height: 30.h,
                                                                                        width: Get.size.width,
                                                                                        child: ElevatedButton(
                                                                                          style: ElevatedButton.styleFrom(
                                                                                            backgroundColor: Colors.grey,
                                                                                            textStyle: textStyleButtonLogin(context),
                                                                                          ),
                                                                                          onPressed: () async {
                                                                                            var statusPo = list.listSearch.isEmpty ? list.listRecords[index]['status_po'] : list.listSearch[index]['status_po'];
                                                                                            if (statusPo == 'dikirim') {
                                                                                              return orangeDialog(context, 'Pesanan sedang dalam pengiriman', AlertType.info);
                                                                                            } else if (statusPo == 'selesai') {
                                                                                              return orangeDialog(context, 'Pesanan telah selesai', AlertType.info);
                                                                                            }
                                                                                          },
                                                                                          child: const Text(
                                                                                            'Kirim',
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    )),
                                                                                  ],
                                                                                )
                                                                              : Container()
                                                                          : Row(
                                                                              children: [
                                                                                Expanded(
                                                                                    child: Padding(
                                                                                  padding: const EdgeInsets.all(8.0),
                                                                                  child: SizedBox(
                                                                                    height: 30.h,
                                                                                    width: Get.size.width,
                                                                                    child: ElevatedButton(
                                                                                      style: ElevatedButton.styleFrom(
                                                                                        backgroundColor: Colors.blue,
                                                                                        textStyle: textStyleButtonLogin(context),
                                                                                      ),
                                                                                      onPressed: () async {
                                                                                        Get.toNamed('/detail_order', arguments: {
                                                                                          'id_pesanan': list.listSearch.isEmpty ? list.listRecords[index]['id_pesanan'] : list.listSearch[index]['id_pesanan'],
                                                                                          'ket': ketPembelian
                                                                                        });
                                                                                      },
                                                                                      child: const Text(
                                                                                        'Detail',
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                )),
                                                                                Expanded(
                                                                                    child: Padding(
                                                                                  padding: const EdgeInsets.all(8.0),
                                                                                  child: SizedBox(
                                                                                    height: 30.h,
                                                                                    width: Get.size.width,
                                                                                    child: ElevatedButton(
                                                                                      style: ElevatedButton.styleFrom(
                                                                                        backgroundColor: primaryColor,
                                                                                        textStyle: textStyleButtonLogin(context),
                                                                                      ),
                                                                                      onPressed: () async {
                                                                                        Get.toNamed('/list_order', arguments: {
                                                                                          'id_pesanan': list.listSearch.isEmpty ? list.listRecords[index]['id_pesanan'] : list.listSearch[index]['id_pesanan']
                                                                                        });
                                                                                      },
                                                                                      child: const Text(
                                                                                        'Orderan',
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                )),
                                                                                Expanded(
                                                                                    child: Padding(
                                                                                  padding: const EdgeInsets.all(8.0),
                                                                                  child: SizedBox(
                                                                                    height: 30.h,
                                                                                    width: Get.size.width,
                                                                                    child: ElevatedButton(
                                                                                      style: ElevatedButton.styleFrom(
                                                                                        backgroundColor: Colors.grey,
                                                                                        textStyle: textStyleButtonLogin(context),
                                                                                      ),
                                                                                      onPressed: () async {
                                                                                        var statusPo = list.listSearch.isEmpty ? list.listRecords[index]['status_po'] : list.listSearch[index]['status_po'];
                                                                                        if (statusPo == 'dikirim') {
                                                                                          return orangeDialog(context, 'Pesanan sedang dalam pengiriman', AlertType.info);
                                                                                        } else if (statusPo == 'selesai') {
                                                                                          return orangeDialog(context, 'Pesanan telah selesai', AlertType.info);
                                                                                        } else {}
                                                                                      },
                                                                                      child: const Text(
                                                                                        'Tagih',
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                )),
                                                                              ],
                                                                            )
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
                                                list.getData(
                                                    Get.arguments['ket'],
                                                    level,
                                                    region);
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
