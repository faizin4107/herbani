import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:herbani/controller/akun.dart';
import 'package:shimmer/shimmer.dart';
import 'package:herbani/controller/home.dart';
import 'package:herbani/helper/function.dart';
import 'package:herbani/helper/textstyle_custom.dart';
import 'package:herbani/util/constant.dart';
import 'package:herbani/widget/appbar/appbar_default.dart';
import 'package:herbani/widget/loading/loading_app.dart';
import 'package:herbani/widget/message/empty_state.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Akun extends StatefulWidget {
  const Akun({
    Key? key,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AkunState createState() => _AkunState();
}

class _AkunState extends State<Akun> {
  @override
  void initState() {
    Get.put(AkunController()).getData();
    super.initState();
  }

  List<dynamic>? listRecords = [];
  List<dynamic>? listFields = [];
  final AkunController list = Get.put(AkunController());
  final HomeController home = Get.put(HomeController());
  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  void onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    Get.put(AkunController()).getData();
    // refreshAllController();
    refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const AppBarDefault(
        title: 'Akun',
      ),
      body: SafeArea(
        child: Container(
          color: primaryColor,
          height: size.height,
          child: Stack(
            // fit: StackFit.expand,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: size.height / 5.5),
                padding: EdgeInsets.only(
                  top: size.height / 49.8,
                  left: 24.25,
                  right: 24.25,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F7F7),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24.0.r),
                    topRight: Radius.circular(24.0.r),
                  ),
                ),
                child: ScrollConfiguration(
                  behavior: const ScrollBehavior(),
                  child: SmartRefresher(
                    enablePullDown: true,
                    enablePullUp: false,
                    controller: refreshController,
                    onRefresh: onRefresh,
                    child: Padding(
                        padding: const EdgeInsets.only(bottom: 62.0),
                        child: list.obx(
                          (state) {
                            return AnimationLimiter(
                              child: ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: 1,
                                itemBuilder: (BuildContext context, int index) {
                                  return AnimationConfiguration.staggeredList(
                                    position: index,
                                    duration: const Duration(milliseconds: 375),
                                    child: SlideAnimation(
                                      verticalOffset: 50.0,
                                      child: FadeInAnimation(
                                        child: Column(
                                          children: [
                                            ListTile(
                                              title: Text(
                                                'Nama',
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: textStyleNormal(context),
                                              ),
                                              subtitle: Text(
                                                '${list.listRecords[index]['username']}',
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
                                                'Email',
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: textStyleNormal(context),
                                              ),
                                              subtitle: Text(
                                                '${list.listRecords[index]['email']}',
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
                                                'Level',
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: textStyleNormal(context),
                                              ),
                                              subtitle: Text(
                                                home.namaLevel.value,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: textStyleNormal(context),
                                              ),
                                            ),
                                            const Divider(
                                              color: Colors.blue,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Get.toNamed('/change_password',
                                                    arguments: {
                                                      'forgetPassword': false,
                                                      'email': ''
                                                    });
                                              },
                                              child: ListTile(
                                                title: Text(
                                                  'Password',
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style:
                                                      textStyleNormal(context),
                                                ),
                                                subtitle: Text(
                                                  '**************',
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style:
                                                      textStyleNormal(context),
                                                ),
                                                trailing: IconButton(
                                                  onPressed: () {
                                                    Get.toNamed(
                                                        '/change_password',
                                                        arguments: {
                                                          'forgetPassword':
                                                              false,
                                                          'email': ''
                                                        });
                                                  },
                                                  icon: Icon(
                                                    Icons
                                                        .arrow_forward_ios_outlined,
                                                    size: 15.sp,
                                                    color: Colors.blue[900],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
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
                                      list.getData();
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
                ),
              ),
              Obx(
                () => Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Center(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.toNamed('/change_foto');
                          },
                          child: Container(
                            width: 90.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 1.5,
                              ),
                            ),
                            child: Badge(
                              showBadge: true,
                              badgeContent: Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 15.sp,
                              ),
                              position: BadgePosition.bottomEnd(
                                  bottom: 18.5.h, end: 2.4.h),
                              padding: EdgeInsets.all(2.r),
                              badgeColor: Colors.blue,
                              child: CircleAvatar(
                                radius: 60.r,
                                child: home.fotoProfile.value == ''
                                    ? Text(
                                        getUserSymbol(
                                            home.user.value.toString()),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: textStyleCustom(
                                            context,
                                            Colors.white,
                                            25.sp,
                                            FontWeight.bold),
                                      )
                                    : CachedNetworkImage(
                                        // useOldImageOnUrlChange: true,
                                        filterQuality: FilterQuality.high,
                                        imageUrl:
                                            urlFoto + home.fotoProfile.value,
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          decoration: BoxDecoration(
                                            // border: Border.all(
                                            //     color: Colors.black,
                                            //     width: 1.5),
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        placeholder: (context, url) =>
                                            Shimmer.fromColors(
                                                baseColor: Colors.white,
                                                highlightColor: Colors.blue,
                                                enabled: true,
                                                child: Container(
                                                  width: 85.w,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                      color: Colors.black,
                                                      width: 2.0,
                                                    ),
                                                  ),
                                                  child: CircleAvatar(
                                                    radius: 40.r,
                                                    child: const Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                        strokeWidth: 1.0,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                )),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
              // AlignPositioned(
              //   child: Container(
              //     height: 62.85.h,
              //     width: 89.0.w,
              //     child: FittedBox(
              //       child: Container(
              //         width: 250.w,
              //         height: 100.h,
              //         child: ClipRRect(
              //           borderRadius: BorderRadius.all(Radius.circular(10.0.r)),
              //           child: Material(
              //             child: Image.asset(
              //               'assets/img/logo/logo_herbani.jpg',
              //             ),
              //           ),
              //         ),
              //       ),
              //     ),
              //   ),
              //   alignment: Alignment(0.60, -0.83),
              //   touch: Touch.middle,
              // ),
              // AlignPositioned(
              //   child:
              //       Container(height: 120.85.h, width: 260.0.w, child: Welcome()),
              //   alignment: Alignment(-0.28, -0.72),
              //   touch: Touch.middle,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
