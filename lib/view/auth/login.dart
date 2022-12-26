// ignore_for_file: deprecated_member_use

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:herbani/controller/auth.dart';
import 'package:herbani/helper/textstyle_custom.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final List<String> genderItems = ['Sales', 'Delivery', 'Kolektor'];
  final List<String> genderItems2 = ['Sales Jakarta', 'Sales Luar Jakarta'];

  String? selectedValue;
  String? selectedValue2;
  final AuthController auth = Get.put(AuthController());
  Widget _buildLoginBtn(context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: SizedBox(
        // padding: const EdgeInsets.symmetric(vertical: 15.0),
        height: 40.h,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () async {
            if (auth.formKeyLogin.currentState!.validate()) {
              FocusScope.of(context).requestFocus(FocusNode());
              if (auth.usernameController.value.text == '') {
                setState(() {
                  user = true;
                });
              } else if (auth.passwordController.value.text == '') {
                setState(() {
                  password = true;
                });
              } else {
                await auth.login(context);
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
            'MASUK',
            style:
                textStyleCustom(context, Colors.black, 14.sp, FontWeight.bold),
          ),
        ),
      ),
    );
  }

  bool user = false;
  bool password = false;
  bool selectArea = false;
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
                  key: auth.formKeyLogin,
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
                            height: 30.h,
                          ),
                          SizedBox(
                            width: 250.w,
                            height: 80.h,
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0.r)),
                              child: Material(
                                child: Image.asset(
                                  'assets/img/logo/logo_herbani.jpg',
                                  height: 15.h,
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
                          SizedBox(height: 30.0.h),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              // Text(
                              //   'Nama Pengguna',
                              //   style: textStyleTitleAppBar(context),
                              // ),
                              // SizedBox(height: 10.0.h),
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
                                  controller: auth.usernameController.value,
                                  keyboardType: TextInputType.text,
                                  style: textStyleFormTitle(context),
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding:
                                          const EdgeInsets.only(top: 14.0),
                                      prefixIcon: const Icon(
                                        Icons.person,
                                        color: Colors.blueGrey,
                                      ),
                                      hintText: 'Masukkan nama pengguna',
                                      errorStyle:
                                          textStyleFormErrorLogin(context),
                                      hintStyle: textStyleFormTitle(context)),
                                  onChanged: (val) {
                                    if (val.isEmpty) {
                                      setState(() {
                                        user = true;
                                      });
                                    } else {
                                      setState(() {
                                        user = false;
                                      });
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          user
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Nama pengguna wajib diisi',
                                      style: textStyleFormErrorLogin(context),
                                    ),
                                  ],
                                )
                              : Container(),
                          SizedBox(
                            height: 20.0.h,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              // Text(
                              //   'Password',
                              //   style: textStyleTitleAppBar(context),
                              // ),
                              // const SizedBox(height: 10.0),
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
                                height: 45.h,
                                child: TextFormField(
                                  controller: auth.passwordController.value,
                                  obscureText: auth.obscure.value,
                                  style: textStyleFormTitle(context),
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding:
                                          const EdgeInsets.only(top: 14.0),
                                      prefixIcon: const Icon(
                                        Icons.lock,
                                        color: Colors.blueGrey,
                                      ),
                                      errorStyle:
                                          textStyleFormErrorLogin(context),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          auth.obscure.value
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                          color: auth.obscure.value
                                              ? const Color(0xFFC4C4C4)
                                              : Colors.blueGrey,
                                          size: 18.sp,
                                        ),
                                        onPressed: () {
                                          auth.obscure.value =
                                              !auth.obscure.value;
                                        },
                                      ),
                                      hintText: 'Masukkan password',
                                      hintStyle: textStyleFormTitle(context)),
                                  onChanged: (val) {
                                    if (val.isEmpty) {
                                      setState(() {
                                        password = true;
                                      });
                                    } else {
                                      setState(() {
                                        password = false;
                                      });
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          password
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Password wajib diisi',
                                      style: textStyleFormErrorLogin(context),
                                    ),
                                  ],
                                )
                              : Container(),
                          SizedBox(
                            height: 20.0.h,
                          ),
                          DropdownButtonFormField2(
                            decoration: InputDecoration(
                              errorStyle: textStyleFormErrorLogin(context),
                              fillColor: Colors.white,
                              filled: true,
                              //Add isDense true and zero Padding.
                              //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),

                              //Add more decoration as you want here
                              //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
                            ),
                            isExpanded: true,
                            hint: Text('Pilih Level',
                                style: textStyleFormInput(context)),
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.black45,
                            ),
                            iconSize: 30,
                            buttonHeight: 60,
                            buttonPadding:
                                const EdgeInsets.only(left: 20, right: 10),
                            dropdownDecoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            items: genderItems
                                .map((item) => DropdownMenuItem<String>(
                                      value: item,
                                      child: Text(item,
                                          style: textStyleFormTitle(context)),
                                    ))
                                .toList(),
                            validator: (String? value) {
                              if (value == null) {
                                return 'Silahkan pilih level';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              if (value == 'Sales') {
                                setState(() {
                                  selectArea = true;
                                });
                              } else {
                                setState(() {
                                  selectArea = false;
                                });
                              }
                              if (mounted) {
                                setState(() {
                                  auth.setSelectLevel(value.toString());
                                });
                              }
                            },
                            onSaved: (value) {
                              if (mounted) {
                                setState(() {
                                  auth.setSelectLevel(value.toString());
                                });
                              }
                            },
                          ),
                          SizedBox(
                            height: 20.0.h,
                          ),
                          selectArea
                              ? DropdownButtonFormField2(
                                  decoration: InputDecoration(
                                    errorStyle:
                                        textStyleFormErrorLogin(context),
                                    fillColor: Colors.white,
                                    filled: true,
                                    //Add isDense true and zero Padding.
                                    //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),

                                    //Add more decoration as you want here
                                    //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
                                  ),
                                  isExpanded: true,
                                  hint: Text('Pilih Area Sales',
                                      style: textStyleFormInput(context)),
                                  icon: const Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.black45,
                                  ),
                                  iconSize: 30,
                                  buttonHeight: 60,
                                  buttonPadding: const EdgeInsets.only(
                                      left: 20, right: 10),
                                  dropdownDecoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  items: genderItems2
                                      .map((item) => DropdownMenuItem<String>(
                                            value: item,
                                            child: Text(item,
                                                style: textStyleFormTitle(
                                                    context)),
                                          ))
                                      .toList(),
                                  validator: (String? value) {
                                    if (value == null) {
                                      return 'Silahkan pilih area';
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    if (mounted) {
                                      setState(() {
                                        auth.setSelectArea(value.toString());
                                      });
                                    }
                                  },
                                  onSaved: (value) {
                                    if (mounted) {
                                      setState(() {
                                        auth.setSelectArea(value.toString());
                                      });
                                    }
                                  },
                                )
                              : Container(),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                MaterialButton(
                                  onPressed: () async {
                                    EasyLoading.show(status: 'Tunggu');
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    await Future.delayed(
                                        const Duration(seconds: 1));
                                    EasyLoading.dismiss();
                                    Get.toNamed('/input_email');
                                  },
                                  child: Text(
                                    'Lupa password?',
                                    style: textStyleCustom(context,
                                        Colors.white, 12.sp, FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          _buildLoginBtn(context),
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
