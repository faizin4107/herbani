import 'package:align_positioned/align_positioned.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:herbani/controller/home.dart';
// import 'package:herbani/controller/welcome.dart';
import 'package:herbani/helper/textstyle_custom.dart';
import 'package:herbani/util/constant.dart';
import 'package:herbani/view/home/contact.dart';
import 'package:herbani/view/home/menu.dart';
import 'package:herbani/view/home/welcome.dart';
import 'package:herbani/widget/appbar/appbar_default.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DateFormat? dateFormat;
  DateFormat? dayFormat;

  @override
  void initState() {
    EasyLoading.dismiss();
    Get.put(HomeController()).getData();
    initializeDateFormatting();
    setDate();
    super.initState();
  }

  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  // final WelcomeController welcome = Get.put(WelcomeController());

  void onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    // getSayingTime();
    // welcome.getImage();
    Get.put(HomeController()).getData();
    // refreshAllController();
    refreshController.refreshCompleted();
  }

  @override
  void dispose() {
    refreshController.dispose();
    super.dispose();
  }

  // final InfoController info = Get.find();
  void setDate() {
    dateFormat = DateFormat.yMMMMd('id');
    dayFormat = DateFormat.EEEE('id');
  }

  final showScrollbar = ScrollController(initialScrollOffset: 5.0);

  var dateTime = DateTime.now();

  bool setStatus = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: primaryColor,
      key: _scaffoldKey,
      appBar: const AppBarDefault(
        title: 'PT. Herbani Medika Nusantara',
      ),
      body: Container(
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
                    child: ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        SizedBox(
                          height: 17.h,
                          width: 158.57.w,
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              '${dayFormat?.format(dateTime)}, ${dateFormat?.format(dateTime)}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: textStyleTitle700(context),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.5.h,
                        ),
                        const Divider(
                          color: Colors.blue,
                        ),
                        Contact(),
                        SizedBox(
                          height: 12.5.h,
                        ),
                        const Divider(
                          color: Colors.blue,
                        ),
                        Menu(),
                        SizedBox(
                          height: 12.5.h,
                        ),
                        // Articles(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            AlignPositioned(
              alignment: const Alignment(0.60, -0.83),
              touch: Touch.middle,
              child: SizedBox(
                height: 62.85.h,
                width: 89.0.w,
                child: FittedBox(
                  child: SizedBox(
                    width: 250.w,
                    height: 100.h,
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10.0.r)),
                      child: Material(
                        child: Image.asset(
                          'assets/img/logo/logo_herbani.jpg',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            AlignPositioned(
              alignment: const Alignment(-0.28, -0.72),
              touch: Touch.middle,
              child: SizedBox(
                  height: 120.85.h, width: 260.0.w, child: const Welcome()),
            ),
          ],
        ),
      ),
    );
  }
}
