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

class DetailOrder extends StatefulWidget {
  const DetailOrder({Key? key}) : super(key: key);

  @override
  State<DetailOrder> createState() => _DetailOrderState();
}

class _DetailOrderState extends State<DetailOrder> {
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
    Get.put(DetailOrderController()).getData(idPesanan, region);
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
                                          ' ${list.listRecords[index]['nama_pembeli']}',
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
                                          'Tanggal PO',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: textStyleCustom(
                                              context,
                                              Colors.black,
                                              12.sp,
                                              FontWeight.bold),
                                        ),
                                        subtitle: Text(
                                          '${list.listRecords[index]['tgl_po']}',
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
                                                '${list.listRecords[index]['ket_po']}',
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
                                      ),
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
                                                '${list.listRecords[index]['tempo_kredit']}',
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
                                                'Diskon',
                                                maxLines: 5,
                                                overflow: TextOverflow.ellipsis,
                                                style: textStyleCustom(
                                                    context,
                                                    Colors.black,
                                                    12.sp,
                                                    FontWeight.bold),
                                              ),
                                              subtitle: Text(
                                                '${list.listRecords[index]['diskon']} %',
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
                                                'Tanggal Order',
                                                maxLines: 5,
                                                overflow: TextOverflow.ellipsis,
                                                style: textStyleCustom(
                                                    context,
                                                    Colors.black,
                                                    12.sp,
                                                    FontWeight.bold),
                                              ),
                                              subtitle: Text(
                                                '${list.listRecords[index]['tgl_order']}',
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
                                                'Tanggal Selesai',
                                                maxLines: 5,
                                                overflow: TextOverflow.ellipsis,
                                                style: textStyleCustom(
                                                    context,
                                                    Colors.black,
                                                    12.sp,
                                                    FontWeight.bold),
                                              ),
                                              subtitle: Text(
                                                '${list.listRecords[index]['tgl_selesai']}',
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
                                          '${list.listRecords[index]['no_telp']}',
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
                                          '${list.listRecords[index]['jenis_p']}',
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
                                          '${list.listRecords[index]['alamat']}',
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
                                          '${list.listRecords[index]['kelurahan']}',
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
                                          '${list.listRecords[index]['kecamatan']}',
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
                                          '${list.listRecords[index]['provinsi']}',
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
                                          '${list.listRecords[index]['id_sales']}',
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
                                                            "$urlUploads${list.listRecords[index]['file_po']}",
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
