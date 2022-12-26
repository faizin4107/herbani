import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:herbani/binding/akun.dart';
import 'package:herbani/binding/auth.dart';
import 'package:herbani/binding/customer.dart';
import 'package:herbani/binding/detail_order.dart';
import 'package:herbani/binding/detail_retur.dart';
import 'package:herbani/binding/form.dart';
import 'package:herbani/binding/home.dart';
import 'package:herbani/binding/initial.dart';
import 'package:herbani/binding/order.dart';
import 'package:herbani/binding/invoice.dart';
import 'package:herbani/binding/penagihan.dart';
import 'package:herbani/binding/retur.dart';
import 'package:herbani/binding/splashscreen.dart';
import 'package:herbani/helper/local_notification.dart';
import 'package:herbani/helper/textstyle_custom.dart';
import 'package:herbani/util/constant.dart';
import 'package:herbani/view/akun/akun.dart';
import 'package:herbani/view/akun/akun_non_dki.dart';
import 'package:herbani/view/akun/change_foto.dart';
import 'package:herbani/view/akun/change_password.dart';
import 'package:herbani/view/auth/input_email.dart';
import 'package:herbani/view/auth/login.dart';
import 'package:herbani/view/customer/create_customer.dart';
import 'package:herbani/view/customer/customer.dart';
import 'package:herbani/view/customer/customer_non_dki.dart';
import 'package:herbani/view/distributor/distributor.dart';
import 'package:herbani/view/form/form_diskon.dart';
import 'package:herbani/view/form/form_field.dart';
import 'package:herbani/view/form/form_finish.dart';
import 'package:herbani/view/form/form_order.dart';
import 'package:herbani/view/form/form_penagihan.dart';
import 'package:herbani/view/form/form_purchase_order.dart';
import 'package:herbani/view/form/form_retur.dart';
import 'package:herbani/view/form/form_submit.dart';
import 'package:herbani/view/form/form_tempo.dart';
import 'package:herbani/view/form/konfirmasi_penagihan.dart';
import 'package:herbani/view/home/home.dart';
import 'package:herbani/view/home/home_distributor.dart';
import 'package:herbani/view/invoice/invoice.dart';
import 'package:herbani/view/laporan/laporan_penagihan.dart';
import 'package:herbani/view/order/detail_order.dart';
import 'package:herbani/view/order/detail_order_non_dki.dart';
import 'package:herbani/view/order/list_order.dart';
import 'package:herbani/view/order/list_order_non_dki.dart';
import 'package:herbani/view/order/order.dart';
import 'package:herbani/view/order/order_non_dki.dart';
import 'package:herbani/view/retur/list_retur_non_dki.dart';
import 'package:herbani/view/retur/retur.dart';
import 'package:herbani/view/splashscreen/splashscreen.dart';
import 'package:herbani/widget/appbar/appbar_default.dart';
import 'package:herbani/widget/loading/loading_app.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> onBackgroundMessage(RemoteMessage message) async {
  await Firebase.initializeApp();
  final prefs = await SharedPreferences.getInstance();
  var dataNotif = prefs.getString("myDataEncode");
  if (dataNotif != null) {
    await prefs.remove('myDataEncode');
  }

  var myData = jsonEncode(message.data);
  await prefs.setString('myDataEncode', myData);
}

AndroidNotificationChannel channel2 = const AndroidNotificationChannel(
  'herbani',
  'High Importance Notifications',
  description: 'This channel is used for important notifications.',
  importance: Importance.high,
  playSound: true,
  enableVibration: true,
  enableLights: true,
  showBadge: true,
  ledColor: Color.fromARGB(255, 255, 0, 0),
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp();
  await LocalNotification().initializeLocalNotifications();
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel2);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    return LocalNotification().showNotification(message);
  });
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    LocalNotification().showNotification(message);
  });

  FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  final prefs = await SharedPreferences.getInstance();
  prefs.reload();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return const SomethingWentWrong();
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return const MyRoute();
        }

        return const SomethingWentWrong();
      },
    );
  }
}

