import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle textStyleCustom(context, color, size, weight) => GoogleFonts.roboto(
      fontSize: size,
      fontWeight: weight,
      color: color,
    );

TextStyle textStyleCustomLato(context, color, size, weight) => GoogleFonts.lato(
      fontSize: size,
      fontWeight: weight,
      color: color,
    );
TextStyle textStyleNormal(context) => GoogleFonts.roboto(
      fontSize: 12.sp,
      fontWeight: FontWeight.normal,
      color: Colors.black,
    );

TextStyle textStyleTitleAppBar(context) => GoogleFonts.lato(
      fontSize: 14.sp,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );

TextStyle textStyleTitle700(context) => GoogleFonts.roboto(
      fontSize: 12.sp,
      fontWeight: FontWeight.w700,
      color: Colors.black,
    );

TextStyle textStyleTitle500(context) => GoogleFonts.roboto(
      fontSize: 12.sp,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    );

TextStyle textStyleTitleBold(context) => GoogleFonts.roboto(
      fontSize: 12.sp,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );

TextStyle textStyleButtonLogin(context) => GoogleFonts.lato(
      fontSize: 14.sp,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );

TextStyle textStyleButtonRow(context) => GoogleFonts.lato(
      fontSize: 12.sp,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );

TextStyle textStyleFormTitle(context) => GoogleFonts.roboto(
      fontSize: 12.sp,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    );

TextStyle textStyleFormInput(context) => GoogleFonts.roboto(
      fontSize: 12.sp,
      fontWeight: FontWeight.w300,
      color: Colors.black,
    );

TextStyle textStyleFormErrorLogin(context) => GoogleFonts.roboto(
      fontSize: 12.sp,
      fontWeight: FontWeight.w300,
      color: Colors.white,
    );

TextStyle textStyleFormError(context) => GoogleFonts.roboto(
      fontSize: 12.sp,
      fontWeight: FontWeight.w300,
      color: Colors.red[900],
    );
