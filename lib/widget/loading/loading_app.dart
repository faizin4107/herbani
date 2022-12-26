import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_indicator/loading_indicator.dart';

class LoadingApp extends StatelessWidget {
  final double topPaddingLoading;
  const LoadingApp({Key? key, required this.topPaddingLoading})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: topPaddingLoading),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
              child: SizedBox(
            height: 50.h,
            width: 50.w,
            child: LoadingIndicator(
                // ballClipRotatePulse
                // ballClipRotateMultiple
                // ballTrianglePathColored
                // ballTrianglePathColoredFilled
                // ballSpinFadeLoader
                // ballRotateChase
                indicatorType: Indicator.ballClipRotateMultiple,
                colors: [Colors.blue.shade900],
                strokeWidth: 2,
                backgroundColor: Colors.transparent,
                pathBackgroundColor: Colors.black),
          ))
        ],
      ),
    );
  }
}
