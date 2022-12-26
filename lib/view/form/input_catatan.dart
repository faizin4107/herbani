import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:herbani/controller/form.dart';
import 'package:herbani/helper/textstyle_custom.dart';
import 'package:herbani/widget/button/button_row.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class InputCatatan extends StatefulWidget {
  const InputCatatan({Key? key, this.idPo, this.idInvoice}) : super(key: key);
  final String? idPo;
  final String? idInvoice;

  @override
  State<InputCatatan> createState() => _InputCatatanState();
}

class _InputCatatanState extends State<InputCatatan> {
  TextEditingController catatanController = TextEditingController();
  final formKeyInputan = GlobalKey<FormState>();

  Widget _fieldUserId(context) {
    return Padding(
        padding: const EdgeInsets.only(left: 21.0, right: 21.0, top: 10.0),
        child: TextFormField(
          controller: catatanController,
          style: textStyleFormTitle(context),
          decoration: InputDecoration(
            hintText: 'Masukkan Catatan',
            hintStyle: textStyleFormInput(context),
            contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: const BorderSide(color: Color(0xFF00B6F1)),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: const BorderSide(color: Color(0xFF00B6F1)),
            ),
          ),
          validator: (val) {
            if (val!.isEmpty) {
              return "Catatan harus diisi";
            }
            return null;
          },
          maxLines: 7,
          keyboardType: TextInputType.text,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: SizedBox(
        height: 0.6.sh,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.only(left: 18.0, right: 18.0, bottom: 15),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      EasyLoading.dismiss();
                      // info.setIsTouchGlobal(false);
                    },
                    child: ButtonRow(
                        textBtn: 'BATAL',
                        orangeColor1: const Color(0xFF838383),
                        orangeColor2: const Color(0xFF838383),
                        widthBtn: 40.w,
                        heightBtn: 30.h),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      if (formKeyInputan.currentState!.validate()) {
                        FocusScope.of(context).requestFocus(FocusNode());
                        final FormController form = Get.put(FormController());
                        Map body = {
                          'id_po': widget.idPo,
                          'id_invoice': widget.idInvoice,
                          'catatan': catatanController.text
                        };
                        form.tolakPo(body);
                        Navigator.pop(context);
                      }
                    },
                    child: ButtonRow(
                        textBtn: 'OKE',
                        orangeColor1: const Color.fromARGB(255, 108, 194, 43),
                        orangeColor2: const Color.fromARGB(255, 92, 206, 21),
                        widthBtn: 40.w,
                        heightBtn: 30.h),
                  ),
                ),
              ],
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                SizedBox(
                  height: 12.h,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Masukkan catatan kenapa PO Ditolak!',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textStyleTitle700(context),
                  ),
                ),
                SizedBox(
                  height: 12.h,
                ),
                Expanded(
                  child: Form(
                    key: formKeyInputan,
                    child: ListView(
                      reverse: false,
                      shrinkWrap: true,
                      controller: ModalScrollController.of(context),
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        _fieldUserId(context),
                        SizedBox(
                          height: 10.5.h,
                        ),
                        SizedBox(
                          height: 10.5.h,
                        ),
                        SizedBox(
                          height: 10.5.h,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
