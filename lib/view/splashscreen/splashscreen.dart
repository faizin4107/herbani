import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:herbani/controller/splashscreen.dart';
import 'package:herbani/helper/textstyle_custom.dart';
import 'package:loading_indicator/loading_indicator.dart';

class SplashScreen extends GetView<SplashScreenController> {
  SplashScreen({Key? key}) : super(key: key);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 108, 194, 43),
                Color.fromARGB(255, 92, 206, 21),
              ],
            ),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // SizedBox(
                  //   height: 20.0.h,
                  // ),
                  // SizedBox(height: setHeight(20))

                  SizedBox(
                    height: 230.88.h,
                  ),
                  Flexible(
                    flex: 0,
                    fit: FlexFit.tight,
                    child: SizedBox(
                      width: 250.w,
                      height: 100.h,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(10.0.r)),
                        child: Material(
                          child: Image.asset(
                            'assets/img/logo/logo_herbani.jpg',
                            height: 20.h,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Center(
                      child: SizedBox(
                    height: 50.h,
                    width: 50.w,
                    child: const LoadingIndicator(
                        indicatorType: Indicator.ballClipRotateMultiple,
                        colors: [Colors.white],
                        strokeWidth: 2,
                        backgroundColor: Colors.transparent,
                        pathBackgroundColor: Colors.black),
                  )),
                  SizedBox(
                    height: 220.0.h,
                  ),
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: Align(
                        alignment: Alignment.center,
                        child: Text('PT. Herbani Medika Nusantara',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: textStyleCustom(context, Colors.white, 14.sp,
                                FontWeight.bold))),
                  ),
                  // Flexible(
                  //   flex: 3,
                  //   fit: FlexFit.tight,
                  //   child: Container(
                  //     width: 320.0.w,
                  //     height: 220.0.h,
                  //     child: SvgPicture.asset(
                  //       'assets/img/splashscreen1.svg',
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
