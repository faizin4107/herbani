import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:herbani/controller/auth.dart';
import 'package:herbani/helper/textstyle_custom.dart';
import 'package:herbani/util/constant.dart';
import 'package:herbani/widget/appbar/appbar_default.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final AuthController auth = Get.put(AuthController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool forgetPassword = false;
  // ignore: prefer_typing_uninitialized_variables
  var email;
  @override
  void initState() {
    setState(() {
      forgetPassword = Get.arguments['forgetPassword'];
      email = Get.arguments['email'];
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        EasyLoading.dismiss();
        if (mounted) {
          setState(() {
            auth.setIsTouch(false);
          });
        }
        Get.back();
        return true;
      },
      child: Scaffold(
          resizeToAvoidBottomInset: true,
          key: _scaffoldKey,
          appBar: const AppBarDefault(
            title: 'Ganti Password',
          ),
          body: Obx(
            () => SafeArea(
              child: Container(
                color: const Color(0xFFF9F9F9),
                height: double.infinity,
                width: double.infinity,
                child: Form(
                  key: auth.formKeyChangePassword,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: ScrollConfiguration(
                      behavior: const ScrollBehavior(),
                      child: Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(15.0, 10, 15.0, 0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 20.h,
                                ),
                                forgetPassword
                                    ? Container()
                                    : ListTile(
                                        title: Text(
                                          'Password Lama',
                                          style: textStyleFormTitle(context),
                                        ),
                                        subtitle: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: TextFormField(
                                            controller: auth.oldPassword.value,
                                            obscureText: auth.showHide1.value,
                                            enableSuggestions: false,
                                            style: textStyleFormTitle(context),
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: Colors.white,
                                              border: InputBorder.none,
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Color(0xFF979797),
                                                      width: 0.5),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0)),
                                              enabledBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Color(0xFF979797),
                                                      width: 0.5),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0)),
                                              errorBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Color(0xFF979797),
                                                      width: 0.5),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0)),
                                              contentPadding:
                                                  const EdgeInsets.only(
                                                      left: 10.0, top: 18.0),
                                              hintText:
                                                  'Masukkan password lama',
                                              hintStyle:
                                                  textStyleFormInput(context),
                                              errorStyle:
                                                  textStyleFormError(context),
                                              suffixIcon: IconButton(
                                                icon: Icon(
                                                  auth.showHide1.value
                                                      ? Icons.visibility_off
                                                      : Icons.visibility,
                                                  color: auth.showHide1.value
                                                      ? const Color(0xFFC4C4C4)
                                                      : Colors.blueGrey,
                                                  size: 18.sp,
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    auth.showHide1.value =
                                                        !auth.showHide1.value;
                                                  });
                                                },
                                              ),
                                            ),
                                            validator: (value) {
                                              if (value == '' ||
                                                  value == null) {
                                                return 'Password lama wajib diisi';
                                              }
                                              return null;
                                            },
                                            keyboardType:
                                                TextInputType.visiblePassword,
                                          ),
                                        ),
                                      ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                ListTile(
                                  title: Text(
                                    'Password Baru',
                                    style: textStyleFormTitle(context),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: TextFormField(
                                      controller: auth.newPassword.value,
                                      obscureText: auth.showHide2.value,
                                      enableSuggestions: false,
                                      style: textStyleFormTitle(context),
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: InputBorder.none,
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Color(0xFF979797),
                                                width: 0.5),
                                            borderRadius:
                                                BorderRadius.circular(5.0)),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Color(0xFF979797),
                                                width: 0.5),
                                            borderRadius:
                                                BorderRadius.circular(5.0)),
                                        errorBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Color(0xFF979797),
                                                width: 0.5),
                                            borderRadius:
                                                BorderRadius.circular(5.0)),
                                        contentPadding: const EdgeInsets.only(
                                            left: 10.0, top: 18.0),
                                        hintText: 'Masukkan password baru',
                                        hintStyle: textStyleFormInput(context),
                                        errorStyle: textStyleFormError(context),
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            auth.showHide2.value
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                            color: auth.showHide2.value
                                                ? const Color(0xFFC4C4C4)
                                                : Colors.blueGrey,
                                            size: 18.sp,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              auth.showHide2.value =
                                                  !auth.showHide2.value;
                                            });
                                          },
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == '' || value == null) {
                                          return 'Password baru wajib diisi';
                                        }
                                        return null;
                                      },
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 30.h,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15.0, right: 15.0),
                                  child: SizedBox(
                                    width: Get.size.width,
                                    height: 35.h,
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: primaryColor,
                                          textStyle: textStyleCustom(
                                              context,
                                              primaryColor,
                                              14.sp,
                                              FontWeight.bold),
                                        ),
                                        onPressed: () {
                                          if (auth.formKeyChangePassword
                                              .currentState!
                                              .validate()) {
                                            FocusScope.of(context)
                                                .requestFocus(FocusNode());
                                            auth.changePassword(
                                                context, forgetPassword, email);
                                          }

                                          // print('test $_test');
                                        },
                                        child: const Text('Edit')),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )),
    );
  }
}
