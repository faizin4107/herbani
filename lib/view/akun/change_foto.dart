import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:herbani/controller/akun.dart';
import 'package:herbani/helper/function.dart';
import 'package:herbani/helper/textstyle_custom.dart';
import 'package:herbani/util/constant.dart';
import 'package:herbani/widget/appbar/appbar_default.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeFoto extends StatefulWidget {
  const ChangeFoto({Key? key}) : super(key: key);

  @override
  State<ChangeFoto> createState() => _ChangeFotoState();
}

class _ChangeFotoState extends State<ChangeFoto> {
  final AkunController akun = Get.put(AkunController());
  @override
  void initState() {
    setState(() {
      loadingGetFile = true;
      fileName = null;
      image = null;
      typeFile = null;
      extFile = null;
    });
    super.initState();
  }

  File? image;
  bool loadingGetFile = false;
  String? fileName;
  String? typeFile;
  String? extFile;
  String? ketFile;
  Future getImage(type) async {
    setState(() {
      loadingGetFile = true;
      fileName = null;
      image = null;
      typeFile = null;
      extFile = null;
    });

    getImagePicture(type).then((img) {
      if (img.length == 0) {
        if (image != null) {
          setState(() {
            loadingGetFile = false;
            fileName = null;
            image = null;
            typeFile = null;
            extFile = null;
          });
        } else {
          setState(() {
            loadingGetFile = false;
            fileName = null;
            image = null;
            typeFile = null;
            extFile = null;
          });
        }
      } else {
        setState(() {
          fileName = img['fileName'];
          image = img['file'];
          typeFile = 'image';
          extFile = img['ext_file'];
          loadingGetFile = false;
        });
      }
    });
  }

  List<dynamic> valueList = [];
  Future<dynamic> submit() async {
    final dio.FormData formData = dio.FormData();
    final prefs = await SharedPreferences.getInstance();
    final area = prefs.getString('area');
    if (area != null) {
      formData.fields.add(const MapEntry('_method', 'PUT'));
      formData.fields.add(MapEntry('file_name', fileName.toString()));
    } else {
      formData.fields
          .add(MapEntry('id_user', prefs.getString('id_user').toString()));
      formData.fields.add(MapEntry('file_name', fileName.toString()));
    }

    formData.files.add(MapEntry('foto',
        await dio.MultipartFile.fromFile(image!.path, filename: fileName)));
    await akun.editFoto(formData);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => WillPopScope(
          onWillPop: () async {
            EasyLoading.dismiss();
            akun.setIsTouch(false);
            Get.back();
            return true;
          },
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: const AppBarDefault(
              title: 'Ganti Foto',
            ),
            body: AbsorbPointer(
              absorbing: akun.touch.value,
              child: Container(
                color: const Color(0xFFF9F9F9),
                width: Get.width,
                height: Get.height,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0.r),
                    ),
                    child: Card(
                      child: Form(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 40.0),
                          child: ListView(
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 22.0, right: 22.0, top: 8.0),
                                    child: Container(
                                      height: 0.35.sh,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5.0.r),
                                        ),
                                        border: Border.all(
                                          color: const Color(0xFF00B6F1),
                                          width: 2,
                                        ),
                                      ),
                                      child: Container(
                                        color: Colors.white,
                                        child: Center(
                                            child: fileName == null
                                                ? Text("Mohon pilih gambar",
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: textStyleNormal(
                                                        context))
                                                : image == null
                                                    ? Text("Mohon pilih gambar",
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: textStyleNormal(
                                                            context))
                                                    : Image.file(
                                                        image!,
                                                        fit: BoxFit.cover,
                                                        width: Get.width.w,
                                                        height: 0.35.sh,
                                                      )),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 18.0, right: 18.0, top: 15.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: InkWell(
                                          onTap: () async {
                                            await getImage('gallery');
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                3.0, 5.0, 3.0, 0),
                                            child: Container(
                                                height: 35.5.h,
                                                width: 82.5.w,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10),
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(5)),
                                                    boxShadow: <BoxShadow>[
                                                      BoxShadow(
                                                          color: Colors
                                                              .grey.shade200,
                                                          offset: const Offset(
                                                              2, 2),
                                                          blurRadius: 1,
                                                          spreadRadius: 1)
                                                    ],
                                                    gradient:
                                                        const LinearGradient(
                                                            begin: Alignment
                                                                .centerLeft,
                                                            end: Alignment
                                                                .centerRight,
                                                            colors: [
                                                          Color.fromARGB(255,
                                                              108, 194, 43),
                                                          Color.fromARGB(
                                                              255, 92, 206, 21),
                                                        ])),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    Text(
                                                      'Galeri',
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style:
                                                          textStyleCustomLato(
                                                              context,
                                                              Colors.white,
                                                              10.sp,
                                                              FontWeight
                                                                  .normal),
                                                    ),
                                                    Icon(
                                                      Icons.image,
                                                      color: Colors.white,
                                                      size: 15.sp,
                                                    ),
                                                  ],
                                                )),
                                          )),
                                    ),
                                    Expanded(
                                      child: InkWell(
                                          onTap: () {
                                            getImage('camera');
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                3.0, 5.0, 3.0, 0),
                                            child: Container(
                                                height: 35.5.h,
                                                width: 82.5.w,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10),
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                5.r)),
                                                    boxShadow: <BoxShadow>[
                                                      BoxShadow(
                                                          color: Colors
                                                              .grey.shade200,
                                                          offset: const Offset(
                                                              2, 2),
                                                          blurRadius: 1,
                                                          spreadRadius: 1)
                                                    ],
                                                    gradient:
                                                        const LinearGradient(
                                                            begin: Alignment
                                                                .centerLeft,
                                                            end: Alignment
                                                                .centerRight,
                                                            colors: [
                                                          Color.fromARGB(255,
                                                              108, 194, 43),
                                                          Color.fromARGB(
                                                              255, 92, 206, 21),
                                                        ])),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    Text(
                                                      'Kamera',
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style:
                                                          textStyleCustomLato(
                                                              context,
                                                              Colors.white,
                                                              10.sp,
                                                              FontWeight
                                                                  .normal),
                                                    ),
                                                    Icon(
                                                      Icons.camera_alt,
                                                      color: Colors.white,
                                                      size: 15.sp,
                                                    ),
                                                  ],
                                                )),
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 30.h,
                              ),
                              Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      20.0, 0, 20.0, 20),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0))),
                                    height: 35.h,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: primaryColor,
                                        // primary: primaryColor,

                                        textStyle:
                                            textStyleButtonLogin(context),
                                      ),
                                      onPressed: () async {
                                        if (image == null) {
                                          return EasyLoading.showInfo(
                                              'Mohon pilih gambar terlebih dahulu');
                                        } else {
                                          FocusScope.of(context)
                                              .requestFocus(FocusNode());
                                          submit();
                                        }
                                      },
                                      child: const Text(
                                        'Edit',
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
