import 'package:cached_network_image/cached_network_image.dart';
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

class DetailOrderNonDki extends StatefulWidget {
  const DetailOrderNonDki({Key? key}) : super(key: key);

  @override
  State<DetailOrderNonDki> createState() => _DetailOrderNonDkiState();
}

class _DetailOrderNonDkiState extends State<DetailOrderNonDki> {
  // ignore: prefer_typing_uninitialized_variables
  var ketPembelian;
  // ignore: prefer_typing_uninitialized_variables
  var idPesanan;
  // ignore: prefer_typing_uninitialized_variables
  var region;

  @override
  void initState() {
    setState(() {
      ketPembelian = Get.arguments['ket'];
      idPesanan = Get.arguments['id_po'];
      region = Get.arguments['region'];
    });
    Get.put(DetailOrderController()).getData(idPesanan, ketPembelian);
    super.initState();
  }

  final DetailOrderController list = Get.put(DetailOrderController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDefault(
        title:
            ketPembelian == 'membeli' ? 'Detail Orderan' : 'Detail Kunjungan',
      ),
      body: Obx(
        () => Column(
          children: [
            Expanded(
              child: ScrollConfiguration(
                behavior: const ScrollBehavior(),
                child: list.obx(
                  (data) {
                    return AnimationLimiter(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: list.listSearch.isEmpty
                            ? list.listRecords.length
                            : list.listSearch.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
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
                                          'Nama Customer',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: textStyleCustom(
                                              context,
                                              Colors.black,
                                              12.sp,
                                              FontWeight.bold),
                                        ),
                                        subtitle: Text(
                                          ' ${list.listRecords[index]['customer']['nama_pembeli']}',
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
                                          ketPembelian == 'membeli'
                                              ? 'Tanggal PO'
                                              : 'Waktu',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: textStyleCustom(
                                              context,
                                              Colors.black,
                                              12.sp,
                                              FontWeight.bold),
                                        ),
                                        subtitle: Text(
                                          ketPembelian == 'membeli'
                                              ? '${list.listRecords[index]['tgl_po']}'
                                              : '${list.listRecords[index]['waktu']}',
                                          style: textStyleNormal(context),
                                        ),
                                      ),
                                      ketPembelian == 'tidak_membeli'
                                          ? const Divider(
                                              color: Colors.blue,
                                            )
                                          : Container(),
                                      ketPembelian == 'tidak_membeli'
                                          ? ListTile(
                                              title: Text(
                                                'Keterangan PO',
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: textStyleCustom(
                                                    context,
                                                    Colors.black,
                                                    12.sp,
                                                    FontWeight.bold),
                                              ),
                                              subtitle: Text(
                                                '${list.listRecords[index]['ket']}',
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: textStyleNormal(context),
                                              ),
                                            )
                                          : Container(),
                                      ketPembelian == 'membeli'
                                          ? const Divider(
                                              color: Colors.blue,
                                            )
                                          : Container(),
                                      ketPembelian == 'membeli'
                                          ? ListTile(
                                              title: Text(
                                                'Progress PO',
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: textStyleCustom(
                                                    context,
                                                    Colors.black,
                                                    12.sp,
                                                    FontWeight.bold),
                                              ),
                                              subtitle: Text(
                                                '${list.listRecords[index]['progress_po']}',
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: textStyleNormal(context),
                                              ),
                                            )
                                          : Container(),
                                      ketPembelian == 'membeli'
                                          ? const Divider(
                                              color: Colors.blue,
                                            )
                                          : Container(),
                                      ketPembelian == 'membeli'
                                          ? ListTile(
                                              title: Text(
                                                'Total Tagihan',
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: textStyleCustom(
                                                    context,
                                                    Colors.black,
                                                    12.sp,
                                                    FontWeight.bold),
                                              ),
                                              subtitle: MoneyFormatter(
                                                colorVal: Colors.black,
                                                money: list.listRecords[index]
                                                        ['total_tagihan']
                                                    .toString(),
                                                typeStyle: '',
                                              ),
                                            )
                                          : Container(),
                                      ketPembelian == 'membeli'
                                          ? const Divider(
                                              color: Colors.blue,
                                            )
                                          : Container(),
                                      ketPembelian == 'membeli'
                                          ? ListTile(
                                              title: Text(
                                                'Jenis Transaksi',
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: textStyleCustom(
                                                    context,
                                                    Colors.black,
                                                    12.sp,
                                                    FontWeight.bold),
                                              ),
                                              subtitle: Text(
                                                '${list.listRecords[index]['jenis_transaksi']}',
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: textStyleNormal(context),
                                              ),
                                            )
                                          : Container(),
                                      ketPembelian == 'membeli'
                                          ? const Divider(
                                              color: Colors.blue,
                                            )
                                          : Container(),
                                      ketPembelian == 'membeli'
                                          ? ListTile(
                                              title: Text(
                                                'Tempo Kredit',
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: textStyleCustom(
                                                    context,
                                                    Colors.black,
                                                    12.sp,
                                                    FontWeight.bold),
                                              ),
                                              subtitle: Text(
                                                '${list.listRecords[index]['tempo_kredit']} hari',
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: textStyleNormal(context),
                                              ),
                                            )
                                          : Container(),
                                      ketPembelian == 'membeli'
                                          ? const Divider(
                                              color: Colors.blue,
                                            )
                                          : Container(),
                                      ketPembelian == 'membeli'
                                          ? ListTile(
                                              title: Text(
                                                'Jatuh Tempo',
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: textStyleCustom(
                                                    context,
                                                    Colors.black,
                                                    12.sp,
                                                    FontWeight.bold),
                                              ),
                                              subtitle: Text(
                                                '${list.listRecords[index]['jatuh_tempo']}',
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: textStyleNormal(context),
                                              ),
                                            )
                                          : Container(),
                                      ketPembelian == 'membeli'
                                          ? const Divider(
                                              color: Colors.blue,
                                            )
                                          : Container(),
                                      ketPembelian == 'membeli'
                                          ? ListTile(
                                              title: Text(
                                                'Diskon Toko',
                                                maxLines: 5,
                                                overflow: TextOverflow.ellipsis,
                                                style: textStyleCustom(
                                                    context,
                                                    Colors.black,
                                                    12.sp,
                                                    FontWeight.bold),
                                              ),
                                              subtitle: Text(
                                                '${list.listRecords[index]['diskon_toko']} %',
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: textStyleNormal(context),
                                              ),
                                            )
                                          : Container(),
                                      ketPembelian == 'membeli'
                                          ? const Divider(
                                              color: Colors.blue,
                                            )
                                          : Container(),
                                      ketPembelian == 'membeli'
                                          ? ListTile(
                                              title: Text(
                                                'Diskon Cash',
                                                maxLines: 5,
                                                overflow: TextOverflow.ellipsis,
                                                style: textStyleCustom(
                                                    context,
                                                    Colors.black,
                                                    12.sp,
                                                    FontWeight.bold),
                                              ),
                                              subtitle: Text(
                                                '${list.listRecords[index]['diskon_cash']} %',
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: textStyleNormal(context),
                                              ),
                                            )
                                          : Container(),
                                      const Divider(
                                        color: Colors.blue,
                                      ),
                                      ListTile(
                                        title: Text(
                                          'No Telepon',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: textStyleCustom(
                                              context,
                                              Colors.black,
                                              12.sp,
                                              FontWeight.bold),
                                        ),
                                        subtitle: Text(
                                          '${list.listRecords[index]['customer']['no_telp']}',
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
                                          'Jenis Customer',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: textStyleCustom(
                                              context,
                                              Colors.black,
                                              12.sp,
                                              FontWeight.bold),
                                        ),
                                        subtitle: Text(
                                          '${list.listRecords[index]['customer']['jenis_p']}',
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
                                          '${list.listRecords[index]['customer']['alamat']}',
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
                                          overflow: TextOverflow.ellipsis,
                                          style: textStyleCustom(
                                              context,
                                              Colors.black,
                                              12.sp,
                                              FontWeight.bold),
                                        ),
                                        subtitle: Text(
                                          list.listRecords[index]['customer']['provinsi'] == null ||
                                          list.listRecords[index]['customer']['provinsi'] == '' ?
                                          'Tidak ada data' :
                                          '${list.listRecords[index]['customer']['provinsi']['prov_name']}',
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
                                          'Kota',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: textStyleCustom(
                                              context,
                                              Colors.black,
                                              12.sp,
                                              FontWeight.bold),
                                        ),
                                        subtitle: Text(
                                          list.listRecords[index]['customer']['kota'] == null ||
                                          list.listRecords[index]['customer']['kota'] == '' ?
                                          'Tidak ada data' :
                                          '${list.listRecords[index]['customer']['kota']['city_name']}',
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
                                          'Kelurahan',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: textStyleCustom(
                                              context,
                                              Colors.black,
                                              12.sp,
                                              FontWeight.bold),
                                        ),
                                        subtitle: Text(
                                          list.listRecords[index]['customer']['kelurahan'] == null ||
                                          list.listRecords[index]['customer']['kelurahan'] == '' ?
                                          'Tidak ada data' :
                                          '${list.listRecords[index]['customer']['kelurahan']['subdis_name']}',
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
                                          'Kecamatan',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: textStyleCustom(
                                              context,
                                              Colors.black,
                                              12.sp,
                                              FontWeight.bold),
                                        ),
                                        subtitle: Text(
                                          list.listRecords[index]['customer']['kecamatan'] == null ||
                                          list.listRecords[index]['customer']['kecamatan'] == '' ?
                                          'Tidak ada data' :
                                          '${list.listRecords[index]['customer']['kecamatan']['dis_name']}',
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
                                          'Sales',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: textStyleCustom(
                                              context,
                                              Colors.black,
                                              12.sp,
                                              FontWeight.bold),
                                        ),
                                        subtitle: Text(
                                          '${list.listRecords[index]['user']['name']}',
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
                                          'Distributor',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: textStyleCustom(
                                              context,
                                              Colors.black,
                                              12.sp,
                                              FontWeight.bold),
                                        ),
                                        subtitle: Text(
                                          '${list.listRecords[index]['distributor']['nama_perusahaan']}',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: textStyleNormal(context),
                                        ),
                                      ),
                                      ketPembelian == 'membeli'
                                          ? const Divider(
                                              color: Colors.blue,
                                            )
                                          : Container(),
                                      ketPembelian == 'membeli'
                                          ? ListTile(
                                              title: Text(
                                                'File',
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: textStyleCustom(
                                                    context,
                                                    Colors.black,
                                                    12.sp,
                                                    FontWeight.bold),
                                              ),
                                              subtitle: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 16.0,
                                                    right: 16.0,
                                                    top: 8.0),
                                                child: Container(
                                                  height: 0.35.sh,
                                                  width: 330.w,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(5.0.r),
                                                    ),
                                                    border: Border.all(
                                                      color: const Color(
                                                          0xFF00B6F1),
                                                      width: 2,
                                                    ),
                                                  ),
                                                  child: Container(
                                                      height: 0.35.sh,
                                                      width: 330.w,
                                                      color: Colors.white,
                                                      child: CachedNetworkImage(
                                                        imageUrl:
                                                            "$urlFoto2${list.listRecords[index]['file_po']}",
                                                        imageBuilder: (context,
                                                                imageProvider) =>
                                                            Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            image: DecorationImage(
                                                                image:
                                                                    imageProvider,
                                                                fit: BoxFit
                                                                    .cover),
                                                          ),
                                                        ),
                                                        placeholder: (context,
                                                                url) =>
                                                            const Center(
                                                                child:
                                                                    CircularProgressIndicator()),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            const Icon(
                                                                Icons.error),
                                                      )),
                                                ),
                                              ))
                                          : Container(),
                                      ketPembelian == 'membeli'
                                          ? const Divider(
                                              color: Colors.blue,
                                            )
                                          : Container(),
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
                              list.getData(idPesanan, region);
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
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
