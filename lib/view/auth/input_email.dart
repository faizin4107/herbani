// import 'package:device_info_plus/device_info_plus.dart';
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:herbani/controller/auth.dart';
import 'package:herbani/helper/textstyle_custom.dart';

class InputEmail extends StatefulWidget {
  const InputEmail({Key? key}) : super(key: key);

  @override
  State<InputEmail> createState() => _InputEmailState();
}

class _InputEmailState extends State<InputEmail> {
  final AuthController auth = Get.put(AuthController());
  @override
  void initState() {
    auth.emailController.value.clear();
    super.initState();
  }

  // final InfoController info = Get.put(InfoController());
  Widget _buildLoginBtn(context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: SizedBox(
        // padding: const EdgeInsets.symmetric(vertical: 5.0),
        width: double.infinity,
        height: 40.h,
        child: ElevatedButton(
          onPressed: () async {
            FocusScope.of(context).requestFocus(FocusNode());
            if (auth.formKeyInputEmail.currentState!.validate()) {
              // signIn();
              if (auth.emailController.value.text == '') {
                setState(() {
                  email = true;
                });
              } else {
                await auth.checkEmail(context);
              }
            }
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.white,
            textStyle: textStyleButtonLogin(context),
            elevation: 5.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          child: Text(
            'SUBMIT',
            style:
                textStyleCustom(context, Colors.black, 14.sp, FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildBack(context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: SizedBox(
        // padding: const EdgeInsets.symmetric(vertical: 5.0),
        width: double.infinity,
        height: 40.h,
        child: ElevatedButton(
          onPressed: () async {
            if (auth.emailController.value.text != '') {
              EasyLoading.show(status: 'Tunggu');
              FocusScope.of(context).requestFocus(FocusNode());
              await Future.delayed(const Duration(seconds: 1));
              EasyLoading.dismiss();
              auth.emailController.value.clear();
              Get.back();
            } else {
              FocusScope.of(context).requestFocus(FocusNode());
              auth.emailController.value.clear();
              Get.back();
            }
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.white,
            textStyle: textStyleButtonLogin(context),
            elevation: 5.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          child: Text(
            'Kembali',
            style:
                textStyleCustom(context, Colors.black, 14.sp, FontWeight.bold),
          ),
        ),
      ),
    );
  }

  bool email = false;

  @override
  Widget build(BuildContext context) {
    return Obx(() => AbsorbPointer(
          absorbing: auth.touch.value,
          child: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.light,
            child: Stack(
              children: <Widget>[
                Container(
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
                ),
                Form(
                  key: auth.formKeyInputEmail,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  // autovalidate: _autoValiidate,
                  child: SizedBox(
                    height: double.infinity,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40.0,
                        vertical: 120.0,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 40.h,
                          ),
                          SizedBox(
                            width: 250.w,
                            height: 100.h,
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0.r)),
                              child: Material(
                                child: Image.asset(
                                  'assets/img/logo/logo_herbani.jpg',
                                  height: 20.h,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 18.0),
                            child: Text('PT. Herbani Medika Nusantara',
                                style: textStyleCustom(context, Colors.white,
                                    14.sp, FontWeight.bold)),
                          ),
                          SizedBox(height: 50.0.h),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Email',
                                style: textStyleTitleAppBar(context),
                              ),
                              SizedBox(height: 10.0.h),
                              Container(
                                alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10.0),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 6.0,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                height: 45.0.h,
                                child: TextFormField(
                                  controller: auth.emailController.value,
                                  keyboardType: TextInputType.emailAddress,
                                  style: textStyleFormTitle(context),
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding:
                                          const EdgeInsets.only(top: 14.0),
                                      prefixIcon: const Icon(
                                        Icons.email,
                                        color: Colors.blueGrey,
                                      ),
                                      hintText: 'Masukkan email',
                                      errorStyle:
                                          textStyleFormErrorLogin(context),
                                      hintStyle: textStyleFormTitle(context)),
                                  onChanged: (val) {
                                    if (val.isEmpty) {
                                      setState(() {
                                        email = true;
                                      });
                                    } else {
                                      setState(() {
                                        email = false;
                                      });
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          email
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Email wajib diisi',
                                      style: textStyleFormErrorLogin(context),
                                    ),
                                  ],
                                )
                              : Container(),
                          SizedBox(
                            height: 15.0.h,
                          ),
                          _buildLoginBtn(context),
                          SizedBox(
                            height: 10.0.h,
                          ),
                          _buildBack(context),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