class MyRoute extends StatelessWidget {
  const MyRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQueryData.fromWindow(WidgetsBinding.instance.window),
      child: ScreenUtilInit(
          designSize: const Size(375, 731),
          splitScreenMode: true,
          minTextAdapt: true,
          builder: () {
            return RefreshConfiguration(
              footerTriggerDistance: 15,
              springDescription: const SpringDescription(
                  stiffness: 170, damping: 16, mass: 1.9),
              dragSpeedRatio: 0.91,
              enableScrollWhenTwoLevel: true,
              enableBallisticLoad: true,
              enableBallisticRefresh: true,
              enableLoadingWhenFailed: true,
              enableScrollWhenRefreshCompleted: true,
              hideFooterWhenNotFull: true,
              headerBuilder: () => WaterDropHeader(
                waterDropColor: primaryColor,
                refresh: SizedBox(
                  height: 40.h,
                  width: 40.w,
                  child: LoadingIndicator(
                      indicatorType: Indicator.ballClipRotateMultiple,
                      colors: [primaryColor],
                      strokeWidth: 2,
                      backgroundColor: Colors.transparent,
                      pathBackgroundColor: Colors.black),
                ),
              ),
              footerBuilder: () => CustomFooter(
                builder: (BuildContext context, LoadStatus? mode) {
                  Widget body;
                  if (mode == LoadStatus.idle) {
                    body = Text(
                      "Tarik untuk mengulang",
                      style: textStyleCustom('Roboto-regular', Colors.black,
                          12.sp, FontWeight.bold),
                    );
                  } else if (mode == LoadStatus.loading) {
                    body = const LoadingApp(topPaddingLoading: 0);
                  } else if (mode == LoadStatus.failed) {
                    body = Text(
                      "Pemuatan Gagal! Klik coba lagi",
                      style: textStyleCustom('Roboto-regular', Colors.black,
                          12.sp, FontWeight.bold),
                    );
                  } else if (mode == LoadStatus.canLoading) {
                    body = Text(
                      "Lepaskan untuk memuat",
                      style: textStyleCustom('Roboto-regular', Colors.black,
                          12.sp, FontWeight.bold),
                    );
                  } else {
                    body = Text(
                      "Tidak ada lagi Data",
                      style: textStyleCustom('Roboto-regular', Colors.black,
                          12.sp, FontWeight.bold),
                    );
                  }
                  return SizedBox(
                    height: 55.h,
                    child: Center(child: body),
                  );
                },
              ),
              enableLoadingWhenNoData: true,
              enableRefreshVibrate: true,
              enableLoadMoreVibrate: true,
              shouldFooterFollowWhenNotFull: (state) {
                return true;
              },
              child: GetMaterialApp(
                builder: (context, myWidget) {
                  ScreenUtil.setContext(context);
                  myWidget = EasyLoading.init()(context, myWidget);
                  return MediaQuery(
                    //Setting font does not change with system font size
                    data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                    child: myWidget,
                  );
                },
                theme: ThemeData(
                  scrollbarTheme: const ScrollbarThemeData().copyWith(
                    thumbColor:
                        MaterialStateProperty.all(const Color(0xFF00B6F1)),
                  ),
                  colorScheme: const ColorScheme.light(),
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                ),
                title: 'Herbani',

                debugShowCheckedModeBanner: false,
                initialRoute: '/splashscreen',

                // home:  SplashScreen(),
                defaultTransition: Transition.rightToLeftWithFade,
                // showPerformanceOverlay: true,

                transitionDuration: const Duration(
                  milliseconds: 350,
                ),
                initialBinding: InitialAppBinding(),
                getPages: [
                  GetPage(
                      name: '/splashscreen',
                      page: () => SplashScreen(),
                      binding: SplashScreenBinding()),
                  GetPage(
                      name: '/login',
                      page: () => const Login(),
                      binding: AuthBinding()),
                  GetPage(
                      name: '/home',
                      page: () => const Home(),
                      binding: HomeBinding()),
                  GetPage(
                      name: '/list_customer',
                      page: () => const ListCustomer(),
                      binding: CustomerBinding()),
                  GetPage(
                      name: '/list_customer_non_dki',
                      page: () => const ListCustomerNonDki(),
                      binding: CustomerBinding()),
                  GetPage(
                      name: '/create_customer',
                      page: () => const CreateCustomer(),
                      binding: CustomerBinding()),
                  GetPage(
                      name: '/form_field',
                      page: () => const FormFieldList(),
                      binding: FormBinding()),
                  GetPage(
                    name: '/form_order',
                    page: () => const FormOrder(),
                  ),
                  GetPage(
                    name: '/form_submit',
                    page: () => const FormSubmit(),
                  ),
                  GetPage(
                    name: '/form_purchase_order',
                    page: () => const FormPurchaseOrder(),
                  ),
                  GetPage(
                    name: '/form_diskon',
                    page: () => const FormDiskon(),
                  ),
                  GetPage(
                    name: '/form_tempo',
                    page: () => const FormTempo(),
                  ),
                  GetPage(
                      name: '/order',
                      page: () => const Order(),
                      binding: OrderBinding()),
                  GetPage(
                      name: '/order_non_dki',
                      page: () => const OrderNonDki(),
                      binding: OrderBinding()),
                  GetPage(
                      name: '/detail_order',
                      page: () => const DetailOrder(),
                      binding: DetailOrderBinding()),
                  GetPage(
                      name: '/detail_order_non_dki',
                      page: () => const DetailOrderNonDki(),
                      binding: DetailOrderBinding()),
                  GetPage(
                      name: '/list_order',
                      page: () => const ListOrder(),
                      binding: DetailOrderBinding()),
                  GetPage(
                      name: '/list_order_non_dki',
                      page: () => const ListOrderNonDki(),
                      binding: DetailOrderBinding()),
                  GetPage(
                      name: '/form_retur',
                      page: () => const FormRetur(),
                      binding: ReturBinding()),
                  GetPage(
                      name: '/invoice',
                      page: () => const Invoice(),
                      binding: InvoiceBinding()),
                  GetPage(
                    name: '/konfirmasi_penagihan',
                    page: () => const KonfirmasiPenagihan(),
                  ),
                  GetPage(
                      name: '/laporan_penagihan',
                      page: () => const LaporanPenagihan(),
                      binding: PenagihanBinding()),
                  GetPage(
                      name: '/akun',
                      page: () => const Akun(),
                      binding: AkunBinding()),
                  GetPage(
                      name: '/akun_non_dki',
                      page: () => const AkunNonDki(),
                      binding: AkunBinding()),
                  GetPage(
                      name: '/change_password',
                      page: () => const ChangePassword()),
                  GetPage(name: '/change_foto', page: () => const ChangeFoto()),
                  GetPage(name: '/input_email', page: () => const InputEmail()),
                  GetPage(name: '/form_finish', page: () => const FormFinish()),
                  GetPage(
                      name: '/form_penagihan',
                      page: () => const FormPenagihan()),
                  GetPage(
                      name: '/home_distributor',
                      page: () => const HomeDistributor()),
                  GetPage(name: '/retur', page: () => const Retur()),
                  GetPage(
                      name: '/list_retur_non_dki',
                      page: () => const ListReturNonDki(),
                      binding: DetailReturBinding()),
                  GetPage(
                      name: '/distributor',
                      page: () => const Distributor()),
                ],
              ),
            );
          }),
    );
  }
}

