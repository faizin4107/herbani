import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:herbani/helper/alert_custom.dart';
import 'package:herbani/helper/textstyle_custom.dart';
import 'package:herbani/util/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppBarDefault extends StatefulWidget implements PreferredSizeWidget {
  final String? title, titlePrev;
  const AppBarDefault({Key? key, this.title, this.titlePrev})
      : preferredSize = const Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  final Size preferredSize; // default is 56.0

  @override
  // ignore: library_private_types_in_public_api
  _AppBarDefaultState createState() => _AppBarDefaultState();
}

class _AppBarDefaultState extends State<AppBarDefault> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0.3,
      title: Text(
        widget.title.toString(),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: textStyleTitleAppBar(context),
      ),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          color: primaryColor,
        ),
      ),
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 18.0),
          child: widget.title == 'PT. Herbani Medika Nusantara'
              ? GestureDetector(
                  onTap: () {
                    var message =
                        'Anda yakin akan keluar? Anda akan memerlukan masuk kembali untuk menggunakan aplikasi ini.';
                    debugPrint('ya');
                    orangeConfirm(context, message, 'logout');
                  },
                  child: const Icon(Icons.exit_to_app_outlined))
              : IconButton(
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    final String? area = prefs.getString('area');
                    if (area != null) {
                      Get.offNamedUntil('/home_distributor', (route) => false);
                    } else {
                      Get.offNamedUntil('/home', (route) => false);
                    }
                  },
                  icon: const Icon(Icons.home)),
        ),
      ],
    );
  }
}
