import 'package:amanu/screens/splash_screen/splash_screen.dart';
import 'package:amanu/utils/constants/app_colors.dart';
import 'package:amanu/utils/constants/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: primaryOrangeDark,
        systemNavigationBarIconBrightness: Brightness.light),
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const Amanu());
}

//Root widget
class Amanu extends StatelessWidget {
  const Amanu({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Amánu: Kapampangan Dictionary and Kulitan Script Reader',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      home: SplashScreen(),
    );
  }
}