class SomethingWentWrong extends StatelessWidget {
  const SomethingWentWrong({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQueryData.fromWindow(WidgetsBinding.instance.window),
      child: ScreenUtilInit(
          designSize: const Size(375, 731),
          splitScreenMode: true,
          minTextAdapt: true,
          builder: () {
            return GetMaterialApp(
              builder: (context, myWidget) {
                ScreenUtil.setContext(context);
                myWidget = EasyLoading.init()(context, myWidget);
                return MediaQuery(
                  //Setting font does not change with system font size
                  data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                  child: myWidget,
                );
              },
              title: 'Sales Herbani',
              theme: ThemeData(
                primaryColor: primaryColor,
                scrollbarTheme: const ScrollbarThemeData().copyWith(
                  thumbColor:
                      MaterialStateProperty.all(const Color(0xFF00B6F1)),
                ),
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
              debugShowCheckedModeBanner: false,

              home: SplashScreen(),
              defaultTransition: Transition.rightToLeftWithFade,
              // showPerformanceOverlay: true,

              transitionDuration: const Duration(
                milliseconds: 275,
              ),
            );
          }),
    );
  }
}

class ErrorPageInit extends StatelessWidget {
  const ErrorPageInit({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBarDefault(
        title: 'Something Error',
      ),
      body: Center(
        child: Text('Something Error, Please restart app'),
      ),
    );
  }
}
