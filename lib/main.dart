import 'package:amanu/firebase_options.dart';
import 'package:amanu/screens/home_screen/drawer_launcher.dart';
import 'package:amanu/utils/application_controller.dart';
import 'package:amanu/utils/auth/authentication_repository.dart';
import 'package:amanu/utils/constants/theme_data.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then((value) => Get.put(AuthenticationRepository()))
      .then((value) => Get.put(ApplicationController()));
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent),
  );
  runApp(const Amanu());
}

//Root widget
class Amanu extends StatelessWidget {
  const Amanu({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Amanu: Kapampangan Dictionary and Kulitan Script Reader',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      home: DrawerLauncher(
        pageIndex: 0,
      ),
    );
  }
}
