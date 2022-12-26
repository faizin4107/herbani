import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:herbani/controller/welcome.dart';
import 'package:herbani/helper/function.dart';
import 'package:herbani/helper/textstyle_custom.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Welcome extends StatefulWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  // final WelcomeController welcome = Get.put(WelcomeController());
  @override
  void initState() {
    getData();
    getImage();
    // getSayingTime();
    super.initState();
  }

  Map<String, dynamic> sayingTime = {};

  getImage() {
    getSayingTime().then((val) {
      sayingTime = val;
    });
  }

  // ignore: prefer_typing_uninitialized_variables
  var user;
  getData() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        user = prefs.getString('username');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        ListTile(
            leading: sayingTime['image'] == null
                ? const CircularProgressIndicator()
                : SvgPicture.asset(
                    '${sayingTime['image']}',
                    height: 16.h,
                    width: 16.w,
                  ),
            title: Transform.translate(
              offset: const Offset(-25, 0),
              child: Text('${sayingTime['saying']}.',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textStyleTitleAppBar(context)),
            ),
            subtitle: Transform.translate(
              offset: const Offset(-25, 0),
              child: Text(user == null ? '' : user.toString(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textStyleTitleAppBar(context)),
            )),
      ],
    );
  }
}
