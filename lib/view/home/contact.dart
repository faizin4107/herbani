import 'package:flutter/material.dart';
import 'package:flutter_bootstrap/flutter_bootstrap.dart';
import 'package:get/get.dart';
import 'package:herbani/controller/home.dart';
import 'package:herbani/helper/textstyle_custom.dart';

class Contact extends StatelessWidget {
  Contact({Key? key}) : super(key: key);
  final HomeController home = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return Obx(() => Transform.translate(
          offset: const Offset(-18, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BootstrapRow(
                children: <BootstrapCol>[
                  BootstrapCol(
                    sizes: 'col-lg-6',
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          dense: true,
                          title: Text(
                            'Nama',
                            style: textStyleFormTitle(context),
                          ),
                          subtitle: home.user.value == ''
                              ? Text(
                                  '',
                                  style: textStyleTitle500(context),
                                )
                              : Text(
                                  home.user.value,
                                  style: textStyleTitle500(context),
                                ),
                        ),
                      ],
                    ),
                  ),
                  BootstrapCol(
                    sizes: 'col-lg-6',
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          dense: true,
                          title: Text(
                            'Level',
                            style: textStyleFormTitle(context),
                          ),
                          subtitle: home.namaLevel.value == ''
                              ? Text(
                                  '',
                                  style: textStyleTitle500(context),
                                )
                              : Text(
                                  home.namaLevel.value,
                                  style: textStyleTitle500(context),
                                ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              BootstrapRow(
                children: <BootstrapCol>[
                  BootstrapCol(
                    sizes: 'col-lg-6',
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                            dense: true,
                            title: Text(
                              'Email',
                              style: textStyleFormTitle(context),
                            ),
                            subtitle: home.email.value == ''
                                ? Text(
                                    '',
                                    style: textStyleTitle500(context),
                                  )
                                : Text(
                                    home.email.value,
                                    style: textStyleTitle500(context),
                                  )),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
