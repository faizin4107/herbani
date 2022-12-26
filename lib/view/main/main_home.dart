// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:herbani/helper/textstyle_custom.dart';
// import 'package:herbani/view/home/home.dart';
// import 'package:herbani/widget/appbar/appbar_default.dart';
// import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

// class MainHome extends StatefulWidget {
//   const MainHome({Key? key}) : super(key: key);

//   @override
//   // ignore: library_private_types_in_public_api
//   _MainHomeState createState() => _MainHomeState();
// }

// class _MainHomeState extends State<MainHome>
//     with SingleTickerProviderStateMixin {
//   int _currentIndex = 0;
//   PersistentTabController? _controller;
//   ScrollController controller = ScrollController();
//   bool closeTopContainer = false;
//   double topContainer = 0;
//   // ignore: prefer_typing_uninitialized_variables
//   var imageProfile;
//   // final FontSizeController fontSize = Get.find();
//   // final AccountController account = Get.find();
//   @override
//   void initState() {
//     setIndex();
//     setState(() {
//       _controller = PersistentTabController(initialIndex: _currentIndex);
//       controller.addListener(() {
//         double value = controller.offset / 119;
//         setState(() {
//           topContainer = value;
//           closeTopContainer = controller.offset > 50;
//         });
//       });
//     });
//     super.initState();
//   }

//   // final InfoController info = Get.put(InfoController());
//   void setIndex() async {
//     // if (info.refreshAll.value) {
//     //   refreshAllController();
//     //   await Future.delayed(Duration(seconds: 5)).whenComplete(() {
//     //     info.setRefreshAll(false);
//     //   });
//     // }

//     // if (info.isRouteAccount.value == true) {
//     //   setState(() {
//     //     _currentIndex = 4;
//     //   });
//     //   await Future.delayed(Duration(seconds: 1)).whenComplete(() {
//     //     info.setRouteAccount(false);
//     //   });
//     // } else if (info.isRouteDashboard.value) {
//     //   setState(() {
//     //     _currentIndex = 1;
//     //   });
//     //   await Future.delayed(Duration(seconds: 1)).whenComplete(() {
//     //     info.setRouteDashboard(false);
//     //   });
//     // } else if (info.isRouteNotification.value) {
//     //   setState(() {
//     //     _currentIndex = 3;
//     //   });
//     //   await Future.delayed(Duration(seconds: 1)).whenComplete(() {
//     //     info.setRouteNotification(false);
//     //   });
//     // }
//   }

//   List<Widget> _buildScreens() {
//     return [
//      const Home(),
//      const Home(),
//       // Dashboard(),
//       // SearchEmployee(),
//       // NotificationList(),
//       // Account(),
//     ];
//   }

//   List<PersistentBottomNavBarItem> _navBarsItems() {
//     return [
//       PersistentBottomNavBarItem(
//         icon: const Icon(Icons.home),
//         title: "Beranda",
//         textStyle: textStyleCustom(
//           context,
//           const Color(0xFF00B6F1),
//           12.sp,
//           FontWeight.w500,
//         ),
//         inactiveColorSecondary: const Color(0xFF838383),
//         activeColorPrimary: const Color(0xFF00B6F1),
//         inactiveColorPrimary: const Color(0xFF838383),
//       ),

//       PersistentBottomNavBarItem(
//         icon: const Icon(Icons.person),
//         title: "Akun",
//         textStyle: textStyleCustom(
//           context,
//           const Color(0xFF00B6F1),
//           12.sp,
//           FontWeight.w500,
//         ),
//         inactiveColorSecondary: const Color(0xFF838383),
//         activeColorPrimary: const Color(0xFF00B6F1),
//         inactiveColorPrimary: Color(0xFF838383),
//       ),

//       // PersistentBottomNavBarItem(
//       //   icon: SvgPicture.asset(
//       //     'assets/img/logo/logo-orange-white.svg',
//       //     fit: BoxFit.cover,
//       //     height: 28.h,
//       //     width: 28.w,
//       //   ),
//       //   title: info.language.value == 'en' ? "Search" : "Cari",
//       //   textStyle: fontSize.fontSizeCustom(
//       //       'Roboto-regular', Color(0xFF00B6F1), FontWeight.w500, 12.sp),
//       //   inactiveColorSecondary: Color(0xFF838383),
//       //   activeColorPrimary: Color(0xFF00B6F1),
//       //   inactiveColorPrimary: Color(0xFF838383),
//       //   onPressed: (context) async {
//       //     Get.put(DetailController()).getData('/employee/search', null);
//       //     Get.toNamed('/search_employee');
//       //   },
//       // ),
//       // PersistentBottomNavBarItem(
//       //   icon: Icon(CustomNotificationIcon.bell, size: 20),
//       //   title: info.language.value == 'en' ? "Notification" : "Notifikasi",
//       //   textStyle: fontSize.fontSizeCustom(
//       //       'Roboto-regular', Color(0xFF00B6F1), FontWeight.w500, 12.sp),
//       //   inactiveColorSecondary: Color(0xFF838383),
//       //   activeColorPrimary: Color(0xFF00B6F1),
//       //   inactiveColorPrimary: Color(0xFF838383),
//       // ),
//       // PersistentBottomNavBarItem(
//       //   icon: Icon(CustomAccountIcon.account, size: 20),
//       //   title: info.language.value == 'en' ? "Account" : "Akun",
//       //   textStyle: fontSize.fontSizeCustom(
//       //       'Roboto-regular', Color(0xFF00B6F1), FontWeight.w500, 12.sp),
//       //   inactiveColorSecondary: Color(0xFF838383),
//       //   activeColorPrimary: Color(0xFF00B6F1),
//       //   inactiveColorPrimary: Color(0xFF838383),
//       // ),
//     ];
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBarDefault(
//         title: 'PT. Herbani Medika Nusantara',
//       ),
//       body: PersistentTabView(
//         context,
//         controller: _controller,
//         screens: _buildScreens(),
//         items: _navBarsItems(),
//         confineInSafeArea: true,
//         backgroundColor: Colors.white,
//         handleAndroidBackButtonPress: true,
//         resizeToAvoidBottomInset: true,
//         stateManagement: true,
//         hideNavigationBarWhenKeyboardShows: true,
//         decoration: NavBarDecoration(
//           borderRadius: BorderRadius.circular(10.0),
//           colorBehindNavBar: Colors.white,
//           boxShadow: <BoxShadow>[
//             BoxShadow(
//               color: Color.fromRGBO(0, 0, 0, 0.2),
//               offset: Offset(0, 2),
//               blurRadius: 4,
//             )
//           ],
//         ),
//         popAllScreensOnTapOfSelectedTab: true,
//         popActionScreens: PopActionScreensType.all,
//         itemAnimationProperties: ItemAnimationProperties(
//           duration: Duration(milliseconds: 200),
//           curve: Curves.ease,
//         ),
//         screenTransitionAnimation: ScreenTransitionAnimation(
//           animateTabTransition: true,
//           curve: Curves.ease,
//           duration: Duration(milliseconds: 200),
//         ),
//         bottomScreenMargin: 0.0,
//         navBarStyle: NavBarStyle.style12,
//         onItemSelected: (value) {
//           setState(() {
//             _currentIndex = value;
//           });
//         },
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _controller?.dispose();
//     super.dispose();
//   }
// }
